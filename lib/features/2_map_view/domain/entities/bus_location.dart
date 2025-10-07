import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusLocation extends Equatable {
  final String driverId;
  final String busName;
  final LatLng position;

  const BusLocation({
    required this.driverId,
    required this.busName,
    required this.position,
  });

  @override
  List<Object?> get props => [driverId, busName, position];
}