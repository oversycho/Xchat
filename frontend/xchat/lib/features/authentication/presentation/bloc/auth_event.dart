import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  /// Starts listening to the authentication state. Dispatch once at app start.
  const factory AuthEvent.started() = AuthStarted;
  const factory AuthEvent.otpRequested(String phone) = AuthOtpRequested;
  const factory AuthEvent.otpSubmitted(String code) = AuthOtpSubmitted;
  const factory AuthEvent.backToPhoneRequested() = AuthBackToPhoneRequested;
  const factory AuthEvent.signOutRequested() = AuthSignOutRequested;
  const factory AuthEvent.deleteAccountRequested() = AuthDeleteAccountRequested;
  const factory AuthEvent.failureDismissed() = AuthFailureDismissed;

  @override
  List<Object?> get props => const [];
}

final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthOtpRequested extends AuthEvent {
  const AuthOtpRequested(this.phone);
  final String phone;

  @override
  List<Object?> get props => [phone];
}

final class AuthOtpSubmitted extends AuthEvent {
  const AuthOtpSubmitted(this.code);
  final String code;

  @override
  List<Object?> get props => [code];
}

final class AuthBackToPhoneRequested extends AuthEvent {
  const AuthBackToPhoneRequested();
}

final class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

final class AuthDeleteAccountRequested extends AuthEvent {
  const AuthDeleteAccountRequested();
}

final class AuthFailureDismissed extends AuthEvent {
  const AuthFailureDismissed();
}
