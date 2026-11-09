import 'package:xchat/core/errors/failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_list_event.freezed.dart';

@freezed
sealed class MessageListEvent with _$MessageListEvent {
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
}
