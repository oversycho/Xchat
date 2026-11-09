import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/features/messaging/domain/entities/attachment.dart';
import 'package:xchat/features/messaging/domain/entities/message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_composer_state.freezed.dart';

@freezed
abstract class MessageComposerState with _$MessageComposerState {
  const MessageComposerState._();

  const factory MessageComposerState({
    @Default('') String text,
    Message? replyTo,
    Message? editing,

    /// Text that was in the composer before edit mode started (restored on cancel).
    String? textBeforeEdit,
    @Default(<Attachment>[]) List<Attachment> attachments,
    @Default(false) bool isSending,
    Failure? failure,
  }) = _MessageComposerState;

  bool get isEditing => editing != null;

  bool get canSend =>
      !isSending && (text.trim().isNotEmpty || (attachments.isNotEmpty && !isEditing));
}
