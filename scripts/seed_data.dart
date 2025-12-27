import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled2/firebase_options.dart';
import 'package:flutter/services.dart' show rootBundle;

// Hardcoded data for missing "culturaRoutes"
const List<Map<String, dynamic>> _culturaRoutesData = [
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

void main() async {
  print('--- INITIATING DEDICATED DATA SEEDING ---');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;

  print('Reading JSON asset...');
  try {
    // Note: Ensure this asset is defined in pubspec.yaml
    final String jsonString = await rootBundle
        .loadString('lib/delete/data/full_bus_routes copy.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    final int totalRoutes = jsonList.length;

    print('Found $totalRoutes routes in JSON.');

    var batch = firestore.batch();
    int processedCount = 0;
    int batchOperationCount = 0;
    int updatedCount = 0;

    for (var i = 0; i < totalRoutes; i++) {
      final routeData = jsonList[i];
      final String name = routeData['name']?.toString() ?? '';
      final String code = routeData['code']?.toString() ?? '';

      // Handle "REFERENCE" nested inside List or as Map
      List<dynamic> routePoints = [];
      final rawRoute = routeData['route'];

      if (rawRoute is List) {
        for (var item in rawRoute) {
          if (item is Map &&
              item['type'] == 'REFERENCE' &&
              item['value'] == 'culturaRoutes') {
            print(
                '  🔹 [SPECIAL] Expanding "culturaRoutes" reference in $name');
            routePoints.addAll(_culturaRoutesData);
          } else {
            routePoints.add(item);
          }
        }
      } else if (rawRoute is Map &&
          rawRoute['type'] == 'REFERENCE' &&
          rawRoute['value'] == 'culturaRoutes') {
        print(
            '  🔹 [SPECIAL] Exploring "culturaRoutes" reference (Root) in $name');
        routePoints = _culturaRoutesData;
      }

      if (name.isEmpty) continue;

      // Map Data
      List<Map<String, dynamic>> stopsList = [];
      List<GeoPoint> polylinePoints = [];

      for (var point in routePoints) {
        final String pointName = point['name']?.toString() ?? '';
        final Map<String, dynamic> location = point['location'] ?? {};

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
        print('  ⚠️ Warning: Route "$name" has no valid stops. Skipping.');
        continue;
      }

      final docRef = firestore.collection('busRoutes').doc(name);

      final Map<String, dynamic> docData = {
        'name': name,
        'code': code,
        'stops': stopsList,
        'route': polylinePoints,
        'lastUpdated': FieldValue.serverTimestamp(),
        'geometry_source': 'json_seed' // Marking source
      };

      batch.set(docRef, docData);
      batchOperationCount++;
      updatedCount++;

      if (batchOperationCount >= 400) {
        print('  Committing batch of $batchOperationCount...');
        await batch.commit();
        batch = firestore.batch();
        batchOperationCount = 0;
      }
    }

    if (batchOperationCount > 0) {
      print('  Committing final batch of $batchOperationCount...');
      await batch.commit();
    }

    print('--- SEEDING COMPLETE ---');
    print('Updated $updatedCount / $totalRoutes routes.');
    print(
        'NOTE: This process overwrote dense geometry. PLEASE RUN FIX_ROUTE_GEOMETRY AGAIN.');
  } catch (e) {
    print('❌ Error: $e');
  }
}
