import 'package:equatable/equatable.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/features/messaging/domain/entities/attachment.dart';
import 'package:xchat/features/messaging/domain/entities/message.dart';

final class MessageComposerState extends Equatable {
  const MessageComposerState({
    this.text = '',
    this.replyTo,
    this.editing,
    this.textBeforeEdit,
    this.attachments = const [],
    this.isSending = false,
    this.failure,
  });

  final String text;
  final Message? replyTo;
  final Message? editing;

  /// Text that was in the composer before edit mode started (restored on cancel).
  final String? textBeforeEdit;
  final List<Attachment> attachments;
  final bool isSending;
  final Failure? failure;

  bool get isEditing => editing != null;

  bool get canSend =>
      !isSending && (text.trim().isNotEmpty || (attachments.isNotEmpty && !isEditing));

  /// Nullable fields keep their value unless the matching `clear...` flag is set.
  MessageComposerState copyWith({
    String? text,
    Message? replyTo,
    Message? editing,
    String? textBeforeEdit,
    List<Attachment>? attachments,
    bool? isSending,
    Failure? failure,
    bool clearReplyTo = false,
    bool clearEditing = false,
    bool clearTextBeforeEdit = false,
    bool clearFailure = false,
  }) => MessageComposerState(
    text: text ?? this.text,
    replyTo: clearReplyTo ? null : (replyTo ?? this.replyTo),
    editing: clearEditing ? null : (editing ?? this.editing),
    textBeforeEdit: clearTextBeforeEdit ? null : (textBeforeEdit ?? this.textBeforeEdit),
    attachments: attachments ?? this.attachments,
    isSending: isSending ?? this.isSending,
    failure: clearFailure ? null : (failure ?? this.failure),
  );

  @override
  List<Object?> get props => [
    text,
    replyTo,
    editing,
    textBeforeEdit,
    attachments,
    isSending,
    failure,
  ];
}
