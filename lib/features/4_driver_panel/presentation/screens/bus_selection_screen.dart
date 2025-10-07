import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled2/core/di/service_locator.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_bloc.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_event.dart';
import 'package:untitled2/features/4_driver_panel/presentation/bloc/bus_selection_bloc.dart';
import 'package:untitled2/features/4_driver_panel/presentation/bloc/bus_selection_event.dart';
import 'package:untitled2/features/4_driver_panel/presentation/bloc/bus_selection_state.dart';

class DriverScreen extends StatelessWidget {
  const DriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BusSelectionBloc>()..add(LoadBusList()),
      child: const _DriverScreenView(),
    );
  }
}

class _DriverScreenView extends StatelessWidget {
  const _DriverScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona tu Bus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
            },
          ),
        ],
      ),
      body: BlocConsumer<BusSelectionBloc, BusSelectionState>(
        listener: (context, state) {
          if (state.status == BusSelectionStatus.success) {
            // --- CORRECCIÓN: NAVEGACIÓN ACTIVADA ---
            // Cuando el bus se selecciona correctamente, navegamos al mapa del conductor.
            context.go('/driver-map');
          } else if (state.status == BusSelectionStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          }
        },
        builder: (context, state) {
          if (state.status == BusSelectionStatus.loading || state.status == BusSelectionStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == BusSelectionStatus.error) {
            return Center(child: Text('Error al cargar la lista: ${state.errorMessage}'));
          }

          // El resto de los estados (loaded, success) mostrarán la lista.
          return ListView.builder(
            itemCount: state.buses.length,
            itemBuilder: (context, index) {
              final bus = state.buses[index];
              return GestureDetector(
                onTap: () {
                  context.read<BusSelectionBloc>().add(BusSelected(bus.name));
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.directions_bus, color: Colors.white),
                    ),
                    title: Text(
                      bus.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    trailing: const Icon(Icons.arrow_forward, color: Colors.blue),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}