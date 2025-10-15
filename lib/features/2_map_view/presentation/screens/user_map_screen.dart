import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/core/di/service_locator.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_bloc.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_event.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_state.dart';
import '../widgets/bus_selection_sheet.dart';

class UserMapScreen extends StatelessWidget {
  const UserMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MapBloc>()..add(LoadMap()),
      child: const _UserMapView(),
    );
  }
}

class _UserMapView extends StatefulWidget {
  const _UserMapView();

  @override
  State<_UserMapView> createState() => _UserMapViewState();
}

class _UserMapViewState extends State<_UserMapView> {
  GoogleMapController? _mapController;
  BitmapDescriptor? _stopBusIcon;

  @override
  void initState() {
    super.initState();
    _loadMarkerIcons();
  }

  void _loadMarkerIcons() async {
    _stopBusIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(24, 24)),
      'assets/stopbus.png',
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state.status == MapStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          }
          // Animar cámara a la ubicación del usuario la primera vez que se obtiene
          if (state.userLocation != null && _mapController != null) {
            _mapController!.animateCamera(CameraUpdate.newLatLng(state.userLocation!));
          }
        },
        builder: (context, state) {
          final Set<Marker> markers = {};
          final Set<Polyline> polylines = {};

          // Añadir marcador de usuario
          if (state.userLocation != null) {
            markers.add(Marker(
              markerId: const MarkerId('user_location'),
              position: state.userLocation!,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
              infoWindow: const InfoWindow(title: 'Tu Ubicación'),
            ));
          }

          // Añadir polilínea y paradas de la ruta seleccionada
          if (state.selectedBusRoute != null && _stopBusIcon != null) {
            polylines.add(Polyline(
              polylineId: PolylineId(state.selectedBusRoute!.name),
              color: Colors.blue,
              width: 5,
              points: state.selectedBusRoute!.routePoints,
            ));
            for (var i = 0; i < state.selectedBusRoute!.stops.length; i++) {
              markers.add(Marker(
                markerId: MarkerId('stop_${state.selectedBusRoute!.name}_$i'),
                position: state.selectedBusRoute!.stops[i],
                icon: _stopBusIcon!,
                infoWindow: InfoWindow(title: 'Parada ${i + 1}'),
              ));
            }
          }

          // Añadir marcadores de buses en tiempo real
          for (final busLocation in state.busLocations) {
            markers.add(Marker(
              markerId: MarkerId(busLocation.driverId),
              position: busLocation.position,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              infoWindow: InfoWindow(title: busLocation.busName),
            ));
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
                polylines: polylines,
                myLocationButtonEnabled: true,
                myLocationEnabled: false,
              ),
            ],
          );
        },
      ),
    );
  }
}