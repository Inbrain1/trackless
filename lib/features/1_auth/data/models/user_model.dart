import 'package:untitled2/features/1_auth/domain/entities/user.dart';

class UserModel {
  final String uid;
  final String email;
  final String role;
  final String name; // Added name

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.name = 'Usuario',
  });

  // Factory para crear un UserModel desde un mapa de Firestore
  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      role: data['role'] ?? 'Usuario',
      name: data['name'] ?? 'Usuario', // Map name from firestore
    );
  }

  // Método para convertir un UserModel a un mapa para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'role': role,
      'name': name, // Save name to firestore
    };
  }

  // --- AÑADIR ESTE MÉTODO ---
  // Convierte el modelo de datos (UserModel) a la entidad de dominio (User)
  User toEntity() {
    return User(
      uid: uid,
      email: email,
      role: role,
      name: name, // Map name to entity
    );
  }
}