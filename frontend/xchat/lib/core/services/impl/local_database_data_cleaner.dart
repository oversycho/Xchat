import 'package:xchat/core/gateways/local_database.dart';
import 'package:xchat/core/services/local_data_cleaner.dart';

final class LocalDatabaseDataCleaner implements LocalDataCleaner {
  LocalDatabaseDataCleaner(this._database);
  final LocalDatabase _database;

  @override
  Future<void> clear() => _database.clearAll();
}
