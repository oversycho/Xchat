final class AuthIdentity {
  const AuthIdentity({required this.id, this.phone});
  final String id;
  final String? phone;
}

/// Authentication access. Hides the Supabase Auth SDK; implementations throw only `AppException`s.
abstract interface class AuthGateway {
  AuthIdentity? get currentIdentity;

  /// Emits the current identity on subscription, then on every sign-in / sign-out.
  Stream<AuthIdentity?> get identityChanges;

  Future<void> sendPhoneOtp(String phone);
  Future<AuthIdentity> verifyPhoneOtp({required String phone, required String code});
  Future<void> signOut();

  /// Calls the server-side `delete-account` function, then drops the local session.
  Future<void> deleteAccount();
}
