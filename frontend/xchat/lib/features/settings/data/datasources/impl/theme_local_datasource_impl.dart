import 'package:xchat/core/services/key_value_store.dart';
import 'package:xchat/features/settings/data/datasources/theme_local_datasource.dart';

final class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  ThemeLocalDataSourceImpl(this._store);
  final KeyValueStore _store;

  static const _key = 'settings.theme_mode';

  @override
  Future<String?> read() => _store.getString(_key);

  @override
  Future<void> write(String value) => _store.setString(_key, value);
}
