import 'package:equatable/equatable.dart';

final class Draft extends Equatable {
  const Draft({required this.conversationId, required this.text, required this.updatedAt});
  final String conversationId;
  final String text;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [conversationId, text, updatedAt];
}
