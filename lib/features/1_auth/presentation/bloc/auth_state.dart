import 'package:equatable/equatable.dart';
import 'package:untitled2/features/1_auth/domain/entities/user.dart'; // Importa nuestra entidad User

enum AuthStatus { unknown, authenticated, unauthenticated, loading }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user; // <-- CAMBIO: Ahora usamos nuestra entidad User, que tiene 'role'.
  final String message;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.message = '',
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user, // <-- CAMBIO
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, user, message];
}