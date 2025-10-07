import 'package:untitled2/features/4_driver_panel/domain/entities/bus.dart';

abstract class DriverPanelRepository {
  // Obtiene la lista de todos los buses disponibles.
  Future<List<Bus>> getBusList();

  // Asigna un bus al conductor actual y actualiza su estado.
  Future<void> selectBus(String busName);
}