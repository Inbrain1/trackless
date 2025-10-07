import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../entities/user.dart';

abstract class AuthRepository {
  // Devuelve un Stream para escuchar los cambios de estado de autenticación.
  Stream<firebase.User?> get authStateChanges;

  // Inicia sesión con email y contraseña.
  Future<User?> signIn({required String email, required String password});

  // Registra un nuevo usuario.
  Future<User?> register({
    required String email,
    required String password,
    required String role,
  });

  // Cierra la sesión actual.
  Future<void> signOut();

  // Obtiene los detalles de un usuario desde Firestore.
  Future<User?> getUserDetails(String uid);
}