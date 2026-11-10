import 'package:get_it/get_it.dart';
import 'package:xchat/core/services/key_value_store.dart';
import 'package:xchat/features/settings/data/datasources/impl/theme_local_datasource_impl.dart';
import 'package:xchat/features/settings/data/datasources/theme_local_datasource.dart';
import 'package:xchat/features/settings/data/repositories/impl/theme_repository_impl.dart';
import 'package:xchat/features/settings/domain/repositories/theme_repository.dart';
import 'package:xchat/features/settings/domain/usecases/theme_usecases.dart';
import 'package:xchat/features/settings/presentation/cubit/theme_cubit.dart';

void registerSettingsDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<ThemeLocalDataSource>(
      () => ThemeLocalDataSourceImpl(sl<KeyValueStore>()),
    )
    ..registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl(sl<ThemeLocalDataSource>()))
    ..registerLazySingleton(() => GetThemeMode(sl<ThemeRepository>()))
    ..registerLazySingleton(() => SetThemeMode(sl<ThemeRepository>()))
    ..registerFactory(() => ThemeCubit(getThemeMode: sl(), setThemeMode: sl()));
}
