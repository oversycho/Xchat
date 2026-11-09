import 'package:flutter_test/flutter_test.dart';
import 'package:xchat/app/router/app_router.dart';
import 'package:xchat/app/router/app_routes.dart';
import 'package:xchat/features/authentication/domain/entities/auth_user.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_state.dart';

void main() {
  const user = AuthUser(id: 'u1');

  group('authRedirect', () {
    test('unknown state parks everything on the splash screen', () {
      expect(authRedirect(const AuthState.unknown(), AppRoutes.home), AppRoutes.splash);
      expect(authRedirect(const AuthState.unknown(), AppRoutes.splash), isNull);
    });

    test('signed-out users are confined to login / verify', () {
      expect(authRedirect(const AuthState.unauthenticated(), AppRoutes.home), AppRoutes.login);
      expect(authRedirect(const AuthState.unauthenticated(), AppRoutes.login), isNull);
      expect(authRedirect(const AuthState.unauthenticated(), AppRoutes.verify), AppRoutes.login);
    });

    test('after the code is sent the user is sent to verify', () {
      const state = AuthState.unauthenticated(step: AuthStep.enterCode, phone: '+15555550100');
      expect(authRedirect(state, AppRoutes.login), AppRoutes.verify);
      expect(authRedirect(state, AppRoutes.verify), isNull);
    });

    test('signed-in users are moved off the auth screens and nothing else', () {
      const state = AuthState.authenticated(user: user);
      expect(authRedirect(state, AppRoutes.login), AppRoutes.home);
      expect(authRedirect(state, AppRoutes.splash), AppRoutes.home);
      expect(authRedirect(state, AppRoutes.verify), AppRoutes.home);
      expect(authRedirect(state, AppRoutes.home), isNull);
    });
  });
}
