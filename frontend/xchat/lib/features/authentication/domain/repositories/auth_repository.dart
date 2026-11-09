import 'package:fpdart/fpdart.dart';
import 'package:xchat/core/errors/failures.dart';
import 'package:xchat/features/authentication/domain/entities/auth_user.dart';

abstract interface class AuthRepository {
  /// Emits the current user (or null) on subscription, then on every change.
  Stream<AuthUser?> watchAuthState();

  Future<Either<Failure, AuthUser?>> getCurrentUser();
  Future<Either<Failure, void>> sendOtp(String phone);
  Future<Either<Failure, AuthUser>> verifyOtp({required String phone, required String code});
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> deleteAccount();
}
