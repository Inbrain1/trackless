import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;

class AutoSeeder {
  static const String _jsonAssetPath =
      'lib/delete/data/full_bus_routes copy.json';

  // Hardcoded data for missing "culturaRoutes"
  static const List<Map<String, dynamic>> _culturaRoutesData = [
    {
      "name": "Garcilaso",
      "location": {"lat": -13.521317532907313, "lng": -71.96651320899271}
    },
    {
      "name": "Amauta",
      "location": {"lat": -13.522359303212086, "lng": -71.9631560083819}
    },
    {
      "name": "Universidad San Antonio de Abad",
      "location": {"lat": -13.52347720169373, "lng": -71.95948577846217}
    },
    {
      "name": "Hospital Regional",
      "location": {"lat": -13.524473967615657, "lng": -71.95626285928323}
    },
    {
      "name": "Manuel Prado",
      "location": {"lat": -13.525736587902498, "lng": -71.95196221699389}
    },
    {
      "name": "Magisterio",
      "location": {"lat": -13.526705866234407, "lng": -71.94887952422619}
    },
    {
      "name": "Marcavalle",
      "location": {"lat": -13.527464308545843, "lng": -71.94615587236648}
    },
    {
      "name": "Santa Ursula",
      "location": {"lat": -13.527795690068562, "lng": -71.94333863965413}
    },
    {
      "name": "1er Paradero SS",
      "location": {"lat": -13.528193249388455, "lng": -71.94018526301657}
    },
    {
      "name": "Callejón",
      "location": {"lat": -13.528728880776407, "lng": -71.93834060938691}
    },
    {
      "name": "2do Paradero SS",
      "location": {"lat": -13.529330563309049, "lng": -71.9362245362867}
    },
    {
      "name": "3er Paradero SS",
      "location": {"lat": -13.529658446725437, "lng": -71.93496250356029}
    },
    {
      "name": "4to Paradero SS",
      "location": {"lat": -13.530284676783914, "lng": -71.93280987118418}
    },
    {
      "name": "5to Paradero SS",
      "location": {"lat": -13.531073107156718, "lng": -71.93009082154326}
    },
    {
      "name": "6to Paradero SS",
      "location": {"lat": -13.53150618723304, "lng": -71.92835825349091}
    },
    {
      "name": "7mo Paradero SS",
      "location": {"lat": -13.53229298699121, "lng": -71.92571276515717}
    }
  ];

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

        final String name = routeData['name']?.toString().trim() ?? '';
        final String code = routeData['code']?.toString().trim() ?? '';

        List<dynamic> routePoints = [];
        final rawRoute = routeData['route'];

        if (rawRoute is List) {
          for (var item in rawRoute) {
            if (item is Map &&
                item['type'] == 'REFERENCE' &&
                item['value'] == 'culturaRoutes') {
              print(
                  'AutoSeeder: Detected inline REFERENCE "culturaRoutes". Injecting ${_culturaRoutesData.length} stops.');
              routePoints.addAll(_culturaRoutesData);
            } else {
              routePoints.add(item);
            }
          }
        } else if (rawRoute is Map &&
            rawRoute['type'] == 'REFERENCE' &&
            rawRoute['value'] == 'culturaRoutes') {
          // Handle case where the entire route is just a reference object (legacy check)
          routePoints = _culturaRoutesData;
        }

        if (name.isEmpty) {
          print(
              'AutoSeeder: WARNING - Skipping route at index $i due to missing name.');
          continue;
        }

        // 3. Map Data (Stops & Polyline)
        List<Map<String, dynamic>> stopsList = [];
        List<GeoPoint> polylinePoints = [];

        for (var point in routePoints) {
          final String pointName = point['name']?.toString() ?? '';
          final Map<String, dynamic> location = point['location'] ?? {};

          // Safer casting
          double? lat = (location['lat'] is num)
              ? (location['lat'] as num).toDouble()
              : null;
          double? lng = (location['lng'] is num)
              ? (location['lng'] as num).toDouble()
              : null;

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
          print(
              'AutoSeeder: WARNING - Route "$name" has no valid stops/locations. Skipping.');
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
          print(
              'AutoSeeder: Committing partial batch of $batchOperationCount operations...');
          await batch.commit();
          batch = firestore.batch(); // Create new batch
          batchOperationCount = 0;
        }
      }

      // Final Commit for remaining docs
      if (batchOperationCount > 0) {
        print(
            'AutoSeeder: Committing final batch of $batchOperationCount operations...');
        await batch.commit();
      }

      print(
          'AutoSeeder: SUCCESS! $successCount/$totalRoutes routes migrated/updated correctly.');
    } catch (e, stackTrace) {
      print('AutoSeeder: CRITICAL ERROR: $e');
      print(stackTrace);
    }
  }
}
