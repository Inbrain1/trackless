import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_location.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_route.dart';

enum MapStatus { initial, loading, loaded, error }

class MapState extends Equatable {
  final MapStatus status;
  final LatLng? userLocation;
  final BusRoute? selectedBusRoute;
  final List<BusLocation> busLocations;
  final String? selectedBusName;
  final String errorMessage;

  const MapState({
    this.status = MapStatus.initial,
    this.userLocation,
    this.selectedBusRoute,
    this.busLocations = const [],
    this.selectedBusName,
    this.errorMessage = '',
  });

  MapState copyWith({
    MapStatus? status,
    LatLng? userLocation,
    BusRoute? selectedBusRoute,
    List<BusLocation>? busLocations,
    String? selectedBusName,
    String? errorMessage,
    bool clearSelectedBus = false, // Flag para limpiar la selección
  }) {
    return MapState(
      status: status ?? this.status,
      userLocation: userLocation ?? this.userLocation,
      selectedBusRoute: clearSelectedBus ? null : selectedBusRoute ?? this.selectedBusRoute,
      busLocations: clearSelectedBus ? [] : busLocations ?? this.busLocations,
      selectedBusName: clearSelectedBus ? null : selectedBusName ?? this.selectedBusName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userLocation,
    selectedBusRoute,
    busLocations,
    selectedBusName,
    errorMessage,
  ];
}