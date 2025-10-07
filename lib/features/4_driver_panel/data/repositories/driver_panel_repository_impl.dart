import 'package:untitled2/features/4_driver_panel/data/datasources/driver_panel_datasource.dart';
import 'package:untitled2/features/4_driver_panel/domain/entities/bus.dart';
import 'package:untitled2/features/4_driver_panel/domain/repositories/driver_panel_repository.dart';

class DriverPanelRepositoryImpl implements DriverPanelRepository {
  final DriverPanelDataSource dataSource;

  DriverPanelRepositoryImpl({required this.dataSource});

  @override
  Future<List<Bus>> getBusList() async {
    final busModels = await dataSource.getBusList();
    // Convertimos la lista de Modelos a una lista de Entidades.
    return busModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> selectBus(String busName) async {
    await dataSource.selectBus(busName);
  }
}