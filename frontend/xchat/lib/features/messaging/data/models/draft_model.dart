final class DraftModel {
  const DraftModel({required this.conversationId, required this.text, required this.updatedAt});
  final String conversationId;
  final String text;
  final DateTime updatedAt;

  factory DraftModel.fromJson(Map<String, dynamic> json) => DraftModel(
        conversationId: json['conversation_id'] as String,
        text: json['text'] as String,
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'conversation_id': conversationId,
        'text': text,
        'updated_at': updatedAt.toUtc().toIso8601String(),
      };
}
