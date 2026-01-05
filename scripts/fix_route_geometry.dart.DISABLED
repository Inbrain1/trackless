import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/firebase_options.dart';

/// MAINTENANCE SCRIPT: Fix Route Geometry
/// This script regenerates the dense 'route' field for all documents in 'busRoutes'
/// by using the existing 'stops' field and querying Google Directions API.
void main() async {
  // CONFIGURATION
  const bool isDryRun = false; // Set to false to actually update Firestore
  const String apiKey = 'AIzaSyCfDZ-V4A3tkoeTCLZAxbhvqz5rQTdaNvc';

  print('--- INITIATING ROUTE GEOMETRY FIX ---');
  print(
      'Mode: ${isDryRun ? "DRY RUN (No changes will be saved)" : "LIVE UPDATE"}');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final fixer = RouteFixer(apiKey: apiKey, isDryRun: isDryRun);
  await fixer.run();

  print('\n--- SCRIPT COMPLETED ---');
}

class RouteFixer {
  final String apiKey;
  final bool isDryRun;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Google API allows up to 25 points (origin + destination + 23 waypoints) per request.
  static const int maxWaypointsPerRequest = 23;

  RouteFixer({required this.apiKey, required this.isDryRun});

  Future<void> run() async {
    print('Fetching bus routes from Firestore...');
    final snapshot = await firestore.collection('busRoutes').get();
    final docs = snapshot.docs;
    print('Found ${docs.length} routes to process.\n');

    for (var doc in docs) {
      final routeName = doc.id;
      final data = doc.data();

      // Skip if already processed successfully by API (optimization)
      // BUT force re-process if we suspect it's stale or if we are in a comprehensive fix mode.
      // For this task, we want to fix EVERYTHING that is currently "json_seed" or has < 100 points
      final source = data['geometry_source'];
      final routeList = data['route'] as List? ?? [];

      bool needsUpdate = false;
      if (source != 'google_directions_api') needsUpdate = true;
      if (routeList.length < 100) needsUpdate = true; // Likely sparse

      if (!needsUpdate) {
        print('Skipping "$routeName" (Already dense & API sourced)');
        continue;
      }

      print('Processing: "$routeName"');

      // 1. Extract Stops
      final List<LatLng> stops = _extractStops(data);
      if (stops.length < 2) {
        print(
            '  ⚠️ Error: Route has ${stops.length} stops. Needs at least 2 to generate a path. Skipping.');
        continue;
      }

      print('  Found ${stops.length} stops. Generating dense geometry...');

      try {
        // 2. Generate Dense Path
        if (isDryRun) {
          print(
              '  [DRY RUN] Would generate geometry for ${stops.length} stops.');
          continue;
        }

        final densePath = await _generateDensePath(stops);
        print('  ✅ Generated ${densePath.length} points from road geometry.');

        // 3. Update Firestore
        await _updateFirestore(doc.reference, densePath);
        print('  💾 Firestore updated successfully.');

        // Anti-rate-limit delay
        await Future.delayed(const Duration(milliseconds: 300));
      } catch (e) {
        print('  ❌ Failed to process "$routeName": $e');
      }

      print('-----------------------------------------');
    }
  }

  List<LatLng> _extractStops(Map<String, dynamic> data) {
    List<LatLng> points = [];
    if (data['stops'] == null || data['stops'] is! List) return points;

    for (var item in data['stops']) {
      if (item is Map) {
        if (item.containsKey('coordenada') && item['coordenada'] is GeoPoint) {
          final gp = item['coordenada'] as GeoPoint;
          points.add(LatLng(gp.latitude, gp.longitude));
        } else if (item.containsKey('lat') && item.containsKey('lng')) {
          points.add(LatLng(item['lat'], item['lng']));
        }
      } else if (item is GeoPoint) {
        points.add(LatLng(item.latitude, item.longitude));
      }
    }
    return points;
  }

  Future<List<LatLng>> _generateDensePath(List<LatLng> stops) async {
    List<LatLng> fullPath = [];

    // Split stops into chunks to respect Google's waypoint limits
    // Each chunk: [origin, ..., destination] where middle points are waypoints
    int index = 0;
    while (index < stops.length - 1) {
      int nextIndex = index + maxWaypointsPerRequest + 1;
      if (nextIndex >= stops.length) nextIndex = stops.length - 1;

      final chunk = stops.sublist(index, nextIndex + 1);
      final segment = await _fetchDirectionsSegment(chunk);

      // Add all points, avoiding duplication of the join points
      if (fullPath.isEmpty) {
        fullPath.addAll(segment);
      } else {
        fullPath.addAll(segment.skip(1));
      }

      index = nextIndex;
    }

    return fullPath;
  }

  Future<List<LatLng>> _fetchDirectionsSegment(List<LatLng> points) async {
    final origin = points.first;
    final dest = points.last;
    final waypoints =
        points.length > 2 ? points.sublist(1, points.length - 1) : [];

    String url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${dest.latitude},${dest.longitude}'
        '&key=$apiKey';

    if (waypoints.isNotEmpty) {
      final wps =
          waypoints.map((p) => '${p.latitude},${p.longitude}').join('|');
      url +=
          '&waypoints=via:$wps'; // Using 'via:' for smoother interpolation without markers
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}');
    }

    final data = json.decode(response.body);
    if (data['status'] != 'OK') {
      throw Exception(
          'Directions API status: ${data['status']} - ${data['error_message'] ?? "No message"}');
    }

    final encoded = data['routes'][0]['overview_polyline']['points'];
    return _decodePolyline(encoded);
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return polyline;
  }

  Future<void> _updateFirestore(
      DocumentReference ref, List<LatLng> path) async {
    final List<GeoPoint> geoPoints =
        path.map((p) => GeoPoint(p.latitude, p.longitude)).toList();

    await ref.set({
      'route': geoPoints,
      'route_updated_at': FieldValue.serverTimestamp(),
      'geometry_source': 'google_directions_api'
    }, SetOptions(merge: true));
  }
}
