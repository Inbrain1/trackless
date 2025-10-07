import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:untitled2/features/1_auth/data/datasources/auth_remote_datasource.dart';
import 'package:untitled2/features/1_auth/data/repositories/auth_repository_impl.dart';
import 'package:untitled2/features/1_auth/domain/repositories/auth_repository.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_bloc.dart';
import 'package:untitled2/features/2_map_view/data/datasources/location_datasource.dart';
import 'package:untitled2/features/2_map_view/data/datasources/map_remote_datasource.dart';
import 'package:untitled2/features/2_map_view/data/repositories/map_repository_impl.dart';
import 'package:untitled2/features/2_map_view/domain/repositories/map_repository.dart';
import 'package:untitled2/features/2_map_view/domain/usecases/update_user_location.dart';
import 'package:untitled2/features/2_map_view/domain/usecases/watch_bus_locations.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_bloc.dart';
import 'package:untitled2/features/4_driver_panel/data/datasources/driver_panel_datasource.dart';
import 'package:untitled2/features/4_driver_panel/data/repositories/driver_panel_repository_impl.dart';
import 'package:untitled2/features/4_driver_panel/domain/repositories/driver_panel_repository.dart';
import 'package:untitled2/features/4_driver_panel/domain/usecases/get_bus_list.dart';
import 'package:untitled2/features/4_driver_panel/domain/usecases/select_bus.dart';
import 'package:untitled2/features/4_driver_panel/presentation/bloc/bus_selection_bloc.dart';

import '../../features/2_map_view/domain/usecases/get_bus_route_details.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // --- AUTH FEATURE ---

  // BLoC
  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );

  // --- DRIVER PANEL FEATURE ---

  // BLoC
  sl.registerFactory(() => BusSelectionBloc(
    getBusListUseCase: sl(),
    selectBusUseCase: sl(),
  ));

  // UseCases
  sl.registerLazySingleton(() => GetBusListUseCase(sl()));
  sl.registerLazySingleton(() => SelectBusUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<DriverPanelRepository>(
        () => DriverPanelRepositoryImpl(dataSource: sl()),
  );

  // DataSources
  sl.registerLazySingleton<DriverPanelDataSource>(
        () => DriverPanelDataSourceImpl(firestore: sl(), firebaseAuth: sl()),
  );

  // --- MAP VIEW FEATURE ---

  // BLoC
  sl.registerFactory(() => MapBloc(
    getBusRouteDetails: sl(),
    watchBusLocations: sl(),
    mapRepository: sl(),
  ));

  // UseCases
  sl.registerLazySingleton(() => GetBusRouteDetailsUseCase(sl()));
  sl.registerLazySingleton(() => WatchBusLocationsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserLocationUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<MapRepository>(
        () => MapRepositoryImpl(remoteDataSource: sl(), locationDataSource: sl()),
  );

  // DataSources
  sl.registerLazySingleton<MapRemoteDataSource>(
        () => MapRemoteDataSourceImpl(firestore: sl(), firebaseAuth: sl()),
  );
  sl.registerLazySingleton<LocationDataSource>(() => LocationDataSourceImpl());

  // --- EXTERNAL ---
  // Dependencias externas como Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}