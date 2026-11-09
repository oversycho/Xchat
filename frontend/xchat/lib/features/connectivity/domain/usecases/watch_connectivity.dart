import 'package:xchat/core/services/connectivity_service.dart';
import 'package:xchat/features/connectivity/domain/entities/network_status.dart';

final class WatchConnectivity {
  const WatchConnectivity(this._service);
  final ConnectivityService _service;

  Stream<NetworkStatus> call() =>
      _service.onlineChanges.map((online) => online ? NetworkStatus.online : NetworkStatus.offline);
}
