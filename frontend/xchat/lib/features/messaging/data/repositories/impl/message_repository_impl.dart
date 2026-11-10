import 'dart:async';

import 'package:xchat/core/errors/exceptions.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/core/mappers/entity_mapper.dart';
import 'package:xchat/core/utils/guard.dart';
import 'package:xchat/features/messaging/data/datasources/message_local_datasource.dart';
import 'package:xchat/features/messaging/data/datasources/message_realtime_datasource.dart';
import 'package:xchat/features/messaging/data/datasources/message_remote_datasource.dart';
import 'package:xchat/features/messaging/data/models/message_model.dart';
import 'package:xchat/features/messaging/domain/entities/message.dart';
import 'package:xchat/features/messaging/domain/repositories/message_repository.dart';
import 'package:fpdart/fpdart.dart';

final class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl({
    required MessageRemoteDataSource remote,
    required MessageLocalDataSource local,
    required MessageRealtimeDataSource realtime,
    required EntityMapper<MessageModel, Message> mapper,
  }) : _remote = remote,
       _local = local,
       _realtime = realtime,
       _mapper = mapper;

  static const _initialPageSize = 30;
  static const _catchUpBatch = 100;

  final MessageRemoteDataSource _remote;
  final MessageLocalDataSource _local;
  final MessageRealtimeDataSource _realtime;
  final EntityMapper<MessageModel, Message> _mapper;
  final Map<String, StreamSubscription<void>> _subscriptions = {};

  @override
  Stream<List<Message>> watchMessages(String conversationId) => _local
      .watch(conversationId)
      .map(
        (models) => [
          for (final m in models)
            if (m.deletedAt == null) _mapper.toEntity(m),
        ],
      );

  @override
  Future<Either<Failure, void>> refreshLatest(String conversationId) =>
      guard<void>(() => _catchUp(conversationId));

  @override
  Future<Either<Failure, PageResult>> loadOlder(String conversationId, {int limit = 30}) =>
      guard(() async {
        final oldest = await _local.oldestSyncedCreatedAt(conversationId);
        final page = await _remote.fetchPage(conversationId, before: oldest, limit: limit);
        await _storeIncoming(page);
        return PageResult(fetched: page.length, hasMore: page.length >= limit);
      });

  @override
  Future<Either<Failure, void>> enqueueSend(Message message) =>
      guard<void>(() => _local.upsertAll([_mapper.toModel(message)]));

  @override
  Future<Either<Failure, void>> edit(String messageId, String newText) => guard<void>(() async {
    await _remote.updateText(messageId, newText);
    await _refreshOne(messageId);
  });

  @override
  Future<Either<Failure, void>> delete(String messageId) async {
    final local = await _local.getById(messageId);
    if (local?.status == 'sending') {
      return Either.left(const ValidationFailure('Message is being sent'));
    }
    return guard<void>(() async {
      final neverReachedServer =
          local != null && (local.status == 'pending' || local.status == 'failed');
      if (!neverReachedServer) await _remote.softDelete(messageId);
      await _local.deleteById(messageId);
    });
  }

  @override
  Future<Either<Failure, void>> setReaction({
    required String messageId,
    required String emoji,
    required bool add,
  }) => guard<void>(() async {
    await _remote.setReaction(messageId: messageId, emoji: emoji, add: add);
    await _refreshOne(messageId);
  });

  @override
  Future<Either<Failure, void>> markRead({required List<String> messageIds}) =>
      guard<void>(() => _remote.markRead(messageIds: messageIds));

  @override
  Future<Either<Failure, void>> startRealtime(String conversationId) => guard<void>(() async {
    if (_subscriptions.containsKey(conversationId)) return;
    _subscriptions[conversationId] = _realtime
        .watch(conversationId)
        .asyncMap((change) => _handleChange(conversationId, change))
        .listen((_) {}, onError: (Object _) {});
  });

  @override
  Future<Either<Failure, void>> stopRealtime(String conversationId) => guard<void>(() async {
    await _subscriptions.remove(conversationId)?.cancel();
  });

  // ---- internals ----

  Future<void> _catchUp(String conversationId) async {
    final newest = await _local.newestSyncedCreatedAt(conversationId);
    if (newest == null) {
      await _storeIncoming(await _remote.fetchPage(conversationId, limit: _initialPageSize));
      return;
    }
    var cursor = newest;
    while (true) {
      final batch = await _remote.fetchAfter(conversationId, cursor, limit: _catchUpBatch);
      if (batch.isEmpty) return;
      await _storeIncoming(batch);
      if (batch.length < _catchUpBatch) return;
      cursor = batch.last.createdAt;
    }
  }

  Future<void> _refreshOne(String messageId) async {
    final model = await _remote.fetchById(messageId);
    if (model == null) return;
    if (model.deletedAt != null) {
      await _local.deleteById(model.id);
    } else {
      await _storeIncoming([model]);
    }
  }

  Future<void> _handleChange(String conversationId, MessageChange change) async {
    try {
      final id = change.messageId;
      switch (change.type) {
        case MessageChangeType.inserted:
        case MessageChangeType.updated:
          if (id != null) await _refreshOne(id);
        case MessageChangeType.deleted:
          if (id != null) await _local.deleteById(id);
        case MessageChangeType.resync:
          await _catchUp(conversationId);
      }
    } on AppException {
      // Transient: the next event or the next catch-up repairs the cache.
    }
  }

  /// Idempotent merge: duplicates collapse by id and a message never
  /// regresses to a lower status (e.g. `read` is not overwritten by `sent`).
  Future<void> _storeIncoming(List<MessageModel> incoming) async {
    if (incoming.isEmpty) return;
    final existing = {
      for (final m in await _local.getByIds([for (final m in incoming) m.id])) m.id: m,
    };
    final merged = [
      for (final m in incoming)
        if (existing[m.id] case final local? when _rank(local.status) > _rank(m.status))
          m.withStatus(local.status)
        else
          m,
    ];
    await _local.upsertAll(merged);
  }

  int _rank(String status) => switch (status) {
    'pending' => 0,
    'sending' || 'failed' => 1,
    'sent' => 2,
    'read' => 3,
    _ => 2,
  };
}
