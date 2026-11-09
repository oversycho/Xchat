import 'package:equatable/equatable.dart';

final class Reaction extends Equatable {
  const Reaction({required this.userId, required this.emoji});
  final String userId;
  final String emoji;

  @override
  List<Object?> get props => [userId, emoji];
}
