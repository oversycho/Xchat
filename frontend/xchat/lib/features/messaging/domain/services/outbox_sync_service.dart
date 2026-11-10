import 'dart:async';

import 'package:xchat/core/services/connectivity_service.dart';
import 'package:xchat/core/usecases/usecase.dart';
import 'package:xchat/features/messaging/domain/usecases/outbox_usecases.dart';

/// Keeps the pending-message queue moving, independent of any widget or BLoC:
/// on start, whenever the network comes back, and on a slow timer as a safety net.
/// Start it when the user signs in; stop it when they sign out.
class OutboxSyncService {
  OutboxSyncService({
    required ConnectivityService connectivity,
    required FlushOutbox flushOutbox,
    required RecoverInterruptedSends recoverInterruptedSends,
    this.safetyInterval = const Duration(minutes: 1),
  }) : _connectivity = connectivity,
       _flushOutbox = flushOutbox,
       _recoverInterruptedSends = recoverInterruptedSends;

  final Duration safetyInterval;
  final ConnectivityService _connectivity;
  final FlushOutbox _flushOutbox;
  final RecoverInterruptedSends _recoverInterruptedSends;

  StreamSubscription<bool>? _subscription;
  Timer? _timer;

  bool get isRunning => _subscription != null;

  Future<void> start() async {
    if (isRunning) return;
    // Mark as running before the first await so a concurrent start() is a no-op.
    _subscription = _connectivity.onlineChanges.where((online) => online).listen((_) => _flush());
    _timer = Timer.periodic(safetyInterval, (_) => _flush());
    // Messages left in `sending` by a previous app kill go back to the queue.
    await _recoverInterruptedSends(const NoParams());
    await _flushOutbox(const NoParams());
  }

  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    await _subscription?.cancel();
    _subscription = null;
  }

  void _flush() {
    unawaited(_flushOutbox(const NoParams()));
  }
}
