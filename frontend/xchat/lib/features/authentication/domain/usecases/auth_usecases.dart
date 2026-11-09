import 'package:fpdart/fpdart.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/core/services/local_data_cleaner.dart';
import 'package:xchat/core/usecases/usecase.dart';
import 'package:xchat/features/authentication/domain/entities/auth_user.dart';
import 'package:xchat/features/authentication/domain/repositories/auth_repository.dart';

/// E.164: "+" followed by 8 to 15 digits, first digit not zero.
final _e164 = RegExp(r'^\+[1-9]\d{7,14}$');
final _otp = RegExp(r'^\d{4,8}$');

final class WatchAuthState {
  const WatchAuthState(this._repository);
  final AuthRepository _repository;

  Stream<AuthUser?> call() => _repository.watchAuthState();
}

final class GetCurrentUser implements UseCase<AuthUser?, NoParams> {
  const GetCurrentUser(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthUser?>> call(NoParams params) => _repository.getCurrentUser();
}

final class SignInWithPhone implements UseCase<void, String> {
  const SignInWithPhone(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(String phone) async {
    final normalized = phone.replaceAll(RegExp(r'[\s\-()]'), '');
    if (!_e164.hasMatch(normalized)) {
      return Either.left(const ValidationFailure('Enter the number in international format, e.g. +14155550100'));
    }
    return _repository.sendOtp(normalized);
  }
}

final class VerifyOtpParams {
  const VerifyOtpParams({required this.phone, required this.code});
  final String phone;
  final String code;
}

final class VerifyOtp implements UseCase<AuthUser, VerifyOtpParams> {
  const VerifyOtp(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthUser>> call(VerifyOtpParams params) async {
    final code = params.code.trim();
    if (!_otp.hasMatch(code)) {
      return Either.left(const ValidationFailure('Enter the code from the SMS'));
    }
    return _repository.verifyOtp(phone: params.phone, code: code);
  }
}

final class SignOut implements UseCase<void, NoParams> {
  const SignOut(this._repository, this._cleaner);
  final AuthRepository _repository;
  final LocalDataCleaner _cleaner;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    final result = await _repository.signOut();
    // Only wipe local data once the session is really gone, so a failed
    // (e.g. offline) sign-out does not leave a logged-in app with no data.
    if (result.isRight()) await _cleaner.clear();
    return result;
  }
}

final class DeleteAccount implements UseCase<void, NoParams> {
  const DeleteAccount(this._repository, this._cleaner);
  final AuthRepository _repository;
  final LocalDataCleaner _cleaner;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    final result = await _repository.deleteAccount();
    if (result.isRight()) await _cleaner.clear();
    return result;
  }
}
