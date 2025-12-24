import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled2/app.dart';
import 'package:untitled2/core/di/service_locator.dart';
import 'firebase_options.dart';

import 'package:untitled2/core/services/auto_seeder.dart';

void main() async {
  // 1. Asegurarse de que los bindings de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Configurar nuestro Service Locator (GetIt)
  await setupLocator();

  // 4. MIGRACIÓN AUTOMÁTICA
  // Sube el JSON a Firestore cada vez que la app inicia (siempre overwrite)
  await AutoSeeder.seed();

  // 5. Correr la aplicación
  runApp(const MyApp());
}