import 'package:get_it/get_it.dart';
import 'package:xchat/core/gateways/auth_gateway.dart';
import 'package:xchat/core/mappers/entity_mapper.dart';
import 'package:xchat/core/services/local_data_cleaner.dart';
import 'package:xchat/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:xchat/features/authentication/data/datasources/impl/auth_remote_datasource_impl.dart';
import 'package:xchat/features/authentication/data/mappers/auth_user_mapper.dart';
import 'package:xchat/features/authentication/data/models/auth_user_model.dart';
import 'package:xchat/features/authentication/data/repositories/impl/auth_repository_impl.dart';
import 'package:xchat/features/authentication/domain/entities/auth_user.dart';
import 'package:xchat/features/authentication/domain/repositories/auth_repository.dart';
import 'package:xchat/features/authentication/domain/usecases/auth_usecases.dart';
import 'package:xchat/features/authentication/presentation/bloc/auth_bloc.dart';

/// Composition root of the authentication feature (the only place that sees `*Impl`).
void registerAuthenticationDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<EntityMapper<AuthUserModel, AuthUser>>(() => const AuthUserMapper())
    ..registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl<AuthGateway>()))
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: sl<AuthRemoteDataSource>(),
        mapper: sl<EntityMapper<AuthUserModel, AuthUser>>(),
      ),
    )
    ..registerLazySingleton(() => WatchAuthState(sl<AuthRepository>()))
    ..registerLazySingleton(() => GetCurrentUser(sl<AuthRepository>()))
    ..registerLazySingleton(() => SignInWithPhone(sl<AuthRepository>()))
    ..registerLazySingleton(() => VerifyOtp(sl<AuthRepository>()))
    ..registerLazySingleton(() => SignOut(sl<AuthRepository>(), sl<LocalDataCleaner>()))
    ..registerLazySingleton(() => DeleteAccount(sl<AuthRepository>(), sl<LocalDataCleaner>()))
    // Provided once at the app root (global, unlike the conversation-scoped chat blocs).
    // A factory because BlocProvider closes what it creates.
    ..registerFactory(
      () => AuthBloc(
        watchAuthState: sl(),
        signInWithPhone: sl(),
        verifyOtp: sl(),
        signOut: sl(),
        deleteAccount: sl(),
      ),
    );
}
