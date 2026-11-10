import 'dart:async';

import 'package:xchat/core/errors/exceptions.dart';
import 'package:xchat/core/gateways/realtime_gateway.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class SupabaseRealtimeGateway implements RealtimeGateway {
  SupabaseRealtimeGateway(this._client);
  final SupabaseClient _client;

  @override
  Stream<RealtimeChange> watchTable(
    String table, {
    required String filterColumn,
    required String filterValue,
  }) {
    late final StreamController<RealtimeChange> controller;
    RealtimeChannel? channel;
    var hasSubscribedBefore = false;

    controller = StreamController<RealtimeChange>(
      onListen: () {
        channel = _client
            .channel('rt:$table:$filterColumn:$filterValue')
            .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: table,
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: filterColumn,
                value: filterValue,
              ),
              callback: (payload) => controller.add(
                RealtimeChange(
                  _typeOf(payload.eventType),
                  newRecord: payload.newRecord,
                  oldRecord: payload.oldRecord,
                ),
              ),
            )
            .subscribe((status, error) {
              if (status == RealtimeSubscribeStatus.subscribed) {
                if (hasSubscribedBefore) {
                  controller.add(const RealtimeChange(RealtimeEventType.resync));
                }
                hasSubscribedBefore = true;
              } else if (error != null) {
                controller.addError(RealtimeException(error.toString()));
              }
            });
      },
      onCancel: () async {
        final current = channel;
        if (current != null) await _client.removeChannel(current);
      },
    );
    return controller.stream;
  }

  RealtimeEventType _typeOf(PostgresChangeEvent event) => switch (event) {
    PostgresChangeEvent.insert => RealtimeEventType.insert,
    PostgresChangeEvent.delete => RealtimeEventType.delete,
    _ => RealtimeEventType.update,
  };
}
