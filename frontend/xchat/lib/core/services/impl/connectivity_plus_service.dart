import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:xchat/core/services/connectivity_service.dart';

final class ConnectivityPlusService implements ConnectivityService {
  ConnectivityPlusService([Connectivity? connectivity]) : _connectivity = connectivity ?? Connectivity();
  final Connectivity _connectivity;

  static bool _isOnline(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  @override
  Stream<bool> get onlineChanges => _connectivity.onConnectivityChanged.map(_isOnline).distinct();

  @override
  Future<bool> get isOnline async => _isOnline(await _connectivity.checkConnectivity());
}
