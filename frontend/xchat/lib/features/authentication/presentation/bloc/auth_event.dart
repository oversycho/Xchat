import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  /// Starts listening to the authentication state. Dispatch once at app start.
  const factory AuthEvent.started() = AuthStarted;
  const factory AuthEvent.otpRequested(String phone) = AuthOtpRequested;
  const factory AuthEvent.otpSubmitted(String code) = AuthOtpSubmitted;
  const factory AuthEvent.backToPhoneRequested() = AuthBackToPhoneRequested;
  const factory AuthEvent.signOutRequested() = AuthSignOutRequested;
  const factory AuthEvent.deleteAccountRequested() = AuthDeleteAccountRequested;
  const factory AuthEvent.failureDismissed() = AuthFailureDismissed;
}
