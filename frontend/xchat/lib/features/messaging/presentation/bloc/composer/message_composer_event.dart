import 'package:xchat/features/messaging/domain/entities/attachment.dart';
import 'package:xchat/features/messaging/domain/entities/message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_composer_event.freezed.dart';

@freezed
sealed class MessageComposerEvent with _$MessageComposerEvent {
  const factory MessageComposerEvent.started() = ComposerStarted;
  const factory MessageComposerEvent.textChanged(String text) = ComposerTextChanged;
  const factory MessageComposerEvent.replySet(Message message) = ComposerReplySet;
  const factory MessageComposerEvent.replyCleared() = ComposerReplyCleared;
  const factory MessageComposerEvent.editStarted(Message message) = ComposerEditStarted;
  const factory MessageComposerEvent.editCancelled() = ComposerEditCancelled;
  const factory MessageComposerEvent.attachmentAdded(Attachment attachment) = ComposerAttachmentAdded;
  const factory MessageComposerEvent.attachmentRemoved(String attachmentId) = ComposerAttachmentRemoved;
  const factory MessageComposerEvent.sendPressed() = ComposerSendPressed;
  const factory MessageComposerEvent.failureDismissed() = ComposerFailureDismissed;

  /// Internal: debounced persistence of the draft text.
  const factory MessageComposerEvent.draftFlushRequested() = ComposerDraftFlushRequested;
}
