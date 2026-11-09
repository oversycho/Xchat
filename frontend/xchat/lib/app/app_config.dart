/// Build-time configuration, supplied with `--dart-define` / `--dart-define-from-file`.
/// Only the public anon key belongs here; never the service_role key.
abstract final class AppConfig {
  static const supabaseUrl = String.fromEnvironment(
    'https://muupaieqrzrkxiwmmoid.supabase.co',
  );
  static const supabaseAnonKey = String.fromEnvironment(
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im11dXBhaWVxcnpya3hpd21tb2lkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTM3MjYwNTksImV4cCI6MjEwOTMwMjA1OX0.a9vYRCjDdf_xYUcpk88ZkkP38ItULhJgApwbBcvSNgw',
  );

  /// `dev` (default), `staging` or `prod`.
  static const environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static bool get isProduction => environment == 'prod';

  /// Both values present, and production builds must use https.
  static bool get isValid =>
      supabaseUrl.isNotEmpty &&
      supabaseAnonKey.isNotEmpty &&
      (!isProduction || supabaseUrl.startsWith('https://'));
}
