import 'package:equatable/equatable.dart';
import 'package:xchat/features/messaging/domain/entities/attachment.dart';
import 'package:xchat/features/messaging/domain/entities/message.dart';

sealed class MessageComposerEvent extends Equatable {
  const MessageComposerEvent();

  const factory MessageComposerEvent.started() = ComposerStarted;
  const factory MessageComposerEvent.textChanged(String text) = ComposerTextChanged;
  const factory MessageComposerEvent.replySet(Message message) = ComposerReplySet;
  const factory MessageComposerEvent.replyCleared() = ComposerReplyCleared;
  const factory MessageComposerEvent.editStarted(Message message) = ComposerEditStarted;
  const factory MessageComposerEvent.editCancelled() = ComposerEditCancelled;
  const factory MessageComposerEvent.attachmentAdded(Attachment attachment) =
      ComposerAttachmentAdded;
  const factory MessageComposerEvent.attachmentRemoved(String attachmentId) =
      ComposerAttachmentRemoved;
  const factory MessageComposerEvent.sendPressed() = ComposerSendPressed;
  const factory MessageComposerEvent.failureDismissed() = ComposerFailureDismissed;

  /// Internal: debounced persistence of the draft text.
  const factory MessageComposerEvent.draftFlushRequested() = ComposerDraftFlushRequested;

  @override
  List<Object?> get props => const [];
}

final class ComposerStarted extends MessageComposerEvent {
  const ComposerStarted();
}

final class ComposerTextChanged extends MessageComposerEvent {
  const ComposerTextChanged(this.text);
  final String text;

  @override
  List<Object?> get props => [text];
}

final class ComposerReplySet extends MessageComposerEvent {
  const ComposerReplySet(this.message);
  final Message message;

  @override
  List<Object?> get props => [message];
}

final class ComposerReplyCleared extends MessageComposerEvent {
  const ComposerReplyCleared();
}

final class ComposerEditStarted extends MessageComposerEvent {
  const ComposerEditStarted(this.message);
  final Message message;

  @override
  List<Object?> get props => [message];
}

final class ComposerEditCancelled extends MessageComposerEvent {
  const ComposerEditCancelled();
}

final class ComposerAttachmentAdded extends MessageComposerEvent {
  const ComposerAttachmentAdded(this.attachment);
  final Attachment attachment;

  @override
  List<Object?> get props => [attachment];
}

final class ComposerAttachmentRemoved extends MessageComposerEvent {
  const ComposerAttachmentRemoved(this.attachmentId);
  final String attachmentId;

  @override
  List<Object?> get props => [attachmentId];
}

final class ComposerSendPressed extends MessageComposerEvent {
  const ComposerSendPressed();
}

final class ComposerFailureDismissed extends MessageComposerEvent {
  const ComposerFailureDismissed();
}

final class ComposerDraftFlushRequested extends MessageComposerEvent {
  const ComposerDraftFlushRequested();
}
