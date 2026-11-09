/// Tiny persistent store for non-sensitive preferences. Secrets go to secure storage instead.
abstract interface class KeyValueStore {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
}
