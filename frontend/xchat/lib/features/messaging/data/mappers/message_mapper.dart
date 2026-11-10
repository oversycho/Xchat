import 'package:xchat/core/mappers/entity_mapper.dart';
import 'package:xchat/features/messaging/data/models/attachment_model.dart';
import 'package:xchat/features/messaging/data/models/message_model.dart';
import 'package:xchat/features/messaging/data/models/reaction_model.dart';
import 'package:xchat/features/messaging/domain/entities/attachment.dart';
import 'package:xchat/features/messaging/domain/entities/message.dart';
import 'package:xchat/features/messaging/domain/entities/reaction.dart';

final class MessageMapper implements EntityMapper<MessageModel, Message> {
  const MessageMapper();

  /// The database stores enum labels in snake_case (`video_note`);
  /// Dart enums are camelCase (`videoNote`).
  static String _fromWire(String snake) =>
      snake.replaceAllMapped(RegExp(r'_([a-z])'), (m) => m[1]!.toUpperCase());

  static String _toWire(String camel) =>
      camel.replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

  @override
  Message toEntity(MessageModel m) => Message(
    id: m.id,
    conversationId: m.conversationId,
    senderId: m.senderId,
    type: MessageType.values.asNameMap()[_fromWire(m.type)] ?? MessageType.system,
    status: MessageStatus.values.asNameMap()[m.status] ?? MessageStatus.sent,
    createdAt: m.createdAt,
    text: m.text,
    replyToId: m.replyToId,
    editedAt: m.editedAt,
    failureReason: m.failureReason,
    attachments: [
      for (final a in m.attachments)
        Attachment(
          id: a.id,
          kind: AttachmentKind.values.asNameMap()[_fromWire(a.kind)] ?? AttachmentKind.document,
          storagePath: a.storagePath,
          mimeType: a.mimeType,
          sizeBytes: a.sizeBytes,
          width: a.width,
          height: a.height,
          durationMs: a.durationMs,
        ),
    ],
    reactions: [for (final r in m.reactions) Reaction(userId: r.userId, emoji: r.emoji)],
  );

  @override
  MessageModel toModel(Message e) => MessageModel(
    id: e.id,
    conversationId: e.conversationId,
    senderId: e.senderId,
    type: _toWire(e.type.name),
    status: e.status.name,
    createdAt: e.createdAt,
    text: e.text,
    replyToId: e.replyToId,
    editedAt: e.editedAt,
    failureReason: e.failureReason,
    attachments: [
      for (final a in e.attachments)
        AttachmentModel(
          id: a.id,
          kind: _toWire(a.kind.name),
          storagePath: a.storagePath,
          mimeType: a.mimeType,
          sizeBytes: a.sizeBytes,
          width: a.width,
          height: a.height,
          durationMs: a.durationMs,
        ),
    ],
    reactions: [for (final r in e.reactions) ReactionModel(userId: r.userId, emoji: r.emoji)],
  );
}
