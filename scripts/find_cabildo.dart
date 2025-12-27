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
  print('=== BUSCANDO TODOS LOS "Señor del Cabildo" ===\n');

  // Buscar en buses collection
  print('📍 Buscando en colección "buses":');
  final busesSnapshot = await firestore.collection('buses').get();
  final cabildoBuses = busesSnapshot.docs
      .where((doc) =>
          doc.id.toLowerCase().contains('cabildo') ||
          (doc.data()['mainName'] as String?)
                  ?.toLowerCase()
                  .contains('cabildo') ==
              true)
      .toList();

  print('  Encontrados: ${cabildoBuses.length} documentos');
  for (var doc in cabildoBuses) {
    final data = doc.data();
    print('\n  📄 ID: "${doc.id}"');
    print('     mainName: ${data['mainName']}');
    print('     Campos: ${data.keys.toList()}');
    print(
        '     Tiene "route": ${data.containsKey('route')} (${(data['route'] as List?)?.length ?? 0} puntos)');
    print(
        '     Tiene "stops": ${data.containsKey('stops')} (${(data['stops'] as List?)?.length ?? 0} paradas)');
  }

  // Buscar en busRoutes collection
  print('\n📍 Buscando en colección "busRoutes":');
  final routesSnapshot = await firestore.collection('busRoutes').get();
  final cabildoRoutes = routesSnapshot.docs
      .where((doc) =>
          doc.id.toLowerCase().contains('cabildo') ||
          (doc.data()['name'] as String?)?.toLowerCase().contains('cabildo') ==
              true)
      .toList();

  print('  Encontrados: ${cabildoRoutes.length} documentos');
  for (var doc in cabildoRoutes) {
    final data = doc.data();
    print('\n  📄 ID: "${doc.id}"');
    print('     name: ${data['name']}');
    print('     Campos: ${data.keys.toList()}');
    print(
        '     Tiene "route": ${data.containsKey('route')} (${(data['route'] as List?)?.length ?? 0} puntos)');
    print(
        '     Tiene "stops": ${data.containsKey('stops')} (${(data['stops'] as List?)?.length ?? 0} paradas)');
  }

  print('\n=== FIN BÚSQUEDA ===');
}
