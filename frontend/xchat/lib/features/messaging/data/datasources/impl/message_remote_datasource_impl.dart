import 'package:xchat/core/errors/exceptions.dart';
import 'package:xchat/core/gateways/backend_gateway.dart';
import 'package:xchat/core/services/clock.dart';
import 'package:xchat/features/messaging/data/datasources/message_remote_datasource.dart';
import 'package:xchat/features/messaging/data/models/message_model.dart';

final class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  MessageRemoteDataSourceImpl(this._gateway, this._clock);
  final BackendGateway _gateway;
  final Clock _clock;

  static const _messages = 'messages';
  static const _columns = '*, message_attachments(*), message_reactions(user_id, emoji)';

  @override
  Future<List<MessageModel>> fetchPage(String conversationId, {DateTime? before, int limit = 30}) async {
    final rows = await _gateway.select(
      _messages,
      columns: _columns,
      filters: [
        BackendFilter.eq('conversation_id', conversationId),
        const BackendFilter.isNull('deleted_at'),
        if (before != null) BackendFilter.lt('created_at', before.toUtc().toIso8601String()),
      ],
      order: const BackendOrder('created_at', ascending: false),
      limit: limit,
    );
    return rows.map(MessageModel.fromJson).toList();
  }

  @override
  Future<List<MessageModel>> fetchAfter(String conversationId, DateTime after, {int limit = 100}) async {
    final rows = await _gateway.select(
      _messages,
      columns: _columns,
      filters: [
        BackendFilter.eq('conversation_id', conversationId),
        const BackendFilter.isNull('deleted_at'),
        BackendFilter.gt('created_at', after.toUtc().toIso8601String()),
      ],
      order: const BackendOrder('created_at'),
      limit: limit,
    );
    return rows.map(MessageModel.fromJson).toList();
  }

  @override
  Future<MessageModel?> fetchById(String id) async {
    final rows = await _gateway.select(
      _messages,
      columns: _columns,
      filters: [BackendFilter.eq('id', id)],
      limit: 1,
    );
    return rows.isEmpty ? null : MessageModel.fromJson(rows.first);
  }

  @override
  Future<MessageModel> send(MessageModel model) async {
    await _gateway.upsert(_messages, model.toInsertJson(), onConflict: 'id');
    if (model.attachments.isNotEmpty) {
      await _gateway.upsertAll(
        'message_attachments',
        [for (final a in model.attachments) a.toJson(messageId: model.id)],
        onConflict: 'id',
      );
    }
    final saved = await fetchById(model.id);
    if (saved == null) throw const ServerException('Message was not stored');
    return saved;
  }

  @override
  Future<void> updateText(String id, String text) => _gateway.update(
        _messages,
        {'text': text, 'edited_at': _clock.now().toIso8601String()},
        filters: [BackendFilter.eq('id', id)],
      );

  @override
  Future<void> softDelete(String id) => _gateway.update(
        _messages,
        {'deleted_at': _clock.now().toIso8601String()},
        filters: [BackendFilter.eq('id', id)],
      );

  @override
  Future<void> setReaction({required String messageId, required String emoji, required bool add}) {
    final userId = _requireUser();
    if (add) {
      return _gateway.upsert(
        'message_reactions',
        {'message_id': messageId, 'user_id': userId, 'emoji': emoji},
        onConflict: 'message_id,user_id,emoji',
      );
    }
    return _gateway.delete('message_reactions', filters: [
      BackendFilter.eq('message_id', messageId),
      BackendFilter.eq('user_id', userId),
      BackendFilter.eq('emoji', emoji),
    ]);
  }

  @override
  Future<void> markRead({required List<String> messageIds}) {
    if (messageIds.isEmpty) return Future<void>.value();
    final userId = _requireUser();
    final now = _clock.now().toIso8601String();
    return _gateway.upsertAll(
      'message_reads',
      [for (final id in messageIds) {'message_id': id, 'user_id': userId, 'read_at': now}],
      onConflict: 'message_id,user_id',
    );
  }

  String _requireUser() => _gateway.currentUserId ?? (throw const UnauthorizedException());
}
