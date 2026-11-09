import 'package:xchat/features/authentication/data/models/auth_user_model.dart';

abstract interface class AuthRemoteDataSource {
  AuthUserModel? get currentUser;
  Stream<AuthUserModel?> watchUser();
  Future<void> sendOtp(String phone);
  Future<AuthUserModel> verifyOtp({required String phone, required String code});
  Future<void> signOut();
  Future<void> deleteAccount();
}
