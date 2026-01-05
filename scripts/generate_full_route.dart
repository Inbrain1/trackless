import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'package:untitled2/firebase_options.dart';

/// Enhanced Route Generation Script with Safety Features
///
/// Features:
/// - Fetches ALL buses from Firestore
/// - Fallback: checks 'busRoutes' collection if 'buses' doc has no coordinates
/// - Fallback: parses 'route' (sparse) if 'stops' is missing
/// - Waypoint pagination (handles routes with >23 stops)
/// - Safe Firestore updates (preserves existing data)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final generator = RouteGenerator();
  await generator.run();
}

class RouteGenerator {
  final String apiKey = 'AIzaSyCfDZ-V4A3tkoeTCLZAxbhvqz5rQTdaNvc';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // API Limits
  static const int maxWaypointsPerRequest = 23;
  static const int delayBetweenRequests = 300; // milliseconds

  Future<void> run() async {
    print('╔════════════════════════════════════════════════════════════════╗');
    print('║        GOOGLE DIRECTIONS API - ROUTE GENERATOR (FIRESTORE)     ║');
    print(
        '╚════════════════════════════════════════════════════════════════╝\n');

    print('📥 Fetching routes from Firestore busRoutes collection...');
    final busesSnapshot = await firestore.collection('busRoutes').get(); // FIX: Changed from buses to busRoutes
    final docs = busesSnapshot.docs;
    print('👉 Found ${docs.length} routes in database.');

    print('Auto-proceeding with route generation (BYPASS)...');
    print('\n🚀 Starting route generation...\n');

    int successCount = 0;
    int failCount = 0;
    List<String> failedBuses = [];

    for (int i = 0; i < docs.length; i++) {
      final doc = docs[i];
      final busName = doc.id;
      final data = doc.data();

      print('[${i + 1}/${docs.length}] Processing: "$busName"');

      // 1. Try to parse from 'buses' doc
      var routeCoords = _parseStopsFromFirestore(data);

      // 2. Fallback: Check busRoutes collection if not found in buses
      if (routeCoords.isEmpty) {
        print(
            '   ⚠️ Coords missing in "buses". Checking "busRoutes" collection...');
        // Try to find a doc with the same ID in busRoutes
        // Note: Assuming ID matches.
        final routeDoc =
            await firestore.collection('busRoutes').doc(busName).get();
        if (routeDoc.exists) {
          final routeData = routeDoc.data();
          final fallbackPoints = _parseStopsFromFirestore(routeData);
          if (fallbackPoints.isNotEmpty) {
            routeCoords = fallbackPoints;
            print(
                '   ✅ Found ${routeCoords.length} points in busRoutes fallback.');
          }
        }
      }

      if (routeCoords.isEmpty) {
        print(
            '   ❌ Skipped: No route/stops points found in buses or busRoutes.');
        failCount++;
        failedBuses.add('$busName (No data)');
        continue;
      }

      print('   Stops: ${routeCoords.length}');

      try {
        // Generate full route
        final fullRoute = await _generateFullRoute(routeCoords, busName);

        if (fullRoute.isEmpty) {
          print('   ⚠️ Empty route generated.');
          failCount++;
          continue;
        }

        // Save to Firestore (Copying stops too)
        await _saveToFirestore(busName, fullRoute, routeCoords);
        successCount++;
        print('   ✅ Success! Generated ${fullRoute.length} route points');
      } catch (e) {
        print('   ❌ Failed: $e');
        failCount++;
        failedBuses.add(busName);
      }

      await Future.delayed(
          Duration(milliseconds: RouteGenerator.delayBetweenRequests));
    }

    // Summary
    print(
        '\n╔════════════════════════════════════════════════════════════════╗');
    print('║                    GENERATION COMPLETE                         ║');
    print('╠════════════════════════════════════════════════════════════════╣');
    print('║  ✅ Successful: $successCount/${docs.length}');
    print('║  ❌ Failed:     $failCount/${docs.length}');
    print(
        '╚════════════════════════════════════════════════════════════════╝\n');

    runApp(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Route generation completed!\nCheck console for details.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }

  /// Generate full route with waypoint pagination
  Future<List<LatLng>> _generateFullRoute(
    List<LatLng> stops,
    String routeName,
  ) async {
    if (stops.length < 2) {
      print('   ⚠️  Route has less than 2 stops, skipping');
      return [];
    }

    List<LatLng> fullRoute = [];

    // If stops fit in single request
    if (stops.length <= maxWaypointsPerRequest + 1) {
      print('   📍 Single API call (${stops.length} stops)');
      final segment = await _getRouteSegment(stops.first, stops.last,
          waypoints: stops.sublist(1, stops.length - 1));
      fullRoute.addAll(segment);
    }
    // Need to paginate waypoints
    else {
      print('   📍 Multiple API calls needed (paginated waypoints)');
      final chunks = _chunkStops(stops);
      print('   📦 Split into ${chunks.length} chunks');

      for (int i = 0; i < chunks.length; i++) {
        final chunk = chunks[i];
        print('      Chunk ${i + 1}/${chunks.length}: ${chunk.length} stops');

        await Future.delayed(Duration(milliseconds: delayBetweenRequests));

        final segment = await _getRouteSegment(
          chunk.first,
          chunk.last,
          waypoints: chunk.length > 2 ? chunk.sublist(1, chunk.length - 1) : [],
        );

        fullRoute.addAll(segment);
      }
    }

    return fullRoute;
  }

  /// Split stops into chunks respecting API waypoint limit
  List<List<LatLng>> _chunkStops(List<LatLng> stops) {
    List<List<LatLng>> chunks = [];
    int index = 0;

    while (index < stops.length - 1) {
      // Each chunk: origin + up to 23 waypoints + destination = 25 points max
      final chunkSize = (index + maxWaypointsPerRequest + 1 < stops.length)
          ? maxWaypointsPerRequest + 2
          : stops.length - index;

      final chunk = stops.sublist(index, index + chunkSize);
      chunks.add(chunk);

      // Overlap by 1 point to ensure continuity
      index += chunkSize - 1;
    }

    return chunks;
  }

  /// Call Google Directions API for a route segment
  Future<List<LatLng>> _getRouteSegment(
    LatLng origin,
    LatLng destination, {
    List<LatLng> waypoints = const [],
  }) async {
    // Build URL with waypoints
    final waypointsParam = waypoints.isNotEmpty
        ? '&waypoints=${waypoints.map((w) => '${w.latitude},${w.longitude}').join('|')}'
        : '';

    final url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '$waypointsParam'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode} - ${response.body}');
    }

