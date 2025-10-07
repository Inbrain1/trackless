import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_route.dart';

class BusRouteModel {
  final String name;
  final List<LatLng> routePoints;
  final List<LatLng> stops;

  BusRouteModel({
    required this.name,
    required this.routePoints,
    required this.stops,
  });

  factory BusRouteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BusRouteModel(
      name: data['name'] ?? '',
      routePoints: (data['route'] as List<dynamic>)
          .map((point) => LatLng(point['lat'], point['lng']))
          .toList(),
      stops: (data['stops'] as List<dynamic>)
          .map((point) => LatLng(point['lat'], point['lng']))
          .toList(),
    );
  }

  BusRoute toEntity() {
    return BusRoute(
      name: name,
      routePoints: routePoints,
      stops: stops,
    );
  }
}