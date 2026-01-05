import 'package:equatable/equatable.dart';

// Equatable nos ayuda a comparar objetos de forma sencilla.
class User extends Equatable {
  final String uid;
  final String email;
  final String role;
  final String name; // Added name field

  const User({
    required this.uid,
    required this.email,
    required this.role,
    this.name = 'Usuario', // Default name
  });

  @override
  List<Object?> get props => [uid, email, role, name];
}