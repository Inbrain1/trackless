// lib/data/bus_model.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Bus {
  final String name;
  final List<LatLng> route;
  final String code;

  Bus({
    required this.name,
    required this.code,
    required this.route,
  });
}