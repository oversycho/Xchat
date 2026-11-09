import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/features/authentication/domain/repositories/auth_repository.dart';
import 'package:xchat/features/authentication/domain/usecases/auth_usecases.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;

  setUp(() => repository = _MockAuthRepository());

  group('SignInWithPhone', () {
    test('rejects numbers that are not international format without calling the backend', () async {
      final result = await SignInWithPhone(repository)('4155550100');

      result.match((f) => expect(f, isA<ValidationFailure>()), (_) => fail('expected a failure'));
      verifyNever(() => repository.sendOtp(any()));
    });

    test('strips spaces, dashes and parentheses before sending', () async {
      when(() => repository.sendOtp('+14155550100'))
          .thenAnswer((_) async => Either<Failure, void>.right(null));

      final result = await SignInWithPhone(repository)('+1 (415) 555-0100');

      expect(result.isRight(), isTrue);
      verify(() => repository.sendOtp('+14155550100')).called(1);
    });
  });

  group('VerifyOtp', () {
    test('rejects codes that are not 4-8 digits', () async {
      final result = await VerifyOtp(repository)(const VerifyOtpParams(phone: '+14155550100', code: '12ab'));

      expect(result.isLeft(), isTrue);
      verifyNever(() => repository.verifyOtp(phone: any(named: 'phone'), code: any(named: 'code')));
    });
  });
}
