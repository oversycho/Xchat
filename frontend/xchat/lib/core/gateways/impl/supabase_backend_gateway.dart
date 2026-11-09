import 'package:xchat/core/gateways/backend_gateway.dart';
import 'package:xchat/core/gateways/impl/supabase_error_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class SupabaseBackendGateway implements BackendGateway {
  SupabaseBackendGateway(this._client);
  final SupabaseClient _client;

  @override
  String? get currentUserId => _client.auth.currentUser?.id;

  @override
  Future<List<Map<String, dynamic>>> select(
    String table, {
    String columns = '*',
    List<BackendFilter> filters = const [],
    BackendOrder? order,
    int? limit,
  }) {
    return _run(() async {
      var query = _client.from(table).select(columns);
      for (final filter in filters) {
        query = _apply(query, filter);
      }
      PostgrestTransformBuilder<PostgrestList> transform = query;
      if (order != null) {
        transform = transform.order(order.column, ascending: order.ascending);
      }
      if (limit != null) {
        transform = transform.limit(limit);
      }
      return await transform;
    });
  }

  @override
  Future<Map<String, dynamic>> upsert(
    String table,
    Map<String, dynamic> values, {
    String? onConflict,
    String returning = '*',
  }) {
    return _run(
      () => _client
          .from(table)
          .upsert(values, onConflict: onConflict)
          .select(returning)
          .single(),
    );
  }

  @override
  Future<void> upsertAll(
    String table,
    List<Map<String, dynamic>> rows, {
    String? onConflict,
  }) {
    return _run(() async {
      await _client.from(table).upsert(rows, onConflict: onConflict);
    });
  }

  @override
  Future<void> update(
    String table,
    Map<String, dynamic> values, {
    required List<BackendFilter> filters,
  }) {
    return _run(() async {
      var query = _client.from(table).update(values);
      for (final filter in filters) {
        query = _apply(query, filter);
      }
      await query;
    });
  }

  @override
  Future<void> delete(String table, {required List<BackendFilter> filters}) {
    return _run(() async {
      var query = _client.from(table).delete();
      for (final filter in filters) {
        query = _apply(query, filter);
      }
      await query;
    });
  }

  PostgrestFilterBuilder<T> _apply<T>(
    PostgrestFilterBuilder<T> query,
    BackendFilter f,
  ) =>
      switch (f.op) {
        FilterOp.eq => query.eq(f.column, f.value!),
        FilterOp.neq => query.neq(f.column, f.value!),
        FilterOp.lt => query.lt(f.column, f.value!),
        FilterOp.lte => query.lte(f.column, f.value!),
        FilterOp.gt => query.gt(f.column, f.value!),
        FilterOp.gte => query.gte(f.column, f.value!),
        FilterOp.inList => query.inFilter(f.column, f.value! as List<Object>),
        FilterOp.isNull => query.isFilter(f.column, null),
      };

  Future<T> _run<T>(Future<T> Function() operation) => guardSupabase(operation);
}
