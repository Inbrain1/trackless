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

class UserLocationUpdated extends MapEvent {
  final LatLng position;
  const UserLocationUpdated(this.position);

  @override
  List<Object?> get props => [position];
}

class BusLocationsUpdated extends MapEvent {
  final List<BusLocation> busLocations;
  const BusLocationsUpdated(this.busLocations);

  @override
  List<Object?> get props => [busLocations];
}

class StartGpsTracking extends MapEvent {}

class StopGpsTracking extends MapEvent {}

// --- CORRECTION: Event name made public ---
class ActiveBusesUpdated extends MapEvent { // Removed underscore
  final List<BusLocation> activeBuses;
  const ActiveBusesUpdated(this.activeBuses); // Removed underscore

  @override
  List<Object?> get props => [activeBuses];
}