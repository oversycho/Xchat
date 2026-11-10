import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xchat/core/gateways/auth_gateway.dart';
import 'package:xchat/core/gateways/backend_gateway.dart';
import 'package:xchat/core/gateways/impl/in_memory_local_database.dart';
import 'package:xchat/core/gateways/impl/supabase_auth_gateway.dart';
import 'package:xchat/core/gateways/impl/supabase_backend_gateway.dart';
import 'package:xchat/core/gateways/impl/supabase_realtime_gateway.dart';
import 'package:xchat/core/gateways/local_database.dart';
import 'package:xchat/core/gateways/realtime_gateway.dart';
import 'package:xchat/core/services/clock.dart';
import 'package:xchat/core/services/connectivity_service.dart';
import 'package:xchat/core/services/error_reporter.dart';
import 'package:xchat/core/services/id_generator.dart';
import 'package:xchat/core/services/impl/connectivity_plus_service.dart';
import 'package:xchat/core/services/impl/local_database_data_cleaner.dart';
import 'package:xchat/core/services/impl/shared_preferences_key_value_store.dart';
import 'package:xchat/core/services/impl/system_clock.dart';
import 'package:xchat/core/services/impl/uuid_id_generator.dart';
import 'package:xchat/core/services/key_value_store.dart';
import 'package:xchat/core/services/local_data_cleaner.dart';
import 'package:xchat/features/authentication/authentication_injection.dart';
import 'package:xchat/features/connectivity/connectivity_injection.dart';
import 'package:xchat/features/messaging/messaging_injection.dart';
import 'package:xchat/features/settings/settings_injection.dart';

final GetIt sl = GetIt.instance;

/// Registers everything. Call once, after `Supabase.initialize`.
/// Only the anon key may ever be embedded in the app; never the service_role key.
Future<void> configureDependencies({
  required SupabaseClient supabase,
  required ErrorReporter errorReporter,
}) async {
  final preferences = await SharedPreferences.getInstance();

  sl
    ..registerSingleton<SupabaseClient>(supabase)
    ..registerSingleton<ErrorReporter>(errorReporter)
    ..registerSingleton<SharedPreferences>(preferences)
    // gateways
    ..registerLazySingleton<BackendGateway>(() => SupabaseBackendGateway(sl<SupabaseClient>()))
    ..registerLazySingleton<RealtimeGateway>(() => SupabaseRealtimeGateway(sl<SupabaseClient>()))
    ..registerLazySingleton<AuthGateway>(() => SupabaseAuthGateway(sl<SupabaseClient>()))
    // TODO(offline): replace with the Isar-backed LocalDatabase. The in-memory
    // implementation is NOT persistent, so offline support across restarts
    // does not work until this is swapped.
    ..registerLazySingleton<LocalDatabase>(InMemoryLocalDatabase.new)
    // services
    ..registerLazySingleton<Clock>(() => const SystemClock())
    ..registerLazySingleton<IdGenerator>(UuidIdGenerator.new)
    ..registerLazySingleton<ConnectivityService>(ConnectivityPlusService.new)
    ..registerLazySingleton<KeyValueStore>(
      () => SharedPreferencesKeyValueStore(sl<SharedPreferences>()),
    )
    ..registerLazySingleton<LocalDataCleaner>(() => LocalDatabaseDataCleaner(sl<LocalDatabase>()));

  registerAuthenticationDependencies(sl);
  registerSettingsDependencies(sl);
  registerConnectivityDependencies(sl);
  registerMessagingDependencies(sl);
}
