import 'dart:async';

import 'package:xchat/core/gateways/local_database.dart';

/// Non-persistent [LocalDatabase]. Used by tests and as a temporary stand-in
/// until the Isar implementation exists. NOT suitable for offline support
/// across app restarts.
final class InMemoryLocalDatabase implements LocalDatabase {
  final Map<String, Map<String, LocalRecord>> _store = {};
  final StreamController<String> _changes = StreamController<String>.broadcast(sync: true);

  @override
  Future<void> putAll(String collection, List<LocalRecord> records) async {
    final bucket = _store.putIfAbsent(collection, () => {});
    for (final record in records) {
      bucket[record.id] = record;
    }
    _changes.add(collection);
  }

  @override
  Future<LocalRecord?> get(String collection, String id) async => _store[collection]?[id];

  @override
  Future<List<LocalRecord>> getAll(String collection, List<String> ids) async {
    final bucket = _store[collection];
    if (bucket == null) return const [];
    return [for (final id in ids) if (bucket[id] != null) bucket[id]!];
  }

  @override
  Future<void> delete(String collection, String id) async {
    _store[collection]?.remove(id);
    _changes.add(collection);
  }

  @override
  Future<void> clearAll() async {
    final touched = _store.keys.toList();
    _store.clear();
    touched.forEach(_changes.add);
  }

  @override
  Future<List<LocalRecord>> query(
    String collection, {
    String? partition,
    Set<String>? statuses,
    int? limit,
    bool descending = true,
  }) async =>
      _select(collection, partition: partition, statuses: statuses, limit: limit, descending: descending);

  @override
  Stream<List<LocalRecord>> watch(String collection, {String? partition}) {
    late final StreamController<List<LocalRecord>> controller;
    StreamSubscription<String>? subscription;
    controller = StreamController<List<LocalRecord>>(
      onListen: () {
        subscription = _changes.stream.listen((changed) {
          if (changed == collection) {
            controller.add(_select(collection, partition: partition));
          }
        });
        controller.add(_select(collection, partition: partition));
      },
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }

  List<LocalRecord> _select(
    String collection, {
    String? partition,
    Set<String>? statuses,
    int? limit,
    bool descending = true,
  }) {
    var rows = (_store[collection]?.values ?? const <LocalRecord>[])
        .where((r) =>
            (partition == null || r.partition == partition) &&
            (statuses == null || statuses.contains(r.status)))
        .toList()
      ..sort((a, b) => descending ? b.sortKey.compareTo(a.sortKey) : a.sortKey.compareTo(b.sortKey));
    if (limit != null && rows.length > limit) rows = rows.sublist(0, limit);
    return rows;
  }
}
