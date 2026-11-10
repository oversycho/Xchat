import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_event.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_state.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _submit() => context.read<AuthBloc>().add(AuthEvent.otpSubmitted(_code.text));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.read<AuthBloc>().add(const AuthEvent.backToPhoneRequested()),
        ),
      ),
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
            final unauthenticated = state is AuthUnauthenticated ? state : null;
            final busy = unauthenticated?.isBusy ?? false;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Enter the code', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('Sent to ${unauthenticated?.phone ?? 'your phone'}'),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _code,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    decoration: const InputDecoration(labelText: 'Code'),
                    onSubmitted: (_) => busy ? null : _submit(),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: busy ? null : _submit,
                    child: busy
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Verify'),
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
