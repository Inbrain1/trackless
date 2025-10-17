import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/core/di/service_locator.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_bloc.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_event.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_state.dart';
import 'package:go_router/go_router.dart';

class DriverMapScreen extends StatelessWidget {
  const DriverMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MapBloc>()..add(LoadMap()),
      child: const _DriverMapView(),
    );
  }
}

class _DriverMapView extends StatefulWidget {
  const _DriverMapView();

  @override
  State<_DriverMapView> createState() => _DriverMapViewState();
}

class _DriverMapViewState extends State<_DriverMapView> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Conductor: En Ruta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<MapBloc>().add(StopGpsTracking());
            context.go('/driver-panel');
          },
        ),
      ),
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state.userLocation != null && _mapController != null) {
            _mapController!.animateCamera(CameraUpdate.newLatLngZoom(state.userLocation!, 16));
          }
          if (state.status == MapStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error de ubicación: ${state.errorMessage}')),
            );
          }
        },
        builder: (context, state) {
          final Set<Marker> markers = {};
          if (state.userLocation != null) {
            markers.add(
              Marker(
                markerId: const MarkerId('driver_location'),
                position: state.userLocation!,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                infoWindow: const InfoWindow(title: 'Mi Ubicación'),
              ),
            );
          }

          return Stack(
            children: [
              GoogleMap(
                onMapCreated: (controller) => _mapController = controller,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(-13.52264, -71.96226), // Cusco por defecto
                  zoom: 14,
                ),
                markers: markers,
                myLocationEnabled: false,
                myLocationButtonEnabled: true,
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      if (state.isTracking) {
                        context.read<MapBloc>().add(StopGpsTracking());
                      } else {
                        context.read<MapBloc>().add(StartGpsTracking());
                      }
                    },
                    label: Text(state.isTracking ? 'Finalizar Viaje' : 'Iniciar Viaje'),
                    icon: Icon(state.isTracking ? Icons.stop_circle_outlined : Icons.play_arrow_rounded),
                    backgroundColor: state.isTracking ? Colors.red.shade700 : Colors.green.shade700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}