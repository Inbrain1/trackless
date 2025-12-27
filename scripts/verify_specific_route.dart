import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled2/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  // Routes to check based on user feedback (Cultura routes were: Garcilaso, Amauta, etc. found in seed script)
  // Pegaso was flagged in logs as sparse.
  print('--- LISTING ALL ROUTE IDs ---');
  final allDocs = await firestore.collection('busRoutes').get();
  for (var doc in allDocs.docs) {
    print(
        'ID: "${doc.id}" | Name field: "${doc.data()['name']}" | Source: ${doc.data()['geometry_source']}');
  }
}
