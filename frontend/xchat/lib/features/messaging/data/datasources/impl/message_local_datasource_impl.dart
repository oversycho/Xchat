import 'package:xchat/core/gateways/local_database.dart';
import 'package:xchat/features/messaging/data/datasources/message_local_datasource.dart';
import 'package:xchat/features/messaging/data/models/message_model.dart';

final class MessageLocalDataSourceImpl implements MessageLocalDataSource {
  MessageLocalDataSourceImpl(this._db);
  final LocalDatabase _db;

  static const _collection = 'messages';
  static const _synced = {'sent', 'read'};

  LocalRecord _toRecord(MessageModel m) => LocalRecord(
        id: m.id,
        partition: m.conversationId,
        sortKey: m.createdAt.microsecondsSinceEpoch,
        status: m.status,
        data: m.toJson(),
      );

  MessageModel _fromRecord(LocalRecord r) => MessageModel.fromJson(r.data);

  @override
  Stream<List<MessageModel>> watch(String conversationId) =>
      _db.watch(_collection, partition: conversationId).map((rows) => rows.map(_fromRecord).toList());

  @override
  Future<void> upsertAll(List<MessageModel> models) => _db.putAll(_collection, models.map(_toRecord).toList());

  @override
  Future<MessageModel?> getById(String id) async {
    final record = await _db.get(_collection, id);
    return record == null ? null : _fromRecord(record);
  }

  @override
  Future<List<MessageModel>> getByIds(List<String> ids) async =>
      (await _db.getAll(_collection, ids)).map(_fromRecord).toList();

  @override
  Future<void> updateStatus(String id, String status, {String? failureReason}) async {
    final current = await getById(id);
    if (current == null) return;
    await upsertAll([current.withStatus(status, failureReason: failureReason)]);
  }

  @override
  Future<void> deleteById(String id) => _db.delete(_collection, id);

  @override
  Future<List<MessageModel>> pending() async =>
      (await _db.query(_collection, statuses: {'pending'}, descending: false)).map(_fromRecord).toList();

  @override
  Future<void> resetSendingToPending() async {
    final stuck = await _db.query(_collection, statuses: {'sending'});
    if (stuck.isEmpty) return;
    await upsertAll([for (final r in stuck) _fromRecord(r).withStatus('pending')]);
  }

  @override
  Future<DateTime?> oldestSyncedCreatedAt(String conversationId) async {
    final rows = await _db.query(
      _collection,
      partition: conversationId,
      statuses: _synced,
      limit: 1,
      descending: false,
    );
    return rows.isEmpty ? null : _fromRecord(rows.first).createdAt;
  }

  @override
  Future<DateTime?> newestSyncedCreatedAt(String conversationId) async {
    final rows = await _db.query(_collection, partition: conversationId, statuses: _synced, limit: 1);
    return rows.isEmpty ? null : _fromRecord(rows.first).createdAt;
  }
}
