import 'dart:async';

import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/core/services/clock.dart';
import 'package:xchat/core/services/id_generator.dart';
import 'package:xchat/core/usecases/usecase.dart';
import 'package:xchat/features/messaging/domain/entities/attachment.dart';
import 'package:xchat/features/messaging/domain/entities/message.dart';
import 'package:xchat/features/messaging/domain/repositories/message_repository.dart';
import 'package:xchat/features/messaging/domain/repositories/outbox_repository.dart';
import 'package:fpdart/fpdart.dart';

final class SendMessageParams {
  const SendMessageParams({
    required this.conversationId,
    required this.senderId,
    this.text,
    this.attachments = const [],
    this.replyToId,
  });

  final String conversationId;
  final String senderId;
  final String? text;
  final List<Attachment> attachments;
  final String? replyToId;
}

/// Validates, stores a `pending` message locally (optimistic UI) and
/// triggers the outbox. Returns as soon as the message is stored locally.
final class SendMessage implements UseCase<Message, SendMessageParams> {
  SendMessage({
    required MessageRepository messages,
    required OutboxRepository outbox,
    required IdGenerator ids,
    required Clock clock,
  })  : _messages = messages,
        _outbox = outbox,
        _ids = ids,
        _clock = clock;

  static const maxTextLength = 4096;

  final MessageRepository _messages;
  final OutboxRepository _outbox;
  final IdGenerator _ids;
  final Clock _clock;

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) async {
    final text = params.text?.trim() ?? '';
    if (text.isEmpty && params.attachments.isEmpty) {
      return Either.left(const ValidationFailure('Message is empty'));
    }
    if (text.length > maxTextLength) {
      return Either.left(const ValidationFailure('Message is too long'));
    }

    final message = Message(
      id: _ids.newId(),
      conversationId: params.conversationId,
      senderId: params.senderId,
      type: _typeFor(params.attachments),
      status: MessageStatus.pending,
      createdAt: _clock.now(),
      text: text.isEmpty ? null : text,
      attachments: params.attachments,
      replyToId: params.replyToId,
    );

    final stored = await _messages.enqueueSend(message);
    return stored.fold(
      (failure) => Either<Failure, Message>.left(failure),
      (_) {
        unawaited(_outbox.flush());
        return Either<Failure, Message>.right(message);
      },
    );
  }

  MessageType _typeFor(List<Attachment> attachments) {
    if (attachments.isEmpty) return MessageType.text;
    return switch (attachments.first.kind) {
      AttachmentKind.image => MessageType.image,
      AttachmentKind.video => MessageType.video,
      AttachmentKind.audio => MessageType.audio,
      AttachmentKind.voice => MessageType.voice,
      AttachmentKind.videoNote => MessageType.videoNote,
      AttachmentKind.document => MessageType.document,
      AttachmentKind.sticker => MessageType.sticker,
      AttachmentKind.gif => MessageType.gif,
    };
  }
}
