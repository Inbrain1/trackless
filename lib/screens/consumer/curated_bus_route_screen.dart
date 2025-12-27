import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:untitled2/features/3_shell_navigation/data/models/transport_option_model.dart';

/// Curated bus route map screen for Discovery Card consumer view
/// Shows full route with visual hierarchy: prominent recommended stops + subtle context stops
class CuratedBusRouteScreen extends StatefulWidget {
  final TransportOption transportOption;

  const CuratedBusRouteScreen({
    Key? key,
    required this.transportOption,
  }) : super(key: key);

  @override
  State<CuratedBusRouteScreen> createState() => _CuratedBusRouteScreenState();
}

class _CuratedBusRouteScreenState extends State<CuratedBusRouteScreen> {
  GoogleMapController? _mapController;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  List<LatLng> _routeCoordinates = [];
  List<BusStopRecommendation> _allStops = [];
  Position? _userLocation;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      await _getUserLocation();
      await _fetchBusRouteData();
      _buildPolyline();
      _buildMarkers();
      _adjustCamera();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Get user's current location
  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions permanently denied');
        return;
      }

      _userLocation = await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Error getting user location: $e');
    }
  }

  /// Fetch full route geometry and all stops from Firestore
  Future<void> _fetchBusRouteData() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('busRoutes')
        .doc(widget.transportOption.busId)
        .get();

    if (!docSnapshot.exists) {
      throw Exception('Bus route not found: ${widget.transportOption.busId}');
    }

    final data = docSnapshot.data()!;

    // Parse route coordinates
    if (data['route'] != null) {
      final routeData = data['route'] as List<dynamic>;
      _routeCoordinates = routeData.map((point) {
        // Handle both GeoPoint and Map formats
        if (point is GeoPoint) {
          return LatLng(point.latitude, point.longitude);
        } else if (point is Map) {
          return LatLng(
            (point['lat'] ?? point['latitude']) as double,
            (point['lng'] ?? point['longitude']) as double,
          );
        } else {
          throw Exception('Invalid route point format');
        }
      }).toList();
    }

    // Parse all stops
    if (data['stops'] != null) {
      final stopsData = data['stops'] as List<dynamic>;
      _allStops = stopsData.map((stopData) {
        // Convert to Map if needed
        Map<String, dynamic> stopMap;
        if (stopData is Map<String, dynamic>) {
          stopMap = stopData;
        } else {
          stopMap = Map<String, dynamic>.from(stopData as Map);
        }

        // Handle GeoPoint in location field if present
        if (stopMap.containsKey('location') &&
            stopMap['location'] is GeoPoint) {
          final geoPoint = stopMap['location'] as GeoPoint;
          stopMap['lat'] = geoPoint.latitude;
          stopMap['lng'] = geoPoint.longitude;
        }

        return BusStopRecommendation.fromMap(stopMap);
      }).toList();
    }

    if (_routeCoordinates.isEmpty) {
      throw Exception('No route geometry found');
    }

    if (_allStops.isEmpty) {
      throw Exception('No stops found');
    }
  }

  /// Build the full route polyline (blue)
  void _buildPolyline() {
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('bus_route'),
        points: _routeCoordinates,
        color: Colors.blue,
        width: 5,
        patterns: [PatternItem.dot, PatternItem.gap(10)],
      ),
    );
  }

  /// Build markers with two-tier visual hierarchy
  /// TIER 1: Recommended Stops (Destination) - Large, Green, Prominent
  /// TIER 2: Regular Stops (Context/Boarding) - Small, Subtle, Faded
  void _buildMarkers() {
    for (int i = 0; i < _allStops.length; i++) {
      final stop = _allStops[i];
      final isRecommendedStop = widget.transportOption.recommendedStops.any(
          (recStop) => recStop.name.toLowerCase() == stop.name.toLowerCase());

      if (isRecommendedStop) {
        // CASE A: Recommended Stop (The Destination)
        _markers.add(
          Marker(
            markerId: MarkerId('recommended_${stop.name}_$i'),
            position: LatLng(stop.lat, stop.lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            zIndex: 10, // On top
            infoWindow: InfoWindow(
              title: '🎯 BÁJATE AQUÍ',
              snippet: stop.name,
            ),
            onTap: () {
              _showStopBottomSheet(stop, isDestination: true);
            },
          ),
        );
      } else {
        // CASE B: Regular Stop (Context/Boarding)
        _markers.add(
          Marker(
            markerId: MarkerId('regular_${stop.name}_$i'),
            position: LatLng(stop.lat, stop.lng),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
            alpha: 0.7, // Slightly faded
            zIndex: 1,
            infoWindow: InfoWindow(
              title: stop.name,
              snippet: 'Punto de abordaje',
            ),
            onTap: () {
              _showStopBottomSheet(stop, isDestination: false);
            },
          ),
        );
      }
    }

    // Add user location marker if available
    if (_userLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(_userLocation!.latitude, _userLocation!.longitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          zIndex: 5,
          infoWindow: const InfoWindow(
            title: 'Tu ubicación',
          ),
        ),
      );
    }
  }

  /// Adjust camera to fit user location and recommended stops
  void _adjustCamera() {
    if (_mapController == null) return;

    final List<LatLng> pointsToFit = [];

    // Add user location
    if (_userLocation != null) {
      pointsToFit
          .add(LatLng(_userLocation!.latitude, _userLocation!.longitude));
    }

    // Add recommended stops
    for (final stop in _allStops) {
      final isRecommended = widget.transportOption.recommendedStops.any(
          (recStop) => recStop.name.toLowerCase() == stop.name.toLowerCase());
      if (isRecommended) {
        pointsToFit.add(LatLng(stop.lat, stop.lng));
      }
    }

    // Fallback: if no points to fit, show entire route
    if (pointsToFit.isEmpty && _routeCoordinates.isNotEmpty) {
      pointsToFit.addAll(_routeCoordinates);
    }

    if (pointsToFit.isEmpty) return;

    // Calculate bounds
    double minLat = pointsToFit.first.latitude;
    double maxLat = pointsToFit.first.latitude;
    double minLng = pointsToFit.first.longitude;
    double maxLng = pointsToFit.first.longitude;

    for (final point in pointsToFit) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80), // 80px padding
    );
  }

  /// Show bottom sheet with stop details
  void _showStopBottomSheet(BusStopRecommendation stop,
      {required bool isDestination}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDestination)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flag_rounded,
                        size: 16, color: Colors.green[700]),
                    const SizedBox(width: 4),
                    Text(
                      'DESTINO',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.place_rounded,
                        size: 16, color: Colors.blue[700]),
                    const SizedBox(width: 4),
                    Text(
                      'PUNTO DE ABORDAJE',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            Text(
              stop.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              isDestination
                  ? 'Esta es tu parada de destino. Bájate aquí.'
                  : 'Puedes abordar el bus en esta parada.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement navigation to this stop
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.navigation_rounded),
                label: const Text('Navegar aquí'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.transportOption.busName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Mapa de Ruta',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_rounded),
            onPressed: _adjustCamera,
            tooltip: 'Recentrar mapa',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error cargando ruta',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: (controller) {
                        _mapController = controller;
                        _adjustCamera();
                      },
                      initialCameraPosition: CameraPosition(
                        target: _routeCoordinates.isNotEmpty
                            ? _routeCoordinates.first
                            : const LatLng(
                                -13.5320, -71.9675), // Cusco fallback
                        zoom: 12,
                      ),
                      polylines: _polylines,
                      markers: _markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                    ),

                    // Legend
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildLegendItem(
                                icon: Icons.flag_rounded,
                                color: Colors.green,
                                label: 'Bájate aquí',
                              ),
                              const SizedBox(height: 8),
                              _buildLegendItem(
                                icon: Icons.place_rounded,
                                color: Colors.grey,
                                label: 'Puntos de abordaje',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildLegendItem({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
