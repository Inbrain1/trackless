import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:untitled2/core/di/service_locator.dart'; // Para obtener Firestore
import 'package:untitled2/features/2_map_view/presentation/bloc/map_bloc.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_event.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_state.dart';

// Definición de la entidad Bus actualizada para incluir rutaCorta
class Bus {
  final String id;
  final String mainName;
  final String routeIdentifier;
  final String schedule;
  final String rutaCorta; // Añadido

  Bus({
    required this.id,
    required this.mainName,
    required this.routeIdentifier,
    required this.schedule,
    required this.rutaCorta,
  });

  // Factory para crear un Bus desde un DocumentSnapshot de Firestore
  factory Bus.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Bus(
      id: doc.id, // Usamos el ID del documento como ID del bus (ej: "Andinito A")
      mainName: data['mainName'] ?? 'N/A',
      routeIdentifier: data['routeIdentifier'] ?? 'N/A',
      schedule: data['schedule'] ?? 'N/A',
      rutaCorta: data['rutaCorta'] ?? 'Ruta corta no disponible', // Valor por defecto
    );
  }
}

// const String _BUS_IMAGE_PATH = 'assets/image_9a5b1c.png'; // Comentado si no tienes la imagen

class BusListScreen extends StatelessWidget {
  const BusListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos la instancia de Firestore desde GetIt
    final FirebaseFirestore firestore = sl<FirebaseFirestore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rutas de Bus"),
      ),
      // Usamos StreamBuilder para obtener los buses de Firestore en tiempo real
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('buses').orderBy('mainName').snapshots(),
        builder: (context, snapshot) {
          // Estados de carga y error
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar buses: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay buses disponibles en la base de datos.'));
          }

          // Convertimos los documentos de Firestore a objetos Bus
          final buses = snapshot.data!.docs.map((doc) => Bus.fromFirestore(doc)).toList();

          // Construimos la lista
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: buses.length,
            itemBuilder: (context, index) {
              final bus = buses[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                // Pasamos el objeto Bus a la tarjeta
                child: BusRouteCard(bus: bus),
              );
            },
          );
        },
      ),
    );
  }
}

class BusRouteCard extends StatelessWidget {
  final Bus bus;

  const BusRouteCard({super.key, required this.bus});

  // Widget para mostrar la imagen o un icono placeholder
  Widget _buildBusImage() {
    // Si tienes la imagen en assets, descomenta esto:
    // try {
    //   return Image.asset(
    //     _BUS_IMAGE_PATH,
    //     width: 100,
    //     height: 100,
    //     fit: BoxFit.cover,
    //     errorBuilder: (context, error, stackTrace) => _buildPlaceholderIcon(),
    //   );
    // } catch (_) {
    //   return _buildPlaceholderIcon();
    // }
    // Si no, usamos un icono:
    return _buildPlaceholderIcon();
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade300, // Un color de fondo suave
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
      child: const Center(
        child: Icon(Icons.directions_bus, color: Colors.black54, size: 50),
      ),
    );
  }

  // --- LÓGICA DE SELECCIÓN SIMPLIFICADA ---
  void _onBusSelected(BuildContext context, bool isBusActive) {
    if (isBusActive) {
      // 1. Despachamos el evento para cargar los datos del bus en el MapBloc
      context.read<MapBloc>().add(BusRouteSelected(bus.id));

      // 2. Mostramos el SnackBar indicando al usuario que cambie de pestaña
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Oculta SnackBar anterior si existe
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mostrando ${bus.mainName}. Ve a la pestaña Mapa.'),
          duration: const Duration(seconds: 3), // Duración un poco más larga
        ),
      );

    } else {
      // Si el bus está INACTIVO, mostramos el AlertDialog con la ruta corta (sin cambios)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(bus.mainName),
          content: Text("Ruta resumida (no activo):\n${bus.rutaCorta}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    // Consumimos el MapBloc para saber si este bus está activo
    return BlocBuilder<MapBloc, MapState>(
      // buildWhen: (previous, current) => previous.activeBuses != current.activeBuses, // Optimización opcional
      builder: (context, mapState) {
        // Buscamos si el ID de este bus existe en la lista de buses activos
        final bool isBusActive = mapState.activeBuses.any((activeBus) => activeBus.busName == bus.id);
        final Color indicatorColor = isBusActive ? Colors.green : Colors.red;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              _onBusSelected(context, isBusActive);
            },
            child: Container(
              height: 120, // Altura fija para la tarjeta
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Estirar elementos verticalmente
                children: [
                  // --- Columna 1: Imagen ---
                  ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      child: _buildBusImage()
                  ),
                  const SizedBox(width: 12),

                  // --- Columna 2: Información del Bus ---
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Indicador de Actividad
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: indicatorColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1.5),
                                  boxShadow: [ // Sombra sutil para el indicador
                                    BoxShadow(
                                      color: indicatorColor.withOpacity(0.5),
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Nombre principal
                              Flexible( // Para evitar overflow si el nombre es largo
                                child: Text(
                                  bus.mainName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis, // Cortar si es muy largo
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Identificador de ruta
                          Text(
                            bus.routeIdentifier,
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(), // Empuja el horario hacia abajo
                          // Horario
                          Row(
                            children: [
                              Icon(Icons.schedule, color: Colors.blueGrey.shade400, size: 16),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  bus.schedule,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500, // Un poco menos grueso
                                    color: Colors.blueGrey.shade700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Columna 3: Icono de Flecha ---
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}