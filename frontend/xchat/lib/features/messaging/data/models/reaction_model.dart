final class ReactionModel {
  const ReactionModel({required this.userId, required this.emoji});
  final String userId;
  final String emoji;

  factory ReactionModel.fromJson(Map<String, dynamic> json) =>
      ReactionModel(userId: json['user_id'] as String, emoji: json['emoji'] as String);

  Map<String, dynamic> toJson() => {'user_id': userId, 'emoji': emoji};
}
