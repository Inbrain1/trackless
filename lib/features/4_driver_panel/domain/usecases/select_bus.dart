import 'package:untitled2/core/usecases/usecase.dart';
import 'package:untitled2/features/4_driver_panel/domain/repositories/driver_panel_repository.dart';

class SelectBusUseCase implements UseCase<void, String> {
  final DriverPanelRepository repository;

  SelectBusUseCase(this.repository);

  // El parámetro es el nombre del bus (un String).
  @override
  Future<void> call(String busName) async {
    return await repository.selectBus(busName);
  }
}