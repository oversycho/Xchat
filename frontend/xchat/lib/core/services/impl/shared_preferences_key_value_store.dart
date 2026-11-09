import 'package:shared_preferences/shared_preferences.dart';
import 'package:xchat/core/services/key_value_store.dart';

final class SharedPreferencesKeyValueStore implements KeyValueStore {
  SharedPreferencesKeyValueStore(this._preferences);
  final SharedPreferences _preferences;

  @override
  Future<String?> getString(String key) async => _preferences.getString(key);

  @override
  Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }
}
