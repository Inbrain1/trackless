import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:untitled2/core/di/service_locator.dart'; // Para obtener Firestore
import 'package:untitled2/features/2_map_view/presentation/bloc/map_bloc.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_event.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_state.dart';
import 'package:untitled2/core/helpers/bus_assets_helper.dart';


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


class BusListScreen extends StatefulWidget {
  final VoidCallback? onSwitchToMap;
  const BusListScreen({super.key, this.onSwitchToMap});

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos la instancia de Firestore desde GetIt
    final FirebaseFirestore firestore = sl<FirebaseFirestore>();

    return Scaffold(
      backgroundColor: Colors.black, // Dark background for contrast like the image
      appBar: AppBar(
        title: const Text("Rutas de Bus", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar ruta...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
          
          // Lista Filtrada
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('buses').orderBy('mainName').snapshots(),
              builder: (context, snapshot) {
                // Estados de carga y error
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar buses: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No hay buses disponibles.', style: TextStyle(color: Colors.white)));
                }

                // Filtrar localmente (más rápido para listas pequeñas)
                final buses = snapshot.data!.docs
                    .map((doc) => Bus.fromFirestore(doc))
                    .where((bus) => bus.mainName.toLowerCase().contains(_searchQuery))
                    .toList();

                if (buses.isEmpty) {
                  return const Center(child: Text('No se encontraron rutas con ese nombre.', style: TextStyle(color: Colors.white54)));
                }

                // Construimos la GRILLA (GridView)
                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Dos columnas
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85, // Un poco más alto que ancho para acomodar la info
                  ),
                  itemCount: buses.length,
                  itemBuilder: (context, index) {
                    final bus = buses[index];
                    // Usamos un Key único para ayudar al framework a diferenciar items al filtrar
                    return BusGridCard(
                      key: ValueKey(bus.id),
                      bus: bus,
                      index: index,
                      onTap: widget.onSwitchToMap, // Pasamos el callback
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}

class BusGridCard extends StatelessWidget {
  final Bus bus;
  final int index;
  final VoidCallback? onTap;

  const BusGridCard({
    super.key,
    required this.bus,
    required this.index,
    this.onTap,
  });

  // --- LÓGICA DE SELECCIÓN ---
  void _onBusSelected(BuildContext context) {
    // 1. Siempre seleccionamos la ruta en el mapa (activo o no)
    context.read<MapBloc>().add(BusRouteSelected(bus.id));

    // 2. Ejecutamos el callback para cambiar de pestaña (ir al mapa)
    if (onTap != null) {
      onTap!();
    } else {
      // Fallback por si no hay callback (no debería pasar si se configura bien)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ruta ${bus.mainName} seleccionada')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, mapState) {
        // Contamos cuántos buses activos coinciden con este ID de ruta
        final int activeCount = mapState.activeBuses.where((activeBus) => activeBus.busName == bus.id).length;
        // Ya no usamos isBusActive para bloquear la acción, solo para el indicador visual

        return GestureDetector(
          onTap: () => _onBusSelected(context),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900], // Fondo oscuro por si la imagen tiene transparencia
              borderRadius: BorderRadius.circular(20), // Bordes redondeados
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 1. Imagen de fondo (Asset local)
                  Image.asset(
                    BusAssetHelper.getBusImagePath(bus.mainName),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade900,
                        child: const Center(child: Icon(Icons.directions_bus, size: 40, color: Colors.white54)),
                      );
                    },
                  ),

                  // 1.5. Overlay oscuro general para uniformidad
                  Container(color: Colors.black.withOpacity(0.25)),

                  // 2. Degradado oscuro abajo para el texto
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 100, // Aumentado ligeramente para acomodar el contador
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.9),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3. Texto (Nombre del Bus + Contador)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          bus.mainName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.1,
                            shadows: [
                              Shadow(blurRadius: 4, color: Colors.black, offset: Offset(0, 2)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        
                        // Contador de activos (Sutil)
                        if (activeCount > 0)
                           Container(
                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                             decoration: BoxDecoration(
                               color: Colors.black45,
                               borderRadius: BorderRadius.circular(10),
                               border: Border.all(color: Colors.white12),
                             ),
                             child: Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 const Icon(Icons.circle, size: 8, color: Colors.greenAccent),
                                 const SizedBox(width: 6),
                                 Text(
                                   '$activeCount activos',
                                   style: const TextStyle(
                                     fontSize: 11,
                                     color: Colors.white70,
                                     fontWeight: FontWeight.w500,
                                   ),
                                 ),
                               ],
                             ),
                           )
                        else
                          Text(
                            'Sin servicio',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withOpacity(0.4),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
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