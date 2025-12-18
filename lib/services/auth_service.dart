import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Importa FlutterSecureStorage
import '../features/1_auth/data/models/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  const FlutterSecureStorage _storage = FlutterSecureStorage(); // Instancia de FlutterSecureStorage

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guardar el token de Firebase en el almacenamiento seguro
      String? idToken = await userCredential.user?.getIdToken();
      if (idToken != null) {
        await _storage.write(key: 'token', value: idToken);
      }

      return userCredential.user;
    } catch (e) {
      print('Error in signIn: $e');
      return null;
    }
  }

  Future<User?> register(String email, String password, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        role: role,
      );
      await _firestore.collection('users').doc(newUser.uid).set(newUser.toFirestore());

      // Guardar el token de Firebase en el almacenamiento seguro
      String? idToken = await userCredential.user?.getIdToken();
      if (idToken != null) {
        await _storage.write(key: 'token', value: idToken);
      }

      return userCredential.user;
    } catch (e) {
      print('Error in register: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _storage.delete(key: 'token'); // Eliminar el token del almacenamiento seguro
    } catch (e) {
      print('Error in signOut: $e');
    }
  }

  Future<String> readToken() async {
    return await _storage.read(key: 'token') ?? ''; // Leer el token del almacenamiento seguro
  }

  Stream<User?> get user {
    return _auth.authStateChanges(); // Escucha los cambios de estado de autenticación
  }

  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    } catch (e) {
      print('Error in getUserDetails: $e');
      return null;
    }
  }

  Future<void> updateUserDetails(UserModel userModel) async {
    try {
      await _firestore.collection('users').doc(userModel.uid).update(userModel.toFirestore());
    } catch (e) {
      print('Error in updateUserDetails: $e');
    }
  }
}
