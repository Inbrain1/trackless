import 'package:untitled2/features/4_driver_panel/domain/entities/bus.dart';

// Este es el Data Transfer Object (DTO) para un bus.
class BusModel {
  final String name;

  BusModel({required this.name});

  // Convierte el modelo de datos a la entidad de dominio.
  Bus toEntity() {
    return Bus(name: name);
  }
}