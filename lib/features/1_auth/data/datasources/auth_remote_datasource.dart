import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:untitled2/features/1_auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<firebase.User?> get authStateChanges;
  Future<UserModel?> signIn({required String email, required String password});
  Future<UserModel?> register({
    required String email,
    required String password,
    required String role,
  });
  Future<void> signOut();
  Future<UserModel?> getUserDetails(String uid);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    required firebase.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  @override
  Stream<firebase.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<UserModel?> signIn({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return getUserDetails(userCredential.user!.uid);
      }
      return null;
    } on firebase.FirebaseAuthException catch (e) {
      // Aquí puedes manejar errores específicos de Firebase
      print('Error en signIn: ${e.message}');
      return null;
    }
  }

  @override
  Future<UserModel?> register({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // Crear el modelo de usuario para guardar en Firestore
        final userModel = UserModel(
          uid: user.uid,
          email: email,
          role: role,
        );

        // Guardar los detalles del usuario en la colección 'users'
        await _firestore.collection('users').doc(user.uid).set(userModel.toFirestore());
        return userModel;
      }
      return null;
    } on firebase.FirebaseAuthException catch (e) {
      print('Error en register: ${e.message}');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getUserDetails(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        return UserModel.fromFirestore(docSnapshot.data()!, uid);
      }
      return null;
    } catch (e) {
      print('Error en getUserDetails: $e');
      return null;
    }
  }
}