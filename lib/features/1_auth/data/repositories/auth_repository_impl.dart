import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:untitled2/features/1_auth/data/datasources/auth_remote_datasource.dart';
import 'package:untitled2/features/1_auth/domain/entities/user.dart';
import 'package:untitled2/features/1_auth/domain/repositories/auth_repository.dart';

// Esta clase implementa el contrato definido en la capa de dominio.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<firebase.User?> get authStateChanges => remoteDataSource.authStateChanges;

  @override
  Future<User?> signIn({required String email, required String password}) async {
    final userModel = await remoteDataSource.signIn(email: email, password: password);
    // Convierte el Modelo de la capa de datos a la Entidad del dominio.
    return userModel?.toEntity();
  }

  @override
  Future<User?> register({
    required String email,
    required String password,
    required String role,
    String name = 'Usuario', // Add name parameter
  }) async {
    final userModel = await remoteDataSource.register(
      email: email,
      password: password,
      role: role,
      name: name, // Pass name
    );
    return userModel?.toEntity();
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Future<User?> getUserDetails(String uid) async {
    final userModel = await remoteDataSource.getUserDetails(uid);
    return userModel?.toEntity();
  }

  @override
  Future<User?> signInAnonymously() async {
    final userModel = await remoteDataSource.signInAnonymously();
    return userModel?.toEntity();
  }
}