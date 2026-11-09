import 'package:xchat/features/messaging/data/models/attachment_model.dart';
import 'package:xchat/features/messaging/data/models/reaction_model.dart';

/// Data-layer representation of a message. Used for both the remote row
/// (`messages` + embedded `message_attachments` / `message_reactions`)
/// and the local cache document. Never exposed outside the data layer.
final class MessageModel {
  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.type,
    required this.status,
    required this.createdAt,
    this.text,
    this.replyToId,
    this.editedAt,
    this.deletedAt,
    this.attachments = const [],
    this.reactions = const [],
    this.failureReason,
  });

  final String id;
  final String conversationId;
  final String senderId;
  final String type;
  final String status;
  final DateTime createdAt;
  final String? text;
  final String? replyToId;
  final DateTime? editedAt;
  final DateTime? deletedAt;
  final List<AttachmentModel> attachments;
  final List<ReactionModel> reactions;
  final String? failureReason;

  /// Accepts a remote row (with embedded relations) or a local document.
  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'] as String,
        conversationId: json['conversation_id'] as String,
        senderId: json['sender_id'] as String,
        type: json['type'] as String,
        status: (json['status'] as String?) ?? 'sent',
        createdAt: DateTime.parse(json['created_at'] as String),
        text: json['text'] as String?,
        replyToId: json['reply_to_id'] as String?,
        editedAt: _date(json['edited_at']),
        deletedAt: _date(json['deleted_at']),
        attachments: [
          for (final a in (json['message_attachments'] as List<dynamic>? ?? const []))
            AttachmentModel.fromJson(Map<String, dynamic>.from(a as Map)),
        ],
        reactions: [
          for (final r in (json['message_reactions'] as List<dynamic>? ?? const []))
            ReactionModel.fromJson(Map<String, dynamic>.from(r as Map)),
        ],
        failureReason: json['failure_reason'] as String?,
      );

  /// Full document, used for the local cache.
  Map<String, dynamic> toJson() => {
        'id': id,
        'conversation_id': conversationId,
        'sender_id': senderId,
        'type': type,
        'status': status,
        'created_at': createdAt.toUtc().toIso8601String(),
        'text': text,
        'reply_to_id': replyToId,
        'edited_at': editedAt?.toUtc().toIso8601String(),
        'deleted_at': deletedAt?.toUtc().toIso8601String(),
        'message_attachments': [for (final a in attachments) a.toJson()],
        'message_reactions': [for (final r in reactions) r.toJson()],
        'failure_reason': failureReason,
      };

  /// Columns the client may write on insert. `created_at` and `status`
  /// are server-controlled.
  Map<String, dynamic> toInsertJson() => {
        'id': id,
        'conversation_id': conversationId,
        'sender_id': senderId,
        'type': type,
        'text': text,
        'reply_to_id': replyToId,
      };

  MessageModel withStatus(String newStatus, {String? failureReason}) => MessageModel(
        id: id,
        conversationId: conversationId,
        senderId: senderId,
        type: type,
        status: newStatus,
        createdAt: createdAt,
        text: text,
        replyToId: replyToId,
        editedAt: editedAt,
        deletedAt: deletedAt,
        attachments: attachments,
        reactions: reactions,
        failureReason: failureReason,
      );

  static DateTime? _date(Object? value) => value == null ? null : DateTime.parse(value as String);
}
