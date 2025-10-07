import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/core/di/service_locator.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_bloc.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_event.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_state.dart';

class DriverMapScreen extends StatelessWidget {
  const DriverMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos el mismo MapBloc que la pantalla del usuario,
    // ya que está preparado para manejar la lógica de ubicación.
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
      ),
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          // Cada vez que la ubicación del usuario se actualiza, movemos la cámara.
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

          return GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: const CameraPosition(
              target: LatLng(-13.52264, -71.96226), // Cusco por defecto
              zoom: 14,
            ),
            markers: markers,
            myLocationEnabled: false, // Usamos nuestro marcador personalizado
            myLocationButtonEnabled: true,
          );
        },
      ),
    );
  }
}