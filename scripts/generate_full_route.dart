import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// --- IMPORTACIONES CLAVE ---
import '../lib/delete/data/bus_routes.dart';
import '../lib/services/directions_service.dart';
// Importamos tus opciones de Firebase
import '../lib/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // --- CORRECCIÓN DE FIREBASE ---
  // Añadimos las 'options' para que sepa a qué proyecto conectarse
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final directionsService = DirectionsService();
  final firestore = FirebaseFirestore.instance;

  print('Iniciando subida de rutas completas para TODOS los buses...');

  // --- MODIFICACIÓN CLAVE ---
  // Eliminamos el .where(...) para iterar sobre TODOS los buses
  for (final bus in buses) {
    final routeCoords = bus.route;
    List<LatLng> fullRoute = [];

    print("🚌 Procesando ruta para: '${bus.name}'...");

    for (int i = 0; i < routeCoords.length - 1; i++) {
      try {
        // Pequeña pausa para no saturar la API de Google
        await Future.delayed(const Duration(milliseconds: 100));

        final segment = await directionsService.getRouteCoordinates(
          origin: routeCoords[i],
          destination: routeCoords[i + 1],
        );
        fullRoute.addAll(segment);
      } catch (e) {
        print("  ❌ Error obteniendo segmento $i para '${bus.name}': $e");
        // Si un segmento falla, continuamos con el siguiente
        continue;
      }
    }

    if (fullRoute.isEmpty) {
      print("  ⚠️ No se pudo generar la ruta completa para '${bus.name}'. Saltando subida.");
      continue;
    }

    // Convertimos a GeoPoint para Firestore
    final firestoreData = {
      "name": bus.name,
      "route": fullRoute
          .map((point) => GeoPoint(point.latitude, point.longitude))
          .toList(),
      "stops": routeCoords // Mantenemos los puntos originales como paradas
          .map((point) => GeoPoint(point.latitude, point.longitude))
          .toList(),
    };

    try {
      // Usamos el nombre del bus como ID del documento
      await firestore
          .collection('busRoutes')
          .doc(bus.name)
          .set(firestoreData);
      print("  ✅ Ruta completa subida correctamente para '${bus.name}'");
    } catch (e) {
      print("  ❌ Error subiendo '${bus.name}' a Firestore: $e");
    }
  }

  print('\n🎉 Proceso de subida de rutas completado.');

  // Esta parte solo es para que el script no termine abruptamente
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Text(
          'Proceso de subida de rutas a Firestore completado.\nRevisa la consola para ver el detalle.',
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ));
}