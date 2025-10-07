import 'package:flutter/material.dart';

// VERSIÓN CORREGIDA Y SIMPLIFICADA
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Esta pantalla ahora es 100% pasiva.
    // No contiene lógica de navegación.
    // Su única responsabilidad es mostrar un indicador de carga.
    // GoRouter es el único que decide cuándo salir de aquí.
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}