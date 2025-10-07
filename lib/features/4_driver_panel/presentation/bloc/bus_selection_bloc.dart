import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled2/features/4_driver_panel/domain/usecases/get_bus_list.dart';
import 'package:untitled2/features/4_driver_panel/domain/usecases/select_bus.dart';
import 'bus_selection_event.dart';
import 'bus_selection_state.dart';

class BusSelectionBloc extends Bloc<BusSelectionEvent, BusSelectionState> {
  final GetBusListUseCase _getBusListUseCase;
  final SelectBusUseCase _selectBusUseCase;

  BusSelectionBloc({
    required GetBusListUseCase getBusListUseCase,
    required SelectBusUseCase selectBusUseCase,
  })  : _getBusListUseCase = getBusListUseCase,
        _selectBusUseCase = selectBusUseCase,
        super(const BusSelectionState()) {
    on<LoadBusList>(_onLoadBusList);
    on<BusSelected>(_onBusSelected);
  }

  Future<void> _onLoadBusList(LoadBusList event, Emitter<BusSelectionState> emit) async {
    emit(state.copyWith(status: BusSelectionStatus.loading));
    try {
      final buses = await _getBusListUseCase(null); // No necesita parámetros
      emit(state.copyWith(status: BusSelectionStatus.loaded, buses: buses));
    } catch (e) {
      emit(state.copyWith(status: BusSelectionStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onBusSelected(BusSelected event, Emitter<BusSelectionState> emit) async {
    try {
      await _selectBusUseCase(event.busName);
      emit(state.copyWith(status: BusSelectionStatus.success));
    } catch (e) {
      emit(state.copyWith(status: BusSelectionStatus.error, errorMessage: e.toString()));
    }
  }
}