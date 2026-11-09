import 'package:xchat/core/gateways/auth_gateway.dart';
import 'package:xchat/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:xchat/features/authentication/data/models/auth_user_model.dart';

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._gateway);
  final AuthGateway _gateway;

  AuthUserModel? _model(AuthIdentity? identity) =>
      identity == null ? null : AuthUserModel(id: identity.id, phone: identity.phone);

  @override
  AuthUserModel? get currentUser => _model(_gateway.currentIdentity);

  @override
  Stream<AuthUserModel?> watchUser() => _gateway.identityChanges.map(_model);

  @override
  Future<void> sendOtp(String phone) => _gateway.sendPhoneOtp(phone);

  @override
  Future<AuthUserModel> verifyOtp({required String phone, required String code}) async {
    final identity = await _gateway.verifyPhoneOtp(phone: phone, code: code);
    return AuthUserModel(id: identity.id, phone: identity.phone);
  }

  @override
  Future<void> signOut() => _gateway.signOut();

  @override
  Future<void> deleteAccount() => _gateway.deleteAccount();
}
