import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_location.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_route.dart';

abstract class MapRepository {
  // Obtiene los detalles de una ruta de bus (polilínea y paradas)
  Future<BusRoute> getBusRouteDetails(String busName);

  // Escucha en tiempo real las ubicaciones de los buses de una ruta específica
  Stream<List<BusLocation>> watchBusLocations(String busName);

  // Escucha la ubicación actual del propio usuario del dispositivo
  Stream<LatLng> watchUserLocation();

  // Actualiza la ubicación de un conductor en la base de datos
  Future<void> updateUserLocation(LatLng position);
}