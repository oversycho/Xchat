import 'package:equatable/equatable.dart';

final class AuthUser extends Equatable {
  const AuthUser({required this.id, this.phone});
  final String id;
  final String? phone;

  @override
  List<Object?> get props => [id, phone];
}
