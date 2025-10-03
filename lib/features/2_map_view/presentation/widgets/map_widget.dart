import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final LatLng initialPosition;
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;

  MapWidget({
    required this.initialPosition,
    required this.markers,
    required this.onMapCreated,
  });

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        widget.onMapCreated(controller);
      },
      initialCameraPosition: CameraPosition(
        target: widget.initialPosition,
        zoom: 14.0,
      ),
      markers: widget.markers,
    );
  }
}
