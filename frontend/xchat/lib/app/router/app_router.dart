import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:xchat/app/router/app_routes.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_state.dart';
import 'package:xchat/app/pages/home_page.dart';
import 'package:xchat/features/authentication/presentation/pages/login_page.dart';
import 'package:xchat/features/authentication/presentation/pages/splash_page.dart';
import 'package:xchat/features/authentication/presentation/pages/verify_page.dart';

/// Pure function so the routing rules can be unit-tested without widgets.
/// Returns the location to redirect to, or null to stay where we are.
String? authRedirect(AuthState state, String location) {
  switch (state) {
    case AuthUnknown():
      return location == AppRoutes.splash ? null : AppRoutes.splash;
    case AuthUnauthenticated(:final step):
      final target = step == AuthStep.enterCode ? AppRoutes.verify : AppRoutes.login;
      return location == target ? null : target;
    case AuthAuthenticated():
      return AppRoutes.authRoutes.contains(location) ? AppRoutes.home : null;
  }
}

GoRouter createRouter({required AuthBloc authBloc, required Listenable refreshListenable}) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable,
    redirect: (context, state) => authRedirect(authBloc.state, state.matchedLocation),
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginPage()),
      GoRoute(path: AppRoutes.verify, builder: (_, _) => const VerifyPage()),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
    ],
  );
}
