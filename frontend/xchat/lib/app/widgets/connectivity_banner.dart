import 'package:flutter/material.dart';

class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.errorContainer,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Center(
            child: Text(
              'Waiting for network…',
              style: TextStyle(color: scheme.onErrorContainer),
            ),
          ),
        ),
      ),
    );
  }
}
