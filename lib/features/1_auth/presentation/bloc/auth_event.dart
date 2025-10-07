import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Evento para cuando se inicia sesión
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested(this.email, this.password);
}

// Evento para cuando se registra un usuario
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String role;

  const SignUpRequested(this.email, this.password, this.role);
}

// Evento para cuando se cierra sesión
class SignOutRequested extends AuthEvent {}

// Evento para monitorear el estado de autenticación
class AuthStateChanged extends AuthEvent {
  final dynamic user;
  const AuthStateChanged(this.user);
}