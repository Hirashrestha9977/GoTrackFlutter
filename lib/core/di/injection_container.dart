import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_cached_user.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/bus_tracking/data/datasources/bus_tracking_data_source.dart';
import '../../features/bus_tracking/data/repositories/bus_tracking_repository_impl.dart';
import '../../features/bus_tracking/domain/repositories/bus_tracking_repository.dart';
import '../../features/bus_tracking/domain/usecases/get_bus_tracking.dart';
import '../../features/bus_tracking/presentation/bloc/bus_tracking_bloc.dart';
import '../../features/live_map/data/datasources/live_map_data_source.dart';
import '../../features/live_map/data/repositories/live_map_repository_impl.dart';
import '../../features/live_map/domain/repositories/live_map_repository.dart';
import '../../features/live_map/domain/usecases/get_live_map.dart';
import '../../features/live_map/presentation/bloc/live_map_bloc.dart';
import '../../features/stops/data/datasources/stops_data_source.dart';
import '../../features/stops/data/repositories/stops_repository_impl.dart';
import '../../features/stops/domain/repositories/stops_repository.dart';
import '../../features/stops/domain/usecases/get_stop_arrivals.dart';
import '../../features/stops/presentation/bloc/stop_arrivals_bloc.dart';
import '../api/api_client.dart';
import '../mock/mock_json_loader.dart';
import '../network/network_info.dart';
import '../router/app_router.dart';

/// Service locator. Use `sl<T>()` only at composition points
/// (main / app / router), never inside domain or data classes.
final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(InternetConnection()),
  );
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(tokenProvider: () => sl<AuthLocalDataSource>().token),
  );

  // Static JSON standing in for the API. Remove once every feature has a
  // remote data source.
  sl.registerLazySingleton<MockJsonLoader>(() => const MockJsonLoader());

  _initAuth();
  _initLiveMap();
  _initBusTracking();
  _initStops();

  // Router (needs AuthBloc for redirects)
  sl.registerLazySingleton<AppRouter>(() => AppRouter(sl<AuthBloc>()));
}

void _initAuth() {
  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl(), local: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetCachedUser(sl()));

  // Bloc: a singleton because auth state is app-wide and the router
  // listens to it. Feature-scoped blocs should use registerFactory.
  sl.registerLazySingleton(
    () => AuthBloc(login: sl(), logout: sl(), getCachedUser: sl()),
  );
}

void _initLiveMap() {
  // Swap LiveMapMockDataSource for a remote implementation when the API
  // is ready.
  sl.registerLazySingleton<LiveMapDataSource>(
    () => LiveMapMockDataSource(sl()),
  );
  sl.registerLazySingleton<LiveMapRepository>(
    () => LiveMapRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetLiveMap(sl()));
  sl.registerFactory(() => LiveMapBloc(getLiveMap: sl()));
}

void _initBusTracking() {
  sl.registerLazySingleton<BusTrackingDataSource>(
    () => BusTrackingMockDataSource(sl()),
  );
  sl.registerLazySingleton<BusTrackingRepository>(
    () => BusTrackingRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetBusTracking(sl()));
  sl.registerFactory(() => BusTrackingBloc(getBusTracking: sl()));
}

void _initStops() {
  sl.registerLazySingleton<StopsDataSource>(() => StopsMockDataSource(sl()));
  sl.registerLazySingleton<StopsRepository>(() => StopsRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetStopArrivals(sl()));
  sl.registerFactory(() => StopArrivalsBloc(getStopArrivals: sl()));
}
