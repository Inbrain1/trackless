import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido a HeyBus 👋',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Aquí encontrarás accesos rápidos y novedades.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.map),
                      title: const Text('Ver mapa'),
                      subtitle: const Text('Accede al mapa de buses'),
                      onTap: () {
                        // Navegar a la pestaña de Mapa
                        // Usamos BottomNavigationBar en MainScreen
                        // Aquí podríamos implementar comunicación con MainScreen
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.directions_bus),
                      title: const Text('Buscar buses'),
                      subtitle: const Text('Lista de buses disponibles'),
                      onTap: () {
                        // Similar al anterior → podríamos saltar a la pestaña de buses
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.storefront),
                      title: const Text('Servicios'),
                      subtitle: const Text('Explora servicios adicionales'),
                      onTap: () {
                        // Ir a servicios
                      },
                    ),
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