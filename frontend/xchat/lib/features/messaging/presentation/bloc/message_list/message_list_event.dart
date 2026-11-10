import 'package:equatable/equatable.dart';
import 'package:xchat/core/errors/failures.dart';

sealed class MessageListEvent extends Equatable {
  const MessageListEvent();

  const factory MessageListEvent.started() = MessageListStarted;
  const factory MessageListEvent.olderRequested() = MessageListOlderRequested;
  const factory MessageListEvent.deleteRequested(String messageId) = MessageListDeleteRequested;
  const factory MessageListEvent.reactionToggled({
    required String messageId,
    required String emoji,
  }) = MessageListReactionToggled;
  const factory MessageListEvent.retryRequested(String messageId) = MessageListRetryRequested;
  const factory MessageListEvent.failureDismissed() = MessageListFailureDismissed;

  /// Internal: dispatched by the bloc when the background sync fails.
  const factory MessageListEvent.syncFailed(Failure failure) = MessageListSyncFailed;

  @override
  List<Object?> get props => const [];
}

final class MessageListStarted extends MessageListEvent {
  const MessageListStarted();
}

final class MessageListOlderRequested extends MessageListEvent {
  const MessageListOlderRequested();
}

final class MessageListDeleteRequested extends MessageListEvent {
  const MessageListDeleteRequested(this.messageId);
  final String messageId;

  @override
  List<Object?> get props => [messageId];
}

final class MessageListReactionToggled extends MessageListEvent {
  const MessageListReactionToggled({required this.messageId, required this.emoji});
  final String messageId;
  final String emoji;

  @override
  List<Object?> get props => [messageId, emoji];
}

final class MessageListRetryRequested extends MessageListEvent {
  const MessageListRetryRequested(this.messageId);
  final String messageId;

  @override
  List<Object?> get props => [messageId];
}

final class MessageListFailureDismissed extends MessageListEvent {
  const MessageListFailureDismissed();
}

final class MessageListSyncFailed extends MessageListEvent {
  const MessageListSyncFailed(this.failure);
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
