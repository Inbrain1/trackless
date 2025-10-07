import 'package:equatable/equatable.dart';
import 'package:untitled2/features/4_driver_panel/domain/entities/bus.dart';

enum BusSelectionStatus { initial, loading, loaded, error, success }

class BusSelectionState extends Equatable {
  final BusSelectionStatus status;
  final List<Bus> buses;
  final String errorMessage;

  const BusSelectionState({
    this.status = BusSelectionStatus.initial,
    this.buses = const [],
    this.errorMessage = '',
  });

  BusSelectionState copyWith({
    BusSelectionStatus? status,
    List<Bus>? buses,
    String? errorMessage,
  }) {
    return BusSelectionState(
      status: status ?? this.status,
      buses: buses ?? this.buses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, buses, errorMessage];
}