import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_bloc.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_state.dart';
import 'package:untitled2/features/1_auth/presentation/screens/login_screen.dart';
import 'package:untitled2/features/1_auth/presentation/screens/register_screen.dart';
import 'package:untitled2/features/1_auth/presentation/screens/splash_screen.dart';
import 'package:untitled2/features/1_auth/presentation/screens/welcome_screen.dart';
import 'package:untitled2/features/3_shell_navigation/presentation/screens/main_shell_screen.dart';
import 'package:untitled2/features/4_driver_panel/presentation/screens/bus_selection_screen.dart';
import 'package:untitled2/features/2_map_view/presentation/screens/driver_map_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  final AuthBloc authBloc;
  GoRouter? _router;

  AppRouter({required this.authBloc});

  GoRouter get router {
    _router ??= GoRouter(
      initialLocation: '/welcome',
      routes: <GoRoute>[
        GoRoute(
            path: '/splash',
            name: 'splash',
            builder: (context, state) => const SplashScreen()),
        GoRoute(
            path: '/welcome',
            name: 'welcome',
            builder: (context, state) => WelcomeScreen()),
        GoRoute(
            path: '/login',
            name: 'login',
            builder: (context, state) => LoginScreen()),
        GoRoute(
            path: '/register',
            name: 'register',
            builder: (context, state) => RegisterScreen()),
        GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const MainScreen()),
        GoRoute(
            path: '/driver-panel',
            name: 'driver-panel',
            builder: (context, state) => const DriverScreen()),
        GoRoute(
            path: '/driver-map',
            name: 'driver-map',
            builder: (context, state) => const DriverMapScreen()),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final authState = authBloc.state;
        final currentLocation = state.matchedLocation;

        final isPublicRoute = currentLocation == '/login' ||
            currentLocation == '/register' ||
            currentLocation == '/welcome';

        // --- 1. Estado de Carga Inicial (Unknown) ---
        // Si el estado es 'unknown', SIEMPRE mostrar splash.
        if (authState.status == AuthStatus.unknown) {
          return currentLocation == '/splash' ? null : '/splash';
        }

        // --- 2. Estado de Carga (Loading) ---
        // Si está en 'loading', SÓLO redirigir a splash si NO estamos ya en
        // una página de login/registro (que manejan su propio 'loading').
        if (authState.status == AuthStatus.loading) {
          if (!isPublicRoute) {
            return currentLocation == '/splash' ? null : '/splash';
          }
          // Si está en login/register, no hacemos nada (null) para
          // permitir que la pantalla local maneje el estado de carga.
          return null;
        }

        // --- 3. Estado Autenticado ---
        final isLoggedIn = authState.status == AuthStatus.authenticated;
        final user = authState.user;

        if (isLoggedIn) {
          if (user == null) {
            // Aún cargando detalles del usuario, forzamos espera
            return '/splash';
          }
          // Si está logueado y en una ruta pública (o en splash), lo mandamos a su home
          if (isPublicRoute || currentLocation == '/splash') {
            return user.role == 'Conductor' ? '/driver-panel' : '/home';
          }
          // Está logueado y en una ruta protegida, se queda
          return null;
        }

        // --- 4. Estado No Autenticado ---
        if (!isLoggedIn) {
          // Si NO está logueado y está en una ruta pública, se queda
          if (isPublicRoute) {
            return null;
          }
          // Si NO está logueado y está en SPLASH (carga inicial fallida)
          if (currentLocation == '/splash') {
            return '/welcome';
          }
          // Si NO está logueado y en CUALQUIER OTRA ruta protegida
          return '/welcome';
        }

        return null;
      },
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
    );
    return _router!;
  }
}