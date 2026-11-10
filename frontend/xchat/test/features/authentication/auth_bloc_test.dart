import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/core/services/local_data_cleaner.dart';
import 'package:xchat/features/authentication/domain/entities/auth_user.dart';
import 'package:xchat/features/authentication/domain/repositories/auth_repository.dart';
import 'package:xchat/features/authentication/domain/usecases/auth_usecases.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_event.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_state.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockLocalDataCleaner extends Mock implements LocalDataCleaner {}

void main() {
  const phone = '+15555550100';
  const user = AuthUser(id: 'u1', phone: phone);

  late _MockAuthRepository repository;
  late _MockLocalDataCleaner cleaner;

  // Real use cases over a mocked repository interface: tests the BLoC and the
  // validation rules together without touching Supabase.
  AuthBloc buildBloc() => AuthBloc(
    watchAuthState: WatchAuthState(repository),
    signInWithPhone: SignInWithPhone(repository),
    verifyOtp: VerifyOtp(repository),
    signOut: SignOut(repository, cleaner),
    deleteAccount: DeleteAccount(repository, cleaner),
  );

  setUp(() {
    repository = _MockAuthRepository();
    cleaner = _MockLocalDataCleaner();
    when(() => cleaner.clear()).thenAnswer((_) async {});
  });

  blocTest<AuthBloc, AuthState>(
    'started without a session -> unauthenticated',
    setUp: () =>
        when(() => repository.watchAuthState()).thenAnswer((_) => Stream<AuthUser?>.value(null)),
    build: buildBloc,
    act: (bloc) => bloc.add(const AuthEvent.started()),
    expect: () => [const AuthState.unauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'started with a session -> authenticated',
    setUp: () =>
        when(() => repository.watchAuthState()).thenAnswer((_) => Stream<AuthUser?>.value(user)),
    build: buildBloc,
    act: (bloc) => bloc.add(const AuthEvent.started()),
    expect: () => [const AuthState.authenticated(user: user)],
  );

  blocTest<AuthBloc, AuthState>(
    'requesting a code moves to the code step',
    setUp: () => when(
      () => repository.sendOtp(phone),
    ).thenAnswer((_) async => Either<Failure, void>.right(null)),
    build: buildBloc,
    seed: () => const AuthState.unauthenticated(),
    act: (bloc) => bloc.add(const AuthEvent.otpRequested(phone)),
    expect: () => [
      const AuthState.unauthenticated(isBusy: true),
      const AuthState.unauthenticated(step: AuthStep.enterCode, phone: phone),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'an invalid number surfaces a validation failure and stays on the phone step',
    build: buildBloc,
    seed: () => const AuthState.unauthenticated(),
    act: (bloc) => bloc.add(const AuthEvent.otpRequested('123')),
    expect: () => [
      const AuthState.unauthenticated(isBusy: true),
      isA<AuthUnauthenticated>()
          .having((s) => s.isBusy, 'isBusy', false)
          .having((s) => s.step, 'step', AuthStep.enterPhone)
          .having((s) => s.failure, 'failure', isA<ValidationFailure>()),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'a correct code authenticates the user',
    setUp: () => when(
      () => repository.verifyOtp(phone: phone, code: '123456'),
    ).thenAnswer((_) async => Either<Failure, AuthUser>.right(user)),
    build: buildBloc,
    seed: () => const AuthState.unauthenticated(step: AuthStep.enterCode, phone: phone),
    act: (bloc) => bloc.add(const AuthEvent.otpSubmitted('123456')),
    expect: () => [
      const AuthState.unauthenticated(step: AuthStep.enterCode, phone: phone, isBusy: true),
      const AuthState.authenticated(user: user),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'a wrong code keeps the user on the code step with the failure',
    setUp: () => when(() => repository.verifyOtp(phone: phone, code: '000000')).thenAnswer(
      (_) async => Either<Failure, AuthUser>.left(
        const UnauthorizedFailure('Token has expired or is invalid'),
      ),
    ),
    build: buildBloc,
    seed: () => const AuthState.unauthenticated(step: AuthStep.enterCode, phone: phone),
    act: (bloc) => bloc.add(const AuthEvent.otpSubmitted('000000')),
    expect: () => [
      const AuthState.unauthenticated(step: AuthStep.enterCode, phone: phone, isBusy: true),
      const AuthState.unauthenticated(
        step: AuthStep.enterCode,
        phone: phone,
        failure: UnauthorizedFailure('Token has expired or is invalid'),
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'signing out clears local data and returns to unauthenticated',
    setUp: () =>
        when(() => repository.signOut()).thenAnswer((_) async => Either<Failure, void>.right(null)),
    build: buildBloc,
    seed: () => const AuthState.authenticated(user: user),
    act: (bloc) => bloc.add(const AuthEvent.signOutRequested()),
    expect: () => [
      const AuthState.authenticated(user: user, isBusy: true),
      const AuthState.unauthenticated(),
    ],
    verify: (_) => verify(() => cleaner.clear()).called(1),
  );

  blocTest<AuthBloc, AuthState>(
    'a failed sign-out keeps the user signed in and does NOT wipe local data',
    setUp: () => when(
      () => repository.signOut(),
    ).thenAnswer((_) async => Either<Failure, void>.left(const NetworkFailure())),
    build: buildBloc,
    seed: () => const AuthState.authenticated(user: user),
    act: (bloc) => bloc.add(const AuthEvent.signOutRequested()),
    expect: () => [
      const AuthState.authenticated(user: user, isBusy: true),
      const AuthState.authenticated(user: user, failure: NetworkFailure()),
    ],
    verify: (_) => verifyNever(() => cleaner.clear()),
  );
}
