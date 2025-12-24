import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;

class AutoSeeder {
  static const String _jsonAssetPath = 'lib/delete/data/full_bus_routes copy.json';

  /// Automatically seeds/updates Firestore with data from the local JSON asset.
  /// Call this method in main.dart before runApp for auto-migration.
  static Future<void> seed() async {
    print('AutoSeeder: Starting automatic migration check...');

    try {
      final firestore = FirebaseFirestore.instance;
      var batch = firestore.batch();

      // 1. Load JSON file
      print('AutoSeeder: Reading asset $_jsonAssetPath...');
      final String jsonString = await rootBundle.loadString(_jsonAssetPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      
      final int totalRoutes = jsonList.length;
      print('AutoSeeder: JSON loaded. Found $totalRoutes routes.');

      // 2. Prepare for Batch Processing
      int processedCount = 0;
      int batchOperationCount = 0;
      int successCount = 0;

      for (var i = 0; i < totalRoutes; i++) {
        final routeData = jsonList[i];
        processedCount++;
        
        final String name = routeData['name']?.toString() ?? '';
        final String code = routeData['code']?.toString() ?? '';
        final List<dynamic> routePoints = routeData['route'] ?? [];
        
        if (name.isEmpty) {
          print('AutoSeeder: WARNING - Skipping route at index $i due to missing name.');
          continue;
        }

        // 3. Map Data (Stops & Polyline)
        List<Map<String, dynamic>> stopsList = [];
        List<GeoPoint> polylinePoints = [];

        for (var point in routePoints) {
          final String pointName = point['name']?.toString() ?? '';
          final Map<String, dynamic> location = point['location'] ?? {};
          
          // Safer casting
          double? lat = (location['lat'] is num) ? (location['lat'] as num).toDouble() : null;
          double? lng = (location['lng'] is num) ? (location['lng'] as num).toDouble() : null;

          if (lat != null && lng != null) {
            stopsList.add({
              'name': pointName,
              'lat': lat,
              'lng': lng,
            });
            polylinePoints.add(GeoPoint(lat, lng));
          }
        }

        if (stopsList.isEmpty) {
           print('AutoSeeder: WARNING - Route "$name" has no valid stops/locations. Skipping.');
           continue;
        }

        // 4. Create Document Reference & Data
        final docRef = firestore.collection('busRoutes').doc(name);
        
        final Map<String, dynamic> docData = {
          'name': name,
          'code': code,
          'stops': stopsList, 
          'route': polylinePoints, 
          'lastUpdated': FieldValue.serverTimestamp(),
        };

        batch.set(docRef, docData);
        batchOperationCount++;
        successCount++;

        // 5. Commit Batch periodically (limit is 500, we use 400 for safety)
        if (batchOperationCount >= 400) {
          print('AutoSeeder: Committing partial batch of $batchOperationCount operations...');
          await batch.commit();
          batch = firestore.batch(); // Create new batch
          batchOperationCount = 0;
        }
      }

      // Final Commit for remaining docs
      if (batchOperationCount > 0) {
        print('AutoSeeder: Committing final batch of $batchOperationCount operations...');
        await batch.commit();
      }
      
      print('AutoSeeder: SUCCESS! $successCount/$totalRoutes routes migrated/updated correctly.');

    } catch (e, stackTrace) {
      print('AutoSeeder: CRITICAL ERROR: $e');
      print(stackTrace);
    }
  }
}
