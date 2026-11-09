import 'package:get_it/get_it.dart';
import 'package:xchat/core/services/connectivity_service.dart';
import 'package:xchat/features/connectivity/domain/usecases/watch_connectivity.dart';
import 'package:xchat/features/connectivity/presentation/cubit/connectivity_cubit.dart';

void registerConnectivityDependencies(GetIt sl) {
  sl
    ..registerLazySingleton(() => WatchConnectivity(sl<ConnectivityService>()))
    ..registerFactory(() => ConnectivityCubit(sl()));
}
