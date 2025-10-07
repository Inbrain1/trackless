import 'package:equatable/equatable.dart';

// Equatable nos ayuda a comparar objetos de forma sencilla.
class User extends Equatable {
  final String uid;
  final String email;
  final String role;

  const User({
    required this.uid,
    required this.email,
    required this.role,
  });

  @override
  List<Object?> get props => [uid, email, role];
}