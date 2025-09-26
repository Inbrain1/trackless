import 'package:flutter/material.dart';

class Bus {
  final String id;
  final String routeName;
  final String imageUrl;

  Bus({required this.id, required this.routeName, required this.imageUrl});
}

class BusListScreen extends StatelessWidget {
  BusListScreen({super.key});

  final List<Bus> buses = [
    Bus(
      id: 'R-01',
      routeName: 'Servicio Rápido',
      imageUrl: 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=400&q=80',
    ),
    Bus(
      id: 'R-02',
      routeName: 'Batman',
      imageUrl: 'https://images.unsplash.com/photo-1612916628677-475f676a6adf?q=80&w=1170&auto=format&fit=crop',
    ),
    Bus(
      id: 'R-03',
      routeName: 'León de San Jerónimo',
      imageUrl: 'https://plus.unsplash.com/premium_photo-1664302152991-d013ff125f3f?w=600&q=60&auto=format&fit=crop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rutas de Bus"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: buses.length,
        itemBuilder: (context, index) {
          final bus = buses[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  bus.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.directions_bus, size: 40),
                ),
              ),
              title: Text(
                bus.routeName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}