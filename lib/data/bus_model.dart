// lib/data/bus_model.dart

class Bus {
  final String name;
  final List<List<double>> route; // Lista de coordenadas [lat, lng]

  Bus({
    required this.name,
    required this.route,
  });
}
