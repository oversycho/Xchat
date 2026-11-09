import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/features/authentication/domain/entities/auth_user.dart';

part 'auth_state.freezed.dart';

enum AuthStep { enterPhone, enterCode }

@freezed
sealed class AuthState with _$AuthState {
  /// App just started; the first authentication event has not arrived yet.
  const factory AuthState.unknown() = AuthUnknown;

  const factory AuthState.unauthenticated({
    @Default(AuthStep.enterPhone) AuthStep step,
    String? phone,
    @Default(false) bool isBusy,
    Failure? failure,
  }) = AuthUnauthenticated;

  const factory AuthState.authenticated({
    required AuthUser user,
    @Default(false) bool isBusy,
    Failure? failure,
  }) = AuthAuthenticated;
}
