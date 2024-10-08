// lib/data/bus_routes.dart

import 'bus_model.dart';

final List<Bus> buses = [
  Bus(
    name: 'Patron de San Jerónimo',
    route: [
      [13.52323, -71.9821], // Coordenadas de los paraderos
      [13.52234, -71.9832],
      [13.52145, -71.9843],
      // Añadir más coordenadas para este bus
    ],
  ),
  Bus(
    name: 'Satélite',
    route: [
      [13.53345, -71.9934],
      [13.53256, -71.9945],
      [13.53167, -71.9956],
      // Añadir más coordenadas para este bus
    ],
  ),
  // Agregar más buses aquí
];
