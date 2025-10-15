import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_bloc.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_event.dart';

// Definición de la entidad Bus actualizada
class Bus {
  final String id;
  final String mainName; // Nombre principal (ej: Andinito A)
  final String routeIdentifier; // Identificador de la ruta (ej: Ruta A1)
  final String imageUrl;
  final bool isAvailable; // Estado de disponibilidad
  final String schedule; // Horario de salida
  final List<LatLng> pathCoordinates; // Nuevo: Coordenadas de la ruta

  Bus({
    required this.id,
    required this.mainName,
    required this.routeIdentifier,
    required this.imageUrl,
    required this.isAvailable,
    required this.schedule,
    required this.pathCoordinates,
  });
}

// --- DATA DE TESTEO DE COORDENADAS (6 Rutas cortas en Cusco) ---
final List<List<LatLng>> _testRoutesCoordinates = [
  // Ruta A1: Wanchaq -> Cultura
  [const LatLng(-13.5284, -71.9509), const LatLng(-13.5250, -71.9608), const LatLng(-13.5228, -71.9667)],
  // Ruta B1: Plaza de Armas -> San Blas
  [const LatLng(-13.5169, -71.9782), const LatLng(-13.5150, -71.9750), const LatLng(-13.5135, -71.9720)],
  // Ruta C1: Túpac Amaru -> Santiago
  [const LatLng(-13.5342, -71.9670), const LatLng(-13.5300, -71.9700), const LatLng(-13.5251, -71.9832)],
  // Ruta D1: Huancaro
  [const LatLng(-13.5401, -71.9812), const LatLng(-13.5380, -71.9831), const LatLng(-13.5364, -71.9800)],
  // Ruta E1: Magisterio
  [const LatLng(-13.5267, -71.9488), const LatLng(-13.5277, -71.9433), const LatLng(-13.5287, -71.9383)],
  // Ruta F1: San Sebastián
  [const LatLng(-13.5315, -71.9283), const LatLng(-13.5322, -71.9257), const LatLng(-13.5330, -71.9226)],
];

// Data de los 6 buses con ID (usado como busName) y horarios
const List<Map<String, dynamic>> _busData = [
  {
    'id': 'Andinito A',
    'mainName': 'Andinito A',
    'routeIdentifier': 'Ruta A1',
    'isAvailable': true,
    'schedule': '6 AM - 7 AM / 3 PM - 4 PM'
  },
  {
    'id': 'Andinito B',
    'mainName': 'Andinito B',
    'routeIdentifier': 'Ruta B1',
    'isAvailable': true,
    'schedule': '12 PM - 1 PM / 8 PM - 9 PM'
  },
  {
    'id': 'Andinito C',
    'mainName': 'Andinito C',
    'routeIdentifier': 'Ruta C1',
    'isAvailable': true,
    'schedule': '7 AM - 8 AM / 4 PM - 5 PM'
  },
  {
    'id': 'Andinito D',
    'mainName': 'Andinito D',
    'routeIdentifier': 'Ruta D1',
    'isAvailable': false,
    'schedule': '11 AM - 12 PM / 6 PM - 7 PM'
  },
  {
    'id': 'Andinito E',
    'mainName': 'Andinito E',
    'routeIdentifier': 'Ruta E1',
    'isAvailable': false,
    'schedule': '9 AM - 10 AM / 5 PM - 6 PM'
  },
  {
    'id': 'Andinito F',
    'mainName': 'Andinito F',
    'routeIdentifier': 'Ruta F1',
    'isAvailable': false,
    'schedule': '10 AM - 11 AM / 7 PM - 8 PM'
  },
];

const String _BUS_IMAGE_PATH = 'assets/image_9a5b1c.png';

class BusListScreen extends StatelessWidget {
  BusListScreen({super.key});

  // Genero la lista final de objetos Bus
  final List<Bus> buses = _busData
      .asMap()
      .entries
      .map((entry) {
    final index = entry.key;
    final data = entry.value;
    return Bus(
      id: data['id'] as String,
      mainName: data['mainName'] as String,
      routeIdentifier: data['routeIdentifier'] as String,
      imageUrl: _BUS_IMAGE_PATH,
      isAvailable: data['isAvailable'] as bool,
      schedule: data['schedule'] as String,
      pathCoordinates: _testRoutesCoordinates[index], // Asignamos la ruta de test
    );
  })
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rutas de Bus"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: buses.length,
        itemBuilder: (context, index) {
          final bus = buses[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: BusRouteCard(bus: bus),
          );
        },
      ),
    );
  }
}

class BusRouteCard extends StatelessWidget {
  final Bus bus;

  const BusRouteCard({super.key, required this.bus});

  Widget _buildBusImage() {
    try {
      return Container(
        width: 100,
        height: 100,
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.directions_bus, color: Colors.white, size: 50),
        ),
      );
    } catch (_) {
      return const SizedBox(
        width: 100,
        height: 100,
        child: Icon(Icons.directions_bus, size: 40, color: Colors.grey),
      );
    }
  }

  void _onBusSelected(BuildContext context) {
    // 1. Despachar el evento BusRouteSelected con el ID/Nombre del bus.
    // MapBloc buscará una ruta con este nombre (ver modificación en MapRemoteDataSource).
    context.read<MapBloc>().add(BusRouteSelected(bus.id));

    // 2. Navegar a la pestaña 'Mapa' (asumiendo que MainScreen es la pestaña raíz)
    // Este paso requiere modificar MainScreen para exponer el control de las pestañas,
    // pero para el testeo, solo notificamos al usuario.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cargando ruta de ${bus.mainName} en el mapa (pestaña Mapa)...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color indicatorColor = bus.isAvailable ? Colors.green : Colors.red;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Llama a la función de selección de bus
          _onBusSelected(context);
        },
        child: Container(
          height: 120,
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Columna 1: Imagen
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: _buildBusImage(),
              ),
              const SizedBox(width: 12),
              // Columna 2: Nombres y Horario
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Indicador de Disponibilidad
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: indicatorColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Línea principal (Andinito A)
                          Flexible(
                            child: Text(
                              bus.mainName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Segunda línea (Ruta A1)
                      Text(
                        bus.routeIdentifier,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Nuevo: Horario de Salida
                      Row(
                        children: [
                          const Icon(Icons.schedule, color: Colors.blueGrey, size: 16),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              bus.schedule,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey,
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
              // Columna 3: Icono de Navegación
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
  }
}