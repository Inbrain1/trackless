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
  print('--- VERIFYING FIRESTORE DATA ---');

  final routes = [' Arco Iris', 'Cristo Blanco'];

  for (final name in routes) {
    print('Checking: "$name"');
    final doc = await firestore.collection('busRoutes').doc(name).get();
    if (!doc.exists) {
      print('  ❌ Document does not exist!');
      continue;
    }

    final data = doc.data() as Map<String, dynamic>;
    final List? route = data['route'] as List?;
    final List? stops = data['stops'] as List?;

    print('  Route points: ${route?.length ?? 0}');
    print('  Stops count: ${stops?.length ?? 0}');
    print('  Source: ${data['geometry_source'] ?? 'Unknown'}');
  }
}
