import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xchat/app/app_view.dart';
import 'package:xchat/core/di/injection_container.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_event.dart';
import 'package:xchat/features/connectivity/presentation/cubit/connectivity_cubit.dart';
import 'package:xchat/features/messaging/domain/services/outbox_sync_service.dart';
import 'package:xchat/features/settings/presentation/cubit/theme_cubit.dart';

/// Provides the app-wide (global) state. Conversation-scoped blocs are NOT created here;
/// they are created by the chat route so they are disposed when the chat closes.
class XchatApp extends StatelessWidget {
  const XchatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<OutboxSyncService>(
      create: (_) => sl<OutboxSyncService>(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()..add(const AuthEvent.started())),
          BlocProvider<ThemeCubit>(create: (_) => sl<ThemeCubit>()..load()),
          BlocProvider<ConnectivityCubit>(create: (_) => sl<ConnectivityCubit>()..start()),
        ],
        child: const XchatView(),
      ),
    );
  }
}

/// Shown when the app was started without Supabase credentials.
class ConfigErrorApp extends StatelessWidget {
  const ConfigErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Missing or invalid configuration.\n\nRun with:\n'
              'flutter run --dart-define-from-file=config/dev.json\n\n'
              '(see config/dev.example.json)',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
