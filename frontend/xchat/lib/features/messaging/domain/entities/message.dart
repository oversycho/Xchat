import 'package:xchat/features/messaging/domain/entities/attachment.dart';
import 'package:xchat/features/messaging/domain/entities/reaction.dart';
import 'package:equatable/equatable.dart';

/// `delivered` is intentionally absent: it must not exist until a real
/// delivery acknowledgment is implemented end to end.
enum MessageStatus { pending, sending, sent, read, failed }

/// Location and contact messages need payload fields and are added later.
enum MessageType { text, image, video, audio, voice, videoNote, document, sticker, gif, system }

final class Message extends Equatable {
  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.type,
    required this.status,
    required this.createdAt,
    this.text,
    this.attachments = const [],
    this.replyToId,
    this.editedAt,
    this.reactions = const [],
    this.failureReason,
  });

  /// Client-generated UUID, also the server primary key (idempotent sends).
  final String id;
  final String conversationId;
  final String senderId;
  final MessageType type;
  final MessageStatus status;
  final DateTime createdAt;
  final String? text;
  final List<Attachment> attachments;
  final String? replyToId;
  final DateTime? editedAt;
  final List<Reaction> reactions;
  final String? failureReason;

  bool get isEdited => editedAt != null;

  @override
  List<Object?> get props => [
        id, conversationId, senderId, type, status, createdAt,
        text, attachments, replyToId, editedAt, reactions, failureReason,
      ];
}
