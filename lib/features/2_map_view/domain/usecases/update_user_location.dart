import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/core/usecases/usecase.dart';
import 'package:untitled2/features/2_map_view/domain/repositories/map_repository.dart';

class UpdateUserLocationUseCase implements UseCase<void, LatLng> {
  final MapRepository repository;

  UpdateUserLocationUseCase(this.repository);

  @override
  Future<void> call(LatLng position) async {
    return repository.updateUserLocation(position);
  }
}