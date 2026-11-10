import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_event.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_state.dart';
import 'package:xchat/features/settings/domain/entities/app_theme_mode.dart';
import 'package:xchat/features/settings/presentation/cubit/theme_cubit.dart';

/// Placeholder shell until the chat list is built (next phase).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    final phone = state is AuthAuthenticated ? state.user.phone : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          PopupMenuButton<AppThemeMode>(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Theme',
            onSelected: context.read<ThemeCubit>().setMode,
            itemBuilder: (_) => [
              for (final mode in AppThemeMode.values)
                PopupMenuItem(value: mode, child: Text(mode.name)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => context.read<AuthBloc>().add(const AuthEvent.signOutRequested()),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Signed in as ${phone ?? 'unknown'}.\nThe chat list is built in the next phase.',
        ),
      ),
    );
  }
}
