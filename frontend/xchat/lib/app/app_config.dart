/// Build-time configuration, supplied with `--dart-define` / `--dart-define-from-file`.
/// Only the public anon key belongs here; never the service_role key.
abstract final class AppConfig {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// `dev` (default), `staging` or `prod`.
  static const environment = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  static bool get isProduction => environment == 'prod';

  /// Both values present, and production builds must use https.
  static bool get isValid =>
      supabaseUrl.isNotEmpty &&
      supabaseAnonKey.isNotEmpty &&
      (!isProduction || supabaseUrl.startsWith('https://'));
}
