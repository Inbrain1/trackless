class UserModel {
  final String uid;
  final String email;
  final String role;

  UserModel({required this.uid, required this.email, required this.role});

  // Crear un UserModel a partir de un documento de Firestore
  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      role: data['role'] ?? 'Usuario',
    );
  }

  // Convertir un UserModel a un formato de Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'role': role,
    };
  }
}
