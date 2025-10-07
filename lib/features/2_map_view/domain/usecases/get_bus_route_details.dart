import 'package:untitled2/core/usecases/usecase.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_route.dart';
import 'package:untitled2/features/2_map_view/domain/repositories/map_repository.dart';

class GetBusRouteDetailsUseCase implements UseCase<BusRoute, String> {
  final MapRepository repository;

  GetBusRouteDetailsUseCase(this.repository);

  @override
  Future<BusRoute> call(String busName) async {
    return repository.getBusRouteDetails(busName);
  }
}