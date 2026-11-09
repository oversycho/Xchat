import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xchat/app/router/app_router.dart';
import 'package:xchat/app/router/stream_listenable.dart';
import 'package:xchat/app/theme/app_theme.dart';
import 'package:xchat/app/widgets/connectivity_banner.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_state.dart';
import 'package:xchat/features/connectivity/domain/entities/network_status.dart';
import 'package:xchat/features/connectivity/presentation/cubit/connectivity_cubit.dart';
import 'package:xchat/features/messaging/domain/services/outbox_sync_service.dart';
import 'package:xchat/features/settings/domain/entities/app_theme_mode.dart';
import 'package:xchat/features/settings/presentation/cubit/theme_cubit.dart';

/// Reads global state from the context (so tests can supply mock blocs) and builds MaterialApp.router.
class XchatView extends StatefulWidget {
  const XchatView({super.key});

  @override
  State<XchatView> createState() => _XchatViewState();
}

class _XchatViewState extends State<XchatView> {
  late final StreamListenable _authChanges;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthBloc>();
    _authChanges = StreamListenable(authBloc.stream);
    _router = createRouter(authBloc: authBloc, refreshListenable: _authChanges);
  }

  @override
  void dispose() {
    _router.dispose();
    _authChanges.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      // Only when the kind of state changes (signed in / signed out), not on busy/failure flags.
      listenWhen: (previous, current) => previous.runtimeType != current.runtimeType,
      listener: (context, state) {
        final sync = context.read<OutboxSyncService>();
        if (state is AuthAuthenticated) {
          unawaited(sync.start());
        } else if (state is AuthUnauthenticated) {
          unawaited(sync.stop());
        }
      },
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, mode) => MaterialApp.router(
          title: 'Xchat',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: switch (mode) {
            AppThemeMode.system => ThemeMode.system,
            AppThemeMode.light => ThemeMode.light,
            AppThemeMode.dark => ThemeMode.dark,
          },
          routerConfig: _router,
          builder: (context, child) => Column(
            children: [
              BlocBuilder<ConnectivityCubit, NetworkStatus>(
                builder: (_, status) =>
                    status == NetworkStatus.offline ? const ConnectivityBanner() : const SizedBox.shrink(),
              ),
              Expanded(child: child ?? const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
