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
      // --- CORRECCIÓN CLAVE ---
      // La ruta inicial SIEMPRE debe ser '/splash'.
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
        final isLoading = authState.status == AuthStatus.unknown || authState.status == AuthStatus.loading;

        // --- LÓGICA DE REDIRECCIÓN DEFINITIVA ---

        // 1. Mientras la app determina el estado, debe permanecer en la pantalla de carga.
        // Si ya está en /splash, no hace nada (devuelve null). Esto ROMPE EL BUCLE.
        if (isLoading) {
          return currentLocation == '/splash' ? null : '/splash';
        }

        final isLoggedIn = authState.status == AuthStatus.authenticated;
        final user = authState.user;

        final isPublicRoute = currentLocation == '/login' ||
            currentLocation == '/register' ||
            currentLocation == '/welcome';

        // 2. Si el usuario está logueado:
        if (isLoggedIn) {
          // Si por alguna razón los detalles del usuario (rol) aún no están, lo forzamos a esperar en splash.
          if (user == null) {
            return '/splash';
          }

          // Si ya tiene rol y está en una ruta pública (o en splash), lo redirigimos a su pantalla correcta.
          if (isPublicRoute || currentLocation == '/splash') {
            return user.role == 'Conductor' ? '/driver-panel' : '/home';
          }
        }
        // 3. Si el usuario NO está logueado:
        else {
          // Si intenta acceder a una ruta protegida, lo redirigimos a la bienvenida.
          if (!isPublicRoute && currentLocation != '/splash') {
            return '/welcome';
          }
        }

        // 4. Si ninguna condición se cumple, la navegación es válida. No hacemos nada.
        return null;
      },
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
    );
    return _router!;
  }
}