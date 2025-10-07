import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  // Método para cerrar sesión y volver al login
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Navegamos al login y eliminamos todas las rutas anteriores
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Pantalla de Servicios - Aquí se mostrarán servicios más adelante',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
