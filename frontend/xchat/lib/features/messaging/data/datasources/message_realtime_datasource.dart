enum MessageChangeType { inserted, updated, deleted, resync }

final class MessageChange {
  const MessageChange(this.type, {this.messageId});
  final MessageChangeType type;
  final String? messageId;
}

abstract interface class MessageRealtimeDataSource {
  /// Lifecycle-aware: the channel exists only while the stream is listened to.
  Stream<MessageChange> watch(String conversationId);
}
