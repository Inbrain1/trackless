import 'dart:async';
import 'package:flutter/material.dart'; // NUEVO: Para Color
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // NUEVO: Para Polyline, PolylineId, LatLng

import 'package:untitled2/features/2_map_view/domain/repositories/map_repository.dart';
import 'package:untitled2/features/2_map_view/domain/usecases/get_bus_route_details.dart';
import 'package:untitled2/features/2_map_view/domain/usecases/update_user_location.dart';
import 'package:untitled2/features/2_map_view/domain/usecases/watch_bus_locations.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetBusRouteDetailsUseCase _getBusRouteDetails;
  final WatchBusLocationsUseCase _watchBusLocations;
  final UpdateUserLocationUseCase _updateUserLocation;
  final MapRepository _mapRepository;

  StreamSubscription? _userLocationSubscription;
  StreamSubscription? _busLocationsSubscription;
  StreamSubscription? _activeBusesSubscription;

  MapBloc({
    required GetBusRouteDetailsUseCase getBusRouteDetails,
    required WatchBusLocationsUseCase watchBusLocations,
    required UpdateUserLocationUseCase updateUserLocation,
    required MapRepository mapRepository,
  })  : _getBusRouteDetails = getBusRouteDetails,
        _watchBusLocations = watchBusLocations,
        _updateUserLocation = updateUserLocation,
        _mapRepository = mapRepository,
        super(const MapState()) {
    on<LoadMap>(_onLoadMap);
    on<BusRouteSelected>(_onBusRouteSelected);
    on<UserLocationUpdated>(_onUserLocationUpdated);
    on<BusLocationsUpdated>(_onBusLocationsUpdated);
    on<StartGpsTracking>(_onStartGpsTracking);
    on<StopGpsTracking>(_onStopGpsTracking);
    // --- CORRECTION: Use public event name ---
    on<ActiveBusesUpdated>(_onActiveBusesUpdated); // Removed underscore
    on<FocusOnLocation>((event, emit) {
      // TODO: Implement focus logic if needed, currently preventing crash
    });

    _listenToActiveBuses();
  }

  void _listenToActiveBuses() {
    _activeBusesSubscription?.cancel();
    _activeBusesSubscription =
        _mapRepository.watchAllActiveBuses().listen((activeList) {
      // --- CORRECTION: Use public event name ---
      add(ActiveBusesUpdated(activeList)); // Removed underscore
    }, onError: (e) {
      print("Error escuchando buses activos: $e");
    });
  }

  // --- CORRECTION: Use public event name in signature ---
  void _onActiveBusesUpdated(ActiveBusesUpdated event, Emitter<MapState> emit) {
    // Removed underscore
    emit(state.copyWith(activeBuses: event.activeBuses));
  }

  void _onLoadMap(LoadMap event, Emitter<MapState> emit) {
    _userLocationSubscription?.cancel();
    _userLocationSubscription =
        _mapRepository.watchUserLocation().listen((position) {
      add(UserLocationUpdated(position));
    }, onError: (e) {
      emit(state.copyWith(
          status: MapStatus.error,
          errorMessage: "No se pudo obtener la ubicación inicial: $e"));
    });
    _listenToActiveBuses();
    emit(state.copyWith(status: MapStatus.loaded));
  }

  void _onStartGpsTracking(StartGpsTracking event, Emitter<MapState> emit) {
    if (state.isTracking) return;

    emit(state.copyWith(isTracking: true, status: MapStatus.loading));
    _userLocationSubscription?.cancel();
    _userLocationSubscription =
        _mapRepository.watchUserLocation().listen((position) {
      add(UserLocationUpdated(position));
      _updateUserLocation(position);
    }, onError: (e) {
      emit(state.copyWith(
          status: MapStatus.error,
          errorMessage: "Error durante el seguimiento: $e",
          isTracking: false));
      _userLocationSubscription?.cancel();
    }, onDone: () {
      emit(state.copyWith(isTracking: false));
    });
    emit(state.copyWith(status: MapStatus.loaded));
  }

  Future<void> _onStopGpsTracking(
      StopGpsTracking event, Emitter<MapState> emit) async {
    if (!state.isTracking) return;

    await _userLocationSubscription?.cancel();
    try {
      await _mapRepository.stopSharingLocation();
      emit(state.copyWith(isTracking: false));
    } catch (e) {
      emit(state.copyWith(
          status: MapStatus.error,
          errorMessage: "Error al detener seguimiento: $e"));
    }
  }

  Future<void> _onBusRouteSelected(
      BusRouteSelected event, Emitter<MapState> emit) async {
    if (state.selectedBusName == event.busName) {
      _busLocationsSubscription?.cancel();
      emit(state.copyWith(clearSelectedBus: true, status: MapStatus.loaded));
      return;
    }

    emit(state.copyWith(
        status: MapStatus.loading, selectedBusName: event.busName));
    try {
      final busRoute = await _getBusRouteDetails(event.busName);
      
      // NUEVO: Crear polyline con las paradas de la ruta
      final Set<Polyline> routePolylines = {};
      if (busRoute.stops.isNotEmpty) {
        final List<LatLng> routePoints = busRoute.stops
            .map((stop) => stop.position) // FIX: BusStop tiene 'position' (LatLng), no latitude/longitude
            .toList();
        
        final Polyline routeLine = Polyline(
          polylineId: const PolylineId('route_line'),
          points: routePoints,
          color: const Color(0xFF007BFF), // Azul
          width: 5,
        );
        
        routePolylines.add(routeLine);
      }
      // FIN NUEVO
      
      emit(state.copyWith(
        selectedBusRoute: busRoute,
        polylines: routePolylines, // NUEVO: Emitir polylines
      ));

      _busLocationsSubscription?.cancel();
      _busLocationsSubscription =
          _watchBusLocations(event.busName).listen((locations) {
        add(BusLocationsUpdated(locations));
      }, onError: (e) {
        emit(state.copyWith(
            status: MapStatus.error,
            errorMessage: "Error escuchando ubicación del bus: $e"));
      });

      emit(state.copyWith(status: MapStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
          status: MapStatus.error,
          errorMessage: "Error al obtener detalles de la ruta: $e",
          clearSelectedBus: true));
    }
  }

  void _onUserLocationUpdated(
      UserLocationUpdated event, Emitter<MapState> emit) {
    emit(state.copyWith(userLocation: event.position));
  }

  void _onBusLocationsUpdated(
      BusLocationsUpdated event, Emitter<MapState> emit) {
    emit(state.copyWith(busLocations: event.busLocations));
  }

  @override
  Future<void> close() {
    _userLocationSubscription?.cancel();
    _busLocationsSubscription?.cancel();
    _activeBusesSubscription?.cancel();
    return super.close();
  }
}
