enum FilterOp { eq, neq, lt, lte, gt, gte, inList, isNull }

final class BackendFilter {
  const BackendFilter(this.column, this.op, [this.value]);
  const BackendFilter.eq(String column, Object? value) : this(column, FilterOp.eq, value);
  const BackendFilter.lt(String column, Object? value) : this(column, FilterOp.lt, value);
  const BackendFilter.gt(String column, Object? value) : this(column, FilterOp.gt, value);
  const BackendFilter.inList(String column, List<Object> values) : this(column, FilterOp.inList, values);
  const BackendFilter.isNull(String column) : this(column, FilterOp.isNull);

  final String column;
  final FilterOp op;
  final Object? value;
}

final class BackendOrder {
  const BackendOrder(this.column, {this.ascending = true});
  final String column;
  final bool ascending;
}

/// Table-level access to the backend. Hides the Supabase SDK completely:
/// data sources depend on this interface, never on `SupabaseClient`.
/// Implementations must throw only `AppException` subclasses.
abstract interface class BackendGateway {
  String? get currentUserId;

  Future<List<Map<String, dynamic>>> select(
    String table, {
    String columns = '*',
    List<BackendFilter> filters = const [],
    BackendOrder? order,
    int? limit,
  });

  Future<Map<String, dynamic>> upsert(
    String table,
    Map<String, dynamic> values, {
    String? onConflict,
    String returning = '*',
  });

  Future<void> upsertAll(
    String table,
    List<Map<String, dynamic>> rows, {
    String? onConflict,
  });

  Future<void> update(
    String table,
    Map<String, dynamic> values, {
    required List<BackendFilter> filters,
  });

  Future<void> delete(
    String table, {
    required List<BackendFilter> filters,
  });
}
