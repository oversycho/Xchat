/// A stored document. `partition` groups records (e.g. conversationId),
/// `sortKey` orders them (e.g. createdAt in microseconds) and `status`
/// is an indexed discriminator (e.g. message status).
final class LocalRecord {
  const LocalRecord({
    required this.id,
    required this.data,
    this.partition,
    this.sortKey = 0,
    this.status,
  });

  final String id;
  final Map<String, dynamic> data;
  final String? partition;
  final int sortKey;
  final String? status;
}

/// Local persistence abstraction. Hides Isar (or any other engine).
/// `watch` and `query` return records ordered by `sortKey` (newest first
/// unless `descending` is false).
abstract interface class LocalDatabase {
  Future<void> putAll(String collection, List<LocalRecord> records);
  Future<LocalRecord?> get(String collection, String id);
  Future<List<LocalRecord>> getAll(String collection, List<String> ids);
  Future<void> delete(String collection, String id);

  /// Removes every record of every collection (used on sign-out).
  Future<void> clearAll();

  Future<List<LocalRecord>> query(
    String collection, {
    String? partition,
    Set<String>? statuses,
    int? limit,
    bool descending = true,
  });

  Stream<List<LocalRecord>> watch(String collection, {String? partition});
}
