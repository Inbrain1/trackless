import 'package:equatable/equatable.dart';

abstract class BusSelectionEvent extends Equatable {
  const BusSelectionEvent();

  @override
  List<Object> get props => [];
}

// Evento para solicitar la carga de la lista de buses
class LoadBusList extends BusSelectionEvent {}

// Evento que se dispara cuando el conductor selecciona un bus
class BusSelected extends BusSelectionEvent {
  final String busName;

  const BusSelected(this.busName);

  @override
  List<Object> get props => [busName];
}