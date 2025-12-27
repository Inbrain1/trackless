import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_route.dart';

class BusRouteModel {
  final String name;
  final List<LatLng> routePoints;
  final List<BusStop> stops;

  BusRouteModel({
    required this.name,
    required this.routePoints,
    required this.stops,
  });

  factory BusRouteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    // === CRITICAL FIX: Enhanced route parsing with detailed logging ===
    List<LatLng> routePointsList = [];

    print("🔍 DEBUG: Parsing route for doc ID: ${doc.id}");
    print("🔍 DEBUG: Document data keys: ${data?.keys.toList()}");

    if (data != null && data.containsKey('route')) {
      print("🔍 DEBUG: 'route' field exists");
      print("🔍 DEBUG: 'route' type: ${data['route'].runtimeType}");

      if (data['route'] is List) {
        final rawRoute = data['route'] as List<dynamic>;
        print("🔍 DEBUG: Route list length: ${rawRoute.length}");

        // Sample first item to diagnose structure
        if (rawRoute.isNotEmpty) {
          print(
              "🔍 DEBUG: First route item type: ${rawRoute.first.runtimeType}");
          print("🔍 DEBUG: First route item: ${rawRoute.first}");
        }

        try {
          List<LatLng> parsedPoints = [];
          int successCount = 0;
          int failCount = 0;

          for (int i = 0; i < rawRoute.length; i++) {
            final point = rawRoute[i];
            LatLng? latLng;

            if (point is GeoPoint) {
              latLng = LatLng(point.latitude, point.longitude);
              successCount++;
            } else if (point is Map) {
              // Try different map formats
              if (point.containsKey('latitude') &&
                  point.containsKey('longitude')) {
                latLng = LatLng(point['latitude'], point['longitude']);
                successCount++;
              } else if (point.containsKey('lat') && point.containsKey('lng')) {
                latLng = LatLng(point['lat'], point['lng']);
                successCount++;
              } else {
                print(
                    "❌ DEBUG: Unexpected map format at index $i: ${point.keys.toList()}");
                failCount++;
              }
            } else {
              print(
                  "❌ DEBUG: Unexpected type at index $i: ${point.runtimeType}");
              failCount++;
            }

            if (latLng != null) {
              parsedPoints.add(latLng);
            }
          }

          routePointsList = parsedPoints;
          print(
              "✅ DEBUG: Successfully parsed $successCount points, failed: $failCount");
          print(
              "✅ DEBUG: Final routePointsList length: ${routePointsList.length}");
        } catch (e, stackTrace) {
          print("❌ CRITICAL ERROR parsing 'route': $e");
          print("❌ Stack trace: $stackTrace");
          routePointsList = [];
        }
      } else {
        print("❌ DEBUG: 'route' field exists but is NOT a List!");
      }
    } else {
      print("❌ DEBUG: 'route' field does NOT exist in document!");
    }

    // Parse stops (keeping existing logic)
    List<BusStop> stopsList = [];
    if (data != null && data['stops'] is List) {
      try {
        int index = 1;
        stopsList = (data['stops'] as List<dynamic>)
            .map((point) {
              String stopName = 'Parada $index';
              LatLng? position;

              if (point is GeoPoint) {
                position = LatLng(point.latitude, point.longitude);
              } else if (point is Map) {
                if (point.containsKey('coordenada') &&
                    point['coordenada'] is GeoPoint) {
                  final geoPoint = point['coordenada'] as GeoPoint;
                  position = LatLng(geoPoint.latitude, geoPoint.longitude);
                } else if (point.containsKey('lat') &&
                    point.containsKey('lng')) {
                  position = LatLng(point['lat'], point['lng']);
                }

                if (point.containsKey('name')) {
                  stopName = point['name'];
                }
              }

              if (position != null) {
                index++;
                return BusStop(name: stopName, position: position);
              }

              return null;
            })
            .where((point) => point != null)
            .cast<BusStop>()
            .toList();
      } catch (e) {
        print("Error parseando 'stops': $e");
        stopsList = [];
      }
    }

    // === REMOVED FALLBACK LOGIC - DO NOT USE STOPS AS ROUTE ===
    // The fallback was causing the zig-zag pattern
    if (routePointsList.isEmpty) {
      print(
          "⚠️⚠️⚠️ CRITICAL WARNING: Route data is EMPTY for '${data?['name'] ?? doc.id}'!");
      print("⚠️ Stops count: ${stopsList.length}");
      print("⚠️ This will result in NO polyline being drawn!");
      // DO NOT fallback to stops - let it be empty so we can diagnose the real issue
    }

    return BusRouteModel(
      name: data?['name'] ?? data?['mainName'] ?? doc.id,
      routePoints: routePointsList, // Will be empty if parsing failed
      stops: stopsList,
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
