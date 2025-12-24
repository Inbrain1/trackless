
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Es aceptable usar modelos de paquetes base como LatLng


class BusStop extends Equatable {
  final String name;
  final LatLng position;

  const BusStop({required this.name, required this.position});

  @override
  List<Object?> get props => [name, position];
}

class BusRoute extends Equatable {
  final String name;
  final List<LatLng> routePoints; // La polilínea completa para dibujar
  final List<BusStop> stops;       // Los puntos exactos de las paradas con nombre

  const BusRoute({
    required this.name,
    required this.routePoints,
    required this.stops,
  });

  @override
  List<Object?> get props => [name, routePoints, stops];
}