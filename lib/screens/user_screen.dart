import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';
import '../widgets/draggable_sheet.dart';
import '../services/bus_location_service.dart';

class UserMapScreen extends StatefulWidget {
  @override
  _UserMapScreenState createState() => _UserMapScreenState();
}

class _UserMapScreenState extends State<UserMapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  final userLocationService = UserLocationService();
  final busLocationService = BusLocationService();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    userLocationService.checkPermissionAndGetLocation((LatLng latLng) {
      setState(() {
        // Actualiza el marcador de ubicación del usuario
        markers.removeWhere((marker) => marker.markerId.value == 'user_location');
        markers.add(
          Marker(
            markerId: MarkerId('user_location'),
            position: latLng,
            infoWindow: InfoWindow(title: 'Tu ubicación'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          ),
        );

        // Mueve la cámara a la ubicación actual del usuario
        mapController.animateCamera(CameraUpdate.newLatLng(latLng));
      });
    });
  }

  void _onBusSelected(String busName) {
    busLocationService.getBusLocation(busName).then((location) {
      setState(() {
        // Actualiza o agrega un marcador para la ubicación del bus
        markers.removeWhere((marker) => marker.markerId.value == busName);
        markers.add(
          Marker(
            markerId: MarkerId(busName),
            position: location,
            infoWindow: InfoWindow(title: busName),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );

        // Mueve la cámara a la ubicación del bus
        mapController.animateCamera(CameraUpdate.newLatLng(location));
      });
    }).catchError((error) {
      print('Error getting bus location: $error');
    });
  }

  @override
  void dispose() {
    userLocationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('User Map Screen'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194), // Coordenadas de ejemplo
              zoom: 14.0,
            ),
            markers: markers,
          ),
          DraggableSheet(onBusSelected: _onBusSelected),
        ],
      ),
    );
  }
}
