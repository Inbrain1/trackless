import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/features/2_map_view/data/datasources/location_datasource.dart';
import 'package:untitled2/features/2_map_view/data/datasources/map_remote_datasource.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_location.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_route.dart';
import 'package:untitled2/features/2_map_view/domain/repositories/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remoteDataSource;
  final LocationDataSource locationDataSource;

  MapRepositoryImpl({
    required this.remoteDataSource,
    required this.locationDataSource,
  });

  @override
  Future<BusRoute> getBusRouteDetails(String busName) async {
    final model = await remoteDataSource.getBusRouteDetails(busName);
    return model.toEntity();
  }

  @override
  Stream<List<BusLocation>> watchBusLocations(String busName) {
    return remoteDataSource
        .watchBusLocations(busName)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Stream<LatLng> watchUserLocation() {
    return locationDataSource.watchUserLocation();
  }

  @override
  Future<void> updateUserLocation(LatLng position) {
    return remoteDataSource.updateUserLocation(position);
  }

  @override
  Future<void> stopSharingLocation() {
    return remoteDataSource.stopSharingLocation();
  }

  // --- NUEVO MÉTODO IMPLEMENTADO ---
  @override
  Stream<List<BusLocation>> watchAllActiveBuses() {
    return remoteDataSource
        .watchAllActiveBuses()
        .map((models) => models.map((model) => model.toEntity()).toList());
  }
}