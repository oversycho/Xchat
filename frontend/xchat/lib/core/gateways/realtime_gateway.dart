enum RealtimeEventType { insert, update, delete, resync }

final class RealtimeChange {
  const RealtimeChange(this.type, {this.newRecord = const {}, this.oldRecord = const {}});

  final RealtimeEventType type;
  final Map<String, dynamic> newRecord;
  final Map<String, dynamic> oldRecord;
}

/// Lifecycle-aware realtime access. The channel is opened when the returned
/// stream is listened to and removed when the listener cancels.
/// A [RealtimeEventType.resync] event is emitted after every re-subscription
/// following a disconnect, so consumers can catch up on missed events.
abstract interface class RealtimeGateway {
  Stream<RealtimeChange> watchTable(
    String table, {
    required String filterColumn,
    required String filterValue,
  });
}
