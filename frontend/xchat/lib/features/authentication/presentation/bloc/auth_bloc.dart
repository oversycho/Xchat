import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:xchat/core/usecases/usecase.dart';
import 'package:xchat/features/authentication/domain/entities/auth_user.dart';
import 'package:xchat/features/authentication/domain/usecases/auth_usecases.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_event.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_state.dart';

/// Owns "who is signed in" for the whole app. The router redirects off this state.
/// Phone number, OTP step and busy/failure flags live here so pages stay dumb.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required WatchAuthState watchAuthState,
    required SignInWithPhone signInWithPhone,
    required VerifyOtp verifyOtp,
    required SignOut signOut,
    required DeleteAccount deleteAccount,
  }) : _watchAuthState = watchAuthState,
       _signInWithPhone = signInWithPhone,
       _verifyOtp = verifyOtp,
       _signOut = signOut,
       _deleteAccount = deleteAccount,
       super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthOtpRequested>(_onOtpRequested, transformer: droppable());
    on<AuthOtpSubmitted>(_onOtpSubmitted, transformer: droppable());
    on<AuthBackToPhoneRequested>(_onBackToPhone);
    on<AuthSignOutRequested>(_onSignOut, transformer: droppable());
    on<AuthDeleteAccountRequested>(_onDeleteAccount, transformer: droppable());
    on<AuthFailureDismissed>(_onFailureDismissed);
  }

  final WatchAuthState _watchAuthState;
  final SignInWithPhone _signInWithPhone;
  final VerifyOtp _verifyOtp;
  final SignOut _signOut;
  final DeleteAccount _deleteAccount;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) {
    return emit.forEach<AuthUser?>(
      _watchAuthState(),
      onData: (user) {
        final current = state;
        if (user != null) {
          return current is AuthAuthenticated && current.user == user
              ? current
              : AuthState.authenticated(user: user);
        }
        return current is AuthUnauthenticated ? current : const AuthState.unauthenticated();
      },
      onError: (_, _) => const AuthState.unauthenticated(),
    );
  }

  Future<void> _onOtpRequested(AuthOtpRequested event, Emitter<AuthState> emit) async {
    final current = state;
    if (current is! AuthUnauthenticated || current.isBusy) return;

    emit(current.copyWith(isBusy: true, clearFailure: true));
    final result = await _signInWithPhone(event.phone);

    final latest = state;
    if (latest is! AuthUnauthenticated) return;
    result.fold(
      (failure) => emit(latest.copyWith(isBusy: false, failure: failure)),
      (_) =>
          emit(latest.copyWith(isBusy: false, step: AuthStep.enterCode, phone: event.phone.trim())),
    );
  }

  Future<void> _onOtpSubmitted(AuthOtpSubmitted event, Emitter<AuthState> emit) async {
    final current = state;
    if (current is! AuthUnauthenticated || current.isBusy) return;
    final phone = current.phone;
    if (phone == null) return;

    emit(current.copyWith(isBusy: true, clearFailure: true));
    final result = await _verifyOtp(VerifyOtpParams(phone: phone, code: event.code));

    final latest = state;
    if (latest is! AuthUnauthenticated) return;
    result.fold(
      (failure) => emit(latest.copyWith(isBusy: false, failure: failure)),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }

  void _onBackToPhone(AuthBackToPhoneRequested event, Emitter<AuthState> emit) {
    final current = state;
    if (current is AuthUnauthenticated) {
      emit(current.copyWith(step: AuthStep.enterPhone, isBusy: false, clearFailure: true));
    }
  }

  Future<void> _onSignOut(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    final current = state;
    if (current is! AuthAuthenticated || current.isBusy) return;

    emit(current.copyWith(isBusy: true, clearFailure: true));
    final result = await _signOut(const NoParams());

    final latest = state;
    if (latest is! AuthAuthenticated) return;
    result.fold(
      (failure) => emit(latest.copyWith(isBusy: false, failure: failure)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> _onDeleteAccount(AuthDeleteAccountRequested event, Emitter<AuthState> emit) async {
    final current = state;
    if (current is! AuthAuthenticated || current.isBusy) return;

    emit(current.copyWith(isBusy: true, clearFailure: true));
    final result = await _deleteAccount(const NoParams());

    final latest = state;
    if (latest is! AuthAuthenticated) return;
    result.fold(
      (failure) => emit(latest.copyWith(isBusy: false, failure: failure)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  void _onFailureDismissed(AuthFailureDismissed event, Emitter<AuthState> emit) {
    final current = state;
    switch (current) {
      case AuthUnauthenticated():
        emit(current.copyWith(clearFailure: true));
      case AuthAuthenticated():
        emit(current.copyWith(clearFailure: true));
      case AuthUnknown():
        break;
    }
  }
}
