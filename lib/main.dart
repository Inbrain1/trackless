import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/app.dart';
import 'package:untitled2/core/di/service_locator.dart';
import 'firebase_options.dart';

import 'package:untitled2/core/services/auto_seeder.dart';
import 'package:untitled2/core/services/route_smoother.dart';

void main() async {
  // 1. Asegurarse de que los bindings de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Configurar nuestro Service Locator (GetIt)
  await setupLocator();

  // PRUEBA DE CONEXIÓN FIRESTORE
  try {
    print('DEBUG: Probando conexión a Firestore...');
    await FirebaseFirestore.instance
        .collection('busRoutes')
        .limit(1)
        .get()
        .timeout(const Duration(seconds: 5));
    print('DEBUG: ✅ Conexión a Firestore EXITOSA.');
  } catch (e) {
    print('DEBUG: ❌ Fallo de conexión a Firestore: $e');
  }

  // 4. MIGRACIÓN AUTOMÁTICA
  // Sube el JSON a Firestore cada vez que la app inicia (siempre overwrite)
  // await AutoSeeder.seed();
  
  // 5. SMOOTHING DE RUTAS (Una sola vez, luego comentar)
  // await RouteSmoother.smoothAllRoutes();

  // 5. Correr la aplicación
  runApp(const MyApp());
}
