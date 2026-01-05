import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/services/directions_service.dart';

class RouteSmoother {
  static Future<void> smoothAllRoutes() async {
    final firestore = FirebaseFirestore.instance;
    final directionsService = DirectionsService();

    print('RouteSmoother: Starting route smoothing (Google API)...');
    
    try {
      final snapshot = await firestore.collection('busRoutes').get();
      print('RouteSmoother: Found ${snapshot.docs.length} routes to process.');

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final String name = data['name'] ?? 'Unknown';
        final List<dynamic> stops = data['stops'] ?? [];

        if (stops.length < 2) {
          print('RouteSmoother: Skipping "$name" (fewer than 2 stops).');
          continue;
        }

        print('RouteSmoother: Processing "$name" (${stops.length} stops)...');
        List<GeoPoint> smoothPoints = [];

        // Iterate through stops in pairs
        for (int i = 0; i < stops.length - 1; i++) {
          final startMap = stops[i];
          final endMap = stops[i + 1];

          // Safely parse coordinates
          final double? startLat = _parseDouble(startMap['lat']);
          final double? startLng = _parseDouble(startMap['lng']);
          final double? endLat = _parseDouble(endMap['lat']);
          final double? endLng = _parseDouble(endMap['lng']);

          if (startLat == null || startLng == null || endLat == null || endLng == null) {
            print('RouteSmoother: Invalid coords at stop $i for "$name". Skipping segment.');
            continue;
          }

          try {
            // Fetch polyline from Google Directions API
            final List<LatLng> segmentPoints = await directionsService.getRouteCoordinates(
              origin: LatLng(startLat, startLng),
              destination: LatLng(endLat, endLng),
            );

            // Convert to GeoPoint
            for (var p in segmentPoints) {
              smoothPoints.add(GeoPoint(p.latitude, p.longitude));
            }
          } catch (e) {
            print('RouteSmoother: Error fetching segment $i for "$name": $e');
            // Fallback: Add straight line to keep connectivity
            smoothPoints.add(GeoPoint(startLat, startLng));
            smoothPoints.add(GeoPoint(endLat, endLng));
          }

          // Small delay to prevent hitting API rate limits too hard
          await Future.delayed(const Duration(milliseconds: 200));
        }

        if (smoothPoints.isNotEmpty) {
          // Update Firestore
          // We rely on the doc.id which should be the name from AutoSeeder
          await firestore.collection('busRoutes').doc(doc.id).update({
            'route': smoothPoints,
          });
          print('RouteSmoother: Updated "$name" with ${smoothPoints.length} smooth points.');
        }
      }
      
      print('RouteSmoother: ALL ROUTES COMPLETED.');
    } catch (e, s) {
      print('RouteSmoother: CRITICAL ERROR: $e');
      print(s);
    }
  }

  static double? _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
