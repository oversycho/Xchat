import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:xchat/features/connectivity/domain/entities/network_status.dart';
import 'package:xchat/features/connectivity/domain/usecases/watch_connectivity.dart';

/// App-wide network status for UI hints (offline banner). Starts optimistic: `online`.
class ConnectivityCubit extends Cubit<NetworkStatus> {
  ConnectivityCubit(this._watchConnectivity) : super(NetworkStatus.online);

  final WatchConnectivity _watchConnectivity;
  StreamSubscription<NetworkStatus>? _subscription;

  void start() {
    _subscription ??= _watchConnectivity().listen(emit);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
