import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';
import '../widgets/map_widget.dart';

class DriverMapScreen extends StatefulWidget {
  @override
  _DriverMapScreenState createState() => _DriverMapScreenState();
}

class _DriverMapScreenState extends State<DriverMapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  final LocationService locationService = LocationService();

  @override
  void initState() {
    super.initState();
    locationService.checkPermissionAndGetLocation(_onLocationUpdate);
  }

  @override
  void dispose() {
    locationService.dispose();
    super.dispose();
  }

  void _onLocationUpdate(LatLng latLng) {
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: latLng,
          infoWindow: InfoWindow(title: 'Tu ubicación'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    });

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 14.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Map Screen'),
      ),
      body: MapWidget(
        initialPosition: LatLng(0.0, 0.0),
        markers: markers,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
