import 'package:xchat/features/messaging/data/models/message_model.dart';

abstract interface class MessageRemoteDataSource {
  /// Newest-first page. With [before], returns messages older than it.
  Future<List<MessageModel>> fetchPage(String conversationId, {DateTime? before, int limit = 30});

  /// Oldest-first messages strictly newer than [after] (catch-up).
  Future<List<MessageModel>> fetchAfter(String conversationId, DateTime after, {int limit = 100});

  /// Returns the row even if soft-deleted (so callers can see `deletedAt`).
  Future<MessageModel?> fetchById(String id);

  /// Idempotent: safe to retry with the same client-generated id.
  Future<MessageModel> send(MessageModel model);

  Future<void> updateText(String id, String text);
  Future<void> softDelete(String id);
  Future<void> setReaction({required String messageId, required String emoji, required bool add});
  Future<void> markRead({required List<String> messageIds});
}
