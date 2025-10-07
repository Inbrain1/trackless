import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../lib/delete/data/firebase_routes.dart'; // Aquí está tu ruta lista

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  await firestore.collection('busRoutes').doc('Satélite').set(sateliteRoute);

  print("Ruta subida correctamente.");

  runApp(const MaterialApp(home: Scaffold(body: Center(child: Text('Subida completa')))));
}