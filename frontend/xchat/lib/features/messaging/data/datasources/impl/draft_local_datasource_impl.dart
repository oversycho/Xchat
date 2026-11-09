import 'package:xchat/core/gateways/local_database.dart';
import 'package:xchat/features/messaging/data/datasources/draft_local_datasource.dart';
import 'package:xchat/features/messaging/data/models/draft_model.dart';

final class DraftLocalDataSourceImpl implements DraftLocalDataSource {
  DraftLocalDataSourceImpl(this._db);
  final LocalDatabase _db;

  static const _collection = 'drafts';

  @override
  Future<DraftModel?> get(String conversationId) async {
    final record = await _db.get(_collection, conversationId);
    return record == null ? null : DraftModel.fromJson(record.data);
  }

  @override
  Future<void> save(DraftModel model) => _db.putAll(_collection, [
        LocalRecord(
          id: model.conversationId,
          partition: model.conversationId,
          sortKey: model.updatedAt.microsecondsSinceEpoch,
          data: model.toJson(),
        ),
      ]);

  @override
  Future<void> delete(String conversationId) => _db.delete(_collection, conversationId);
}
