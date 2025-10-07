import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_location.dart';
import 'package:untitled2/features/2_map_view/domain/repositories/map_repository.dart';
import 'package:untitled2/features/2_map_view/domain/usecases/get_bus_route_details.dart';
import 'package:untitled2/features/2_map_view/domain/usecases/watch_bus_locations.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetBusRouteDetailsUseCase _getBusRouteDetails;
  final WatchBusLocationsUseCase _watchBusLocations;
  final MapRepository _mapRepository;

  StreamSubscription? _userLocationSubscription;
  StreamSubscription? _busLocationsSubscription;

  MapBloc({
    required GetBusRouteDetailsUseCase getBusRouteDetails,
    required WatchBusLocationsUseCase watchBusLocations,
    required MapRepository mapRepository,
  })  : _getBusRouteDetails = getBusRouteDetails,
        _watchBusLocations = watchBusLocations,
        _mapRepository = mapRepository,
        super(const MapState()) {
    on<LoadMap>(_onLoadMap);
    on<BusRouteSelected>(_onBusRouteSelected);
    // --- CORRECCIÓN: Usamos los nombres públicos ---
    on<UserLocationUpdated>(_onUserLocationUpdated);
    on<BusLocationsUpdated>(_onBusLocationsUpdated);
  }

  void _onLoadMap(LoadMap event, Emitter<MapState> emit) {
    emit(state.copyWith(status: MapStatus.loading));
    _userLocationSubscription?.cancel();
    _userLocationSubscription = _mapRepository.watchUserLocation().listen((position) {
      // --- CORRECCIÓN: Usamos el nombre público ---
      add(UserLocationUpdated(position));
    });
  }

  Future<void> _onBusRouteSelected(BusRouteSelected event, Emitter<MapState> emit) async {
    if (state.selectedBusName == event.busName) {
      _busLocationsSubscription?.cancel();
      emit(state.copyWith(clearSelectedBus: true, status: MapStatus.loaded));
      return;
    }

    emit(state.copyWith(status: MapStatus.loading, selectedBusName: event.busName));
    try {
      final busRoute = await _getBusRouteDetails(event.busName);
      emit(state.copyWith(status: MapStatus.loaded, selectedBusRoute: busRoute));

      _busLocationsSubscription?.cancel();
      _busLocationsSubscription = _watchBusLocations(event.busName).listen((locations) {
        // --- CORRECCIÓN: Usamos el nombre público ---
        add(BusLocationsUpdated(locations));
      });
    } catch (e) {
      emit(state.copyWith(status: MapStatus.error, errorMessage: e.toString()));
    }
  }

  // --- CORRECCIÓN: Usamos el nombre público ---
  void _onUserLocationUpdated(UserLocationUpdated event, Emitter<MapState> emit) {
    emit(state.copyWith(status: MapStatus.loaded, userLocation: event.position));
  }

  // --- CORRECCIÓN: Usamos el nombre público ---
  void _onBusLocationsUpdated(BusLocationsUpdated event, Emitter<MapState> emit) {
    emit(state.copyWith(busLocations: event.busLocations));
  }

  @override
  Future<void> close() {
    _userLocationSubscription?.cancel();
    _busLocationsSubscription?.cancel();
    return super.close();
  }
}