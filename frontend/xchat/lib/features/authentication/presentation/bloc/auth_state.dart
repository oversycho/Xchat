import 'package:equatable/equatable.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/features/authentication/domain/entities/auth_user.dart';

enum AuthStep { enterPhone, enterCode }

sealed class AuthState extends Equatable {
  const AuthState();

  /// App just started; the first authentication event has not arrived yet.
  const factory AuthState.unknown() = AuthUnknown;

  const factory AuthState.unauthenticated({
    AuthStep step,
    String? phone,
    bool isBusy,
    Failure? failure,
  }) = AuthUnauthenticated;

  const factory AuthState.authenticated({required AuthUser user, bool isBusy, Failure? failure}) =
      AuthAuthenticated;

  @override
  List<Object?> get props => const [];
}

final class AuthUnknown extends AuthState {
  const AuthUnknown();
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({
    this.step = AuthStep.enterPhone,
    this.phone,
    this.isBusy = false,
    this.failure,
  });

  final AuthStep step;
  final String? phone;
  final bool isBusy;
  final Failure? failure;

  AuthUnauthenticated copyWith({
    AuthStep? step,
    String? phone,
    bool? isBusy,
    Failure? failure,
    bool clearFailure = false,
  }) => AuthUnauthenticated(
    step: step ?? this.step,
    phone: phone ?? this.phone,
    isBusy: isBusy ?? this.isBusy,
    failure: clearFailure ? null : (failure ?? this.failure),
  );

  @override
  List<Object?> get props => [step, phone, isBusy, failure];
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user, this.isBusy = false, this.failure});

  final AuthUser user;
  final bool isBusy;
  final Failure? failure;

  AuthAuthenticated copyWith({bool? isBusy, Failure? failure, bool clearFailure = false}) =>
      AuthAuthenticated(
        user: user,
        isBusy: isBusy ?? this.isBusy,
        failure: clearFailure ? null : (failure ?? this.failure),
      );

  @override
  List<Object?> get props => [user, isBusy, failure];
}
