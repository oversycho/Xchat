import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xchat/core/errors/exceptions.dart';
import 'package:xchat/core/gateways/auth_gateway.dart';
import 'package:xchat/core/gateways/impl/supabase_error_mapper.dart';

final class SupabaseAuthGateway implements AuthGateway {
  SupabaseAuthGateway(this._client);
  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  AuthIdentity? _identityOf(User? user) =>
      user == null ? null : AuthIdentity(id: user.id, phone: user.phone);

  @override
  AuthIdentity? get currentIdentity => _identityOf(_auth.currentUser);

  @override
  Stream<AuthIdentity?> get identityChanges =>
      _auth.onAuthStateChange.map((state) => _identityOf(state.session?.user));

  @override
  Future<void> sendPhoneOtp(String phone) => guardSupabase(() => _auth.signInWithOtp(phone: phone));

  @override
  Future<AuthIdentity> verifyPhoneOtp({required String phone, required String code}) =>
      guardSupabase(() async {
        final response = await _auth.verifyOTP(phone: phone, token: code, type: OtpType.sms);
        final identity = _identityOf(response.user);
        if (identity == null) throw const UnauthorizedException('Verification failed');
        return identity;
      });

  @override
  Future<void> signOut() => guardSupabase(() => _auth.signOut());

  @override
  Future<void> deleteAccount() => guardSupabase(() async {
    await _client.functions.invoke('delete-account', method: HttpMethod.post);
    await _auth.signOut(scope: SignOutScope.local);
  });
}
