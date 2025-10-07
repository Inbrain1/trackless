import 'package:untitled2/core/usecases/usecase.dart';
import 'package:untitled2/features/4_driver_panel/domain/entities/bus.dart';
import 'package:untitled2/features/4_driver_panel/domain/repositories/driver_panel_repository.dart';

// No necesita parámetros, por eso usamos `void`.
class GetBusListUseCase implements UseCase<List<Bus>, void> {
  final DriverPanelRepository repository;

  GetBusListUseCase(this.repository);

  @override
  Future<List<Bus>> call(void params) async {
    return await repository.getBusList();
  }
}