abstract interface class ThemeLocalDataSource {
  Future<String?> read();
  Future<void> write(String value);
}
