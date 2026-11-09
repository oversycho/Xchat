import 'dart:async';

import 'package:flutter/foundation.dart';

/// Turns a stream into a [Listenable] so GoRouter re-evaluates its redirect on every event.
class StreamListenable extends ChangeNotifier {
  StreamListenable(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
