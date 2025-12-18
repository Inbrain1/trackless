import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26, // El fondo azul similar al de Uber
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen o logo de la aplicación
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Image.asset(
                'assets/logo.jpg',
                // Cambia esto por tu imagen o logo de SmartBus
                height: 120,
              ),
            ),
            // Título de la aplicación
            const Text(
              'SmartBus',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Eslogan de la app
            const Text(
              'Travel with safety', // Puedes modificar el texto aquí
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),
            // Botón "Get Started"
            ElevatedButton(
              onPressed: () {
                // Navega a la siguiente pantalla (por ejemplo, pantalla de login)
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Color gris del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Get started',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
