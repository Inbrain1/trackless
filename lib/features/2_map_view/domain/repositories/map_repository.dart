import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_location.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_route.dart';

abstract class MapRepository {
  Future<BusRoute> getBusRouteDetails(String busName);
  Stream<List<BusLocation>> watchBusLocations(String busName);
  Stream<LatLng> watchUserLocation();
  Future<void> updateUserLocation(LatLng position);
  Future<void> stopSharingLocation();
  Stream<List<BusLocation>> watchAllActiveBuses(); // <-- NUEVO
}