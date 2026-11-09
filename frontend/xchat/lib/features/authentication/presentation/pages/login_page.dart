import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_event.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _submit() => context.read<AuthBloc>().add(AuthEvent.otpRequested(_phone.text));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              current is AuthUnauthenticated &&
              current.failure != null &&
              (previous is! AuthUnauthenticated || previous.failure != current.failure),
          listener: (context, state) {
            final failure = (state as AuthUnauthenticated).failure!;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(failure.message)));
            context.read<AuthBloc>().add(const AuthEvent.failureDismissed());
          },
          builder: (context, state) {
            final busy = state is AuthUnauthenticated && state.isBusy;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Your phone number', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  const Text('We will text you a confirmation code.'),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    decoration: const InputDecoration(labelText: 'Phone', hintText: '+14155550100'),
                    onSubmitted: (_) => busy ? null : _submit(),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: busy ? null : _submit,
                    child: busy
                        ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Send code'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
