import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled2/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('--- CHECKING FIRESTORE USERS ---');
  final snapshot = await FirebaseFirestore.instance.collection('users').get();

  if (snapshot.docs.isEmpty) {
    print('❌ No users found in "users" collection.');
  } else {
    print('Found ${snapshot.docs.length} users:');
    for (var doc in snapshot.docs) {
      print('  - ID: ${doc.id}, Data: ${doc.data()}');
    }
  }
}
