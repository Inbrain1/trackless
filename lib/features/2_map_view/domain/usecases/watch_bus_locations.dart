import 'package:untitled2/features/2_map_view/domain/entities/bus_location.dart';
import 'package:untitled2/features/2_map_view/domain/repositories/map_repository.dart';

// Este caso de uso devuelve un Stream, por lo que no usa la clase base UseCase.
class WatchBusLocationsUseCase {
  final MapRepository repository;

  WatchBusLocationsUseCase(this.repository);

  Stream<List<BusLocation>> call(String busName) {
    return repository.watchBusLocations(busName);
  }
}