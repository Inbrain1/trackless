import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  print('=== VERIFICANDO "Señor del Cabildo" ===\n');

  // Check in buses collection
  print('📍 Buscando en colección "buses":');
  final busesDoc =
      await firestore.collection('buses').doc('Señor del Cabildo').get();

  if (busesDoc.exists) {
    final data = busesDoc.data();
    print('  ✅ Encontrado en "buses"');
    print('  Campos: ${data?.keys.toList()}');
    print('  Tiene campo "route": ${data?.containsKey('route')}');
    print('  Tiene campo "stops": ${data?.containsKey('stops')}');
    if (data?.containsKey('route') == true) {
      print('  Puntos de ruta: ${(data!['route'] as List?)?.length ?? 0}');
    }
    if (data?.containsKey('stops') == true) {
      print('  Número de paradas: ${(data!['stops'] as List?)?.length ?? 0}');
    }
  } else {
    print('  ❌ NO encontrado en "buses"');
  }

  print('\n📍 Buscando en colección "busRoutes":');
  final routesDoc =
      await firestore.collection('busRoutes').doc('Señor del Cabildo').get();

  if (routesDoc.exists) {
    final data = routesDoc.data();
    print('  ✅ Encontrado en "busRoutes"');
    print('  Campos: ${data?.keys.toList()}');
    print('  Tiene campo "route": ${data?.containsKey('route')}');
    print('  Tiene campo "stops": ${data?.containsKey('stops')}');
    if (data?.containsKey('route') == true) {
      print('  Puntos de ruta: ${(data!['route'] as List?)?.length ?? 0}');
    }
    if (data?.containsKey('stops') == true) {
      print('  Número de paradas: ${(data!['stops'] as List?)?.length ?? 0}');
    }
  } else {
    print('  ❌ NO encontrado en "busRoutes"');
  }

  print('\n=== FIN VERIFICACIÓN ===');
}
