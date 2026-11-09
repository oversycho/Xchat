abstract interface class ConnectivityService {
  /// Emits `true` when a network interface is available. This does not prove the
  /// internet is reachable; requests can still fail and are handled by the repositories.
  Stream<bool> get onlineChanges;
  Future<bool> get isOnline;
}
