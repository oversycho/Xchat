import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/features/messaging/domain/entities/message.dart';
import 'package:fpdart/fpdart.dart';

final class PageResult {
  const PageResult({required this.fetched, required this.hasMore});
  final int fetched;
  final bool hasMore;
}

abstract interface class MessageRepository {
  /// The local database is the single source of truth. Emits newest-first.
  Stream<List<Message>> watchMessages(String conversationId);

  /// Catches the local cache up with the server (initial load / after reconnect).
  Future<Either<Failure, void>> refreshLatest(String conversationId);

  /// Fetches the next page of older messages into the local cache.
  Future<Either<Failure, PageResult>> loadOlder(String conversationId, {int limit = 30});

  /// Stores a `pending` message locally. Delivery is the outbox's job.
  Future<Either<Failure, void>> enqueueSend(Message message);

  Future<Either<Failure, void>> edit(String messageId, String newText);
  Future<Either<Failure, void>> delete(String messageId);
  Future<Either<Failure, void>> setReaction({
    required String messageId,
    required String emoji,
    required bool add,
  });
  Future<Either<Failure, void>> markRead({required List<String> messageIds});

  /// One realtime subscription per conversation; both calls are idempotent.
  Future<Either<Failure, void>> startRealtime(String conversationId);
  Future<Either<Failure, void>> stopRealtime(String conversationId);
}