    final data = json.decode(response.body);

    if (data['status'] != 'OK') {
      throw Exception(
          'API status: ${data['status']} - ${data['error_message'] ?? 'Unknown error'}');
    }

    final encodedPolyline = data['routes'][0]['overview_polyline']['points'];
    return _decodePolyline(encodedPolyline);
  }

  /// Decode Google's encoded polyline format
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
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

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }

  /// Save to Firestore, ONLY updating 'route' field, NOT touching 'stops'
  Future<void> _saveToFirestore(String busName, List<LatLng> routePoints,
      List<LatLng> originalStops) async {
    // Convert to GeoPoint array
    final routeGeoPoints = routePoints
        .map((point) => GeoPoint(point.latitude, point.longitude))
        .toList();

    // ❌ NO actualizar stops - solo route
    // Use UPDATE instead of SET to preserve existing fields
    await firestore.collection('busRoutes').doc(busName).update({
      'route': routeGeoPoints,
      'routeUpdatedAt': FieldValue.serverTimestamp(),
      'routeSource': 'google_directions_api',
      'routePointsCount': routePoints.length,
    });
  }

  List<LatLng> _parseStopsFromFirestore(Map<String, dynamic>? data) {
    List<LatLng> points = [];
    if (data == null) return points;

    // Check 'stops' field first
    if (data['stops'] != null && data['stops'] is List) {
      for (var item in data['stops']) {
        if (item is GeoPoint) {
          points.add(LatLng(item.latitude, item.longitude));
        } else if (item is Map) {
          if (item.containsKey('coordenada') &&
              item['coordenada'] is GeoPoint) {
            final geo = item['coordenada'] as GeoPoint;
            points.add(LatLng(geo.latitude, geo.longitude));
          } else if (item.containsKey('lat') && item.containsKey('lng')) {
            points.add(LatLng(item['lat'], item['lng']));
          }
        }
      }
    }

    // Fallback: Check 'route' field (sparse points) if stops were somehow empty
    // This happens if we are reading from a doc that has old 'route' data but no 'stops'
    if (points.isEmpty && data['route'] != null && data['route'] is List) {
      for (var item in data['route']) {
        if (item is GeoPoint) {
          points.add(LatLng(item.latitude, item.longitude));
        } else if (item is Map) {
          // Handle map with lat/lng
          if (item.containsKey('lat') && item.containsKey('lng')) {
            points.add(LatLng(item['lat'], item['lng']));
          }
        }
      }
    }

    return points;
  }
}
