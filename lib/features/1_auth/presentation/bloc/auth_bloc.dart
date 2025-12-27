import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled2/features/1_auth/domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<firebase.User?>? _authStateSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState()) {
    on<AuthStateChanged>(_onAuthStateChanged);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);

    _authStateSubscription =
        _authRepository.authStateChanges.listen((firebaseUser) {
      add(AuthStateChanged(firebaseUser));
    });
  }

  // --- LÓGICA MEJORADA ---
  Future<void> _onAuthStateChanged(
      AuthStateChanged event, Emitter<AuthState> emit) async {
    final firebaseUser = event.user;
    if (firebaseUser != null) {
      // Si hay un usuario de Firebase, vamos a Firestore a buscar sus detalles (incluido el rol).
      final userDetails =
          await _authRepository.getUserDetails(firebaseUser.uid);
      if (userDetails != null) {
        // Si encontramos los detalles, emitimos un estado autenticado CON el usuario completo.
        emit(state.copyWith(
            status: AuthStatus.authenticated, user: userDetails));
      } else {
        // Si no se encuentran detalles (caso raro), lo marcamos como no autenticado.
        emit(state.copyWith(
            status: AuthStatus.unauthenticated,
            user: null,
            message: 'No se encontraron detalles del usuario.'));
      }
    } else {
      // Si no hay usuario de Firebase, el estado es no autenticado.
      emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
    }
  }

  Future<void> _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await _authRepository.signIn(
          email: event.email, password: event.password);
      if (user == null) {
        // If user is null, it might be because signIn returned null (detail check failed)
        // or creds were wrong. But the repository usually throws on wrong creds.
        emit(state.copyWith(
            status: AuthStatus.unauthenticated,
            message: 'Fallo al ingresar. Verifique sus datos o conexión.'));
      }
    } catch (e) {
      print('DEBUG AuthBloc: Error in _onSignInRequested: $e');
      emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          message: 'Error: ${e.toString()}'));
    }
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepository.register(
        email: event.email,
        password: event.password,
        role: event.role,
      );
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.unauthenticated, message: e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
