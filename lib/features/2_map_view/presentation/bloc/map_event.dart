import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_location.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class LoadMap extends MapEvent {}

class BusRouteSelected extends MapEvent {
  final String busName;
  const BusRouteSelected(this.busName);

  @override
  List<Object?> get props => [busName];
}

// --- CORRECCIÓN: Se quitó el guion bajo '_' ---
// Ahora la clase es 'UserLocationUpdated' y es pública.
class UserLocationUpdated extends MapEvent {
  final LatLng position;
  const UserLocationUpdated(this.position);

  @override
  List<Object?> get props => [position];
}

// --- CORRECCIÓN: Se quitó el guion bajo '_' ---
// Ahora la clase es 'BusLocationsUpdated' y es pública.
class BusLocationsUpdated extends MapEvent {
  final List<BusLocation> busLocations;
  const BusLocationsUpdated(this.busLocations);

  @override
  List<Object?> get props => [busLocations];
}