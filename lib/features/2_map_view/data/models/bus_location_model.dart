import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_location.dart';

class BusLocationModel {
  final String driverId;
  final String busName;
  final LatLng position;

  BusLocationModel({
    required this.driverId,
    required this.busName,
    required this.position,
  });

  factory BusLocationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BusLocationModel(
      driverId: doc.id,
      busName: data['busName'] ?? '',
      position: LatLng(data['latitude'] ?? 0.0, data['longitude'] ?? 0.0),
    );
  }

  BusLocation toEntity() {
    return BusLocation(
      driverId: driverId,
      busName: busName,
      position: position,
    );
  }
}