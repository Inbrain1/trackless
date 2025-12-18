import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_location.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_route.dart';

enum MapStatus { initial, loading, loaded, error }

class MapState extends Equatable {
  final MapStatus status;
  final LatLng? userLocation;
  final BusRoute? selectedBusRoute;
  final List<BusLocation> busLocations; // Ubicaciones del bus SELECCIONADO
  final String? selectedBusName;
  final String errorMessage;
  final bool isTracking; // Para el conductor: ¿Está transmitiendo?
  final List<BusLocation>
      activeBuses; // Para el usuario: Lista de TODOS los buses activos
  final LatLng? focusedLocation; // For active navigation

  const MapState({
    this.status = MapStatus.initial,
    this.userLocation,
    this.selectedBusRoute,
    this.busLocations = const [],
    this.selectedBusName,
    this.errorMessage = '',
    this.isTracking = false,
    this.activeBuses = const [], // <-- VALOR INICIAL
    this.focusedLocation,
  });

  MapState copyWith({
    MapStatus? status,
    LatLng? userLocation,
    BusRoute? selectedBusRoute,
    List<BusLocation>? busLocations,
    String? selectedBusName,
    String? errorMessage,
    bool? isTracking,
    List<BusLocation>? activeBuses, // <-- NUEVO
    LatLng? focusedLocation,
    bool clearSelectedBus = false,
  }) {
    return MapState(
      status: status ?? this.status,
      userLocation: userLocation ?? this.userLocation,
      selectedBusRoute:
          clearSelectedBus ? null : selectedBusRoute ?? this.selectedBusRoute,
      busLocations: clearSelectedBus ? [] : busLocations ?? this.busLocations,
      selectedBusName:
          clearSelectedBus ? null : selectedBusName ?? this.selectedBusName,
      errorMessage: errorMessage ?? this.errorMessage,
      isTracking: isTracking ?? this.isTracking,
      activeBuses: activeBuses ?? this.activeBuses, // <-- NUEVO
      focusedLocation: focusedLocation ?? this.focusedLocation,
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
        isTracking,
        activeBuses, // <-- NUEVO
        focusedLocation,
      ];
}
