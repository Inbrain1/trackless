  import 'package:flutter/material.dart';
  import 'package:google_maps_flutter/google_maps_flutter.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';

  import '../lib/delete/data/bus_routes.dart';
import '../lib/services/directions_service.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    final directionsService = DirectionsService();
    final firestore = FirebaseFirestore.instance;

      // Solo procesa y sube la ruta del bus con name 'Saylla huasao' y code 'RTI-01'
      for (final bus in buses.where((b) =>
          b.name == 'Cristo Blanco' && b.code == 'RTI-08')) {
      final routeCoords = bus.route;
      List<LatLng> fullRoute = [];

      for (int i = 0; i < routeCoords.length - 1; i++) {
        try {
          final segment = await directionsService.getRouteCoordinates(
            origin: routeCoords[i],
            destination: routeCoords[i + 1],
          );
          fullRoute.addAll(segment);
        } catch (e, stack) {
          print("❌ Error obteniendo segmento para '${bus.name}': $e");
          continue;
        }
      }

      final firestoreData = {
        "name": bus.name,
        "route": fullRoute
            .map((point) => {
                  "lat": point.latitude,
                  "lng": point.longitude,
                })
            .toList(),
        "stops": routeCoords
            .map((point) => {
                  "lat": point.latitude,
                  "lng": point.longitude,
                })
            .toList(),
      };

      try {
        await firestore
            .collection('busRoutes')
            .doc(bus.name)
            .set(firestoreData);
        print("✅ Ruta completa subida correctamente para '${bus.name}'");
      } catch (e, stack) {
        print("❌ Error subiendo '${bus.name}' a Firestore: $e");
      }
    }

    runApp(const MaterialApp(
      home: Scaffold(body: Center(child: Text('Ruta generada'))),
    ));
  }
