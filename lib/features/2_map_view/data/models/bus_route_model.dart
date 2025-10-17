import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_route.dart';

class BusRouteModel {
  final String name;
  final List<LatLng> routePoints;
  final List<LatLng> stops;

  BusRouteModel({
    required this.name,
    required this.routePoints,
    required this.stops,
  });

  factory BusRouteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Make data nullable

    // --- MODIFICACIÓN CLAVE: Añadir null checks y valores por defecto ---
    List<LatLng> routePointsList = [];
    if (data != null && data['route'] is List) {
      // Intenta parsear la lista solo si existe y es una lista
      try {
        routePointsList = (data['route'] as List<dynamic>)
        // Añadimos un check extra por si los puntos no son GeoPoints o Maps
            .map((point) {
          if (point is GeoPoint) {
            return LatLng(point.latitude, point.longitude);
          } else if (point is Map && point.containsKey('lat') && point.containsKey('lng')) {
            // Soporte para formato {lat: ..., lng: ...}
            return LatLng(point['lat'], point['lng']);
          }
          // Si no es un formato esperado, lo ignoramos o lanzamos error
          print("Formato de punto de ruta inesperado: $point");
          return null; // O podrías lanzar una excepción
        })
            .where((point) => point != null) // Filtramos los nulos
            .cast<LatLng>() // Aseguramos el tipo
            .toList();
      } catch (e) {
        print("Error parseando 'route': $e. Usando lista vacía.");
        routePointsList = []; // Fallback a lista vacía en caso de error de parseo
      }
    }

    List<LatLng> stopsList = [];
    if (data != null && data['stops'] is List) {
      // Intenta parsear la lista solo si existe y es una lista
      try {
        stopsList = (data['stops'] as List<dynamic>)
            .map((point) {
          if (point is GeoPoint) {
            return LatLng(point.latitude, point.longitude);
          } else if (point is Map && point.containsKey('lat') && point.containsKey('lng')) {
            return LatLng(point['lat'], point['lng']);
          }
          print("Formato de punto de parada inesperado: $point");
          return null;
        })
            .where((point) => point != null)
            .cast<LatLng>()
            .toList();
      } catch (e) {
        print("Error parseando 'stops': $e. Usando lista vacía.");
        stopsList = [];
      }
    }

    return BusRouteModel(
      name: data?['name'] ?? data?['mainName'] ?? doc.id, // Usa 'name', 'mainName' o el ID como fallback
      routePoints: routePointsList, // Usa la lista parseada o vacía
      stops: stopsList, // Usa la lista parseada o vacía
    );
  }

  BusRoute toEntity() {
    return BusRoute(
      name: name,
      routePoints: routePoints,
      stops: stops,
    );
  }
}