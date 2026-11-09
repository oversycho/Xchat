import 'package:xchat/features/messaging/data/models/message_model.dart';

abstract interface class MessageLocalDataSource {
  /// Newest-first, including soft-deleted rows (repository filters them).
  Stream<List<MessageModel>> watch(String conversationId);

  Future<void> upsertAll(List<MessageModel> models);
  Future<MessageModel?> getById(String id);
  Future<List<MessageModel>> getByIds(List<String> ids);
  Future<void> updateStatus(String id, String status, {String? failureReason});
  Future<void> deleteById(String id);

  /// Messages waiting to be sent, oldest first.
  Future<List<MessageModel>> pending();
  Future<void> resetSendingToPending();

  /// Cursors computed over messages that exist on the server (sent/read).
  Future<DateTime?> oldestSyncedCreatedAt(String conversationId);
  Future<DateTime?> newestSyncedCreatedAt(String conversationId);
}
