import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/core/di/service_locator.dart';
import 'package:untitled2/features/2_map_view/data/models/bus_route_model.dart';
import 'package:untitled2/features/2_map_view/domain/entities/bus_route.dart';
import 'package:untitled2/features/3_shell_navigation/data/models/selected_bus_data.dart';
import 'package:untitled2/features/3_shell_navigation/data/models/transport_option_model.dart';

/// Sequential wizard screen for selecting specific stops for each bus
/// Part of Phase 2: The Curation Wizard
class BusRouteSelectorScreen extends StatefulWidget {
  final List<SelectedBusData> selectedBuses;
  final LatLng targetLocation;

  const BusRouteSelectorScreen({
    super.key,
    required this.selectedBuses,
    required this.targetLocation,
  });

  @override
  State<BusRouteSelectorScreen> createState() => _BusRouteSelectorScreenState();
}

class _BusRouteSelectorScreenState extends State<BusRouteSelectorScreen> {
  final FirebaseFirestore _firestore = sl<FirebaseFirestore>();

  int _currentBusIndex = 0;
  final List<TransportOption> _curatedOptions = [];
  Set<BusStop> _selectedStopsForCurrentBus = {};

  // Map data
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  BusRoute? _currentRoute;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRouteForCurrentBus();
  }

  Future<void> _loadRouteForCurrentBus() async {
    setState(() {
      _isLoading = true;
      _selectedStopsForCurrentBus = {};
    });

    final currentBus = widget.selectedBuses[_currentBusIndex];
    // Trim spaces from busId to avoid mismatches
    final trimmedBusId = currentBus.busId.trim();

    print(
        '🔍 DEBUG: Loading route for bus: ${currentBus.busName} (ID: "$trimmedBusId")');

    try {
      // First try busRoutes collection with trimmed ID
      DocumentSnapshot<Map<String, dynamic>>? doc;
      doc = await _firestore.collection('busRoutes').doc(trimmedBusId).get();

      if (!doc.exists) {
        print(
            '⚠️ DEBUG: Not found in busRoutes with ID, trying buses collection...');
        // Fallback to buses collection
        doc = await _firestore.collection('buses').doc(trimmedBusId).get();
      }

      // If still not found, try searching by name field
      if (!doc.exists) {
        print('⚠️ DEBUG: Not found by ID, searching by name field...');

        // Try busRoutes collection by name
        final routesQuery = await _firestore
            .collection('busRoutes')
            .where('name', isEqualTo: currentBus.busName.trim())
            .limit(1)
            .get();

        if (routesQuery.docs.isNotEmpty) {
          doc = routesQuery.docs.first;
          print('✅ DEBUG: Found in busRoutes by name!');
        } else {
          // Try buses collection by mainName
          final busesQuery = await _firestore
              .collection('buses')
              .where('mainName', isEqualTo: currentBus.busName.trim())
              .limit(1)
              .get();

          if (busesQuery.docs.isNotEmpty) {
            doc = busesQuery.docs.first;
            print('✅ DEBUG: Found in buses by mainName!');
          }
        }
      }

      if (!doc.exists) {
        print(
            '❌ DEBUG: Bus document not found in either collection with ID or name!');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bus ${currentBus.busName} no encontrado')),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      print('✅ DEBUG: Document found, parsing route...');
      final routeModel = BusRouteModel.fromFirestore(doc);
      final route = routeModel.toEntity();

      print(
          '✅ DEBUG: Route parsed - routePoints: ${route.routePoints.length}, stops: ${route.stops.length}');
      for (int i = 0; i < route.stops.length; i++) {
        print(
            '   Stop $i: ${route.stops[i].name} at ${route.stops[i].position}');
      }

      setState(() {
        _currentRoute = route;
        _buildMapElements();
        _isLoading = false;
      });

      print(
          '✅ DEBUG: Map elements built - markers: ${_markers.length}, polylines: ${_polylines.length}');

      // Animate camera to show the route
      if (_mapController != null && route.routePoints.isNotEmpty) {
        _animateCameraToRoute(route.routePoints);
      }
    } catch (e, stackTrace) {
      print('❌ DEBUG: Error loading route: $e');
      print('❌ DEBUG: Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando ruta: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  void _buildMapElements() {
    if (_currentRoute == null) return;

    // Build polyline
    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: _currentRoute!.routePoints,
        color: const Color(0xFF007BFF).withValues(alpha: 0.6),
        width: 5,
      ),
    };

    // Build stop markers with multi-selection support
    _markers = _currentRoute!.stops.asMap().entries.map((entry) {
      final index = entry.key;
      final stop = entry.value;
      final isSelected = _selectedStopsForCurrentBus.contains(stop);

      return Marker(
        markerId: MarkerId('stop_$index'),
        position: stop.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isSelected ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueAzure,
        ),
        infoWindow: InfoWindow(
          title: stop.name,
          snippet: isSelected ? '✓ Seleccionada' : 'Toca para seleccionar',
        ),
        onTap: () => _onStopMarkerTapped(stop),
      );
    }).toSet();

    // Add target location marker
    _markers.add(
      Marker(
        markerId: const MarkerId('target'),
        position: widget.targetLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Ubicación del lugar'),
      ),
    );
  }

  void _onStopMarkerTapped(BusStop stop) {
    setState(() {
      if (_selectedStopsForCurrentBus.contains(stop)) {
        _selectedStopsForCurrentBus.remove(stop);
      } else {
        _selectedStopsForCurrentBus.add(stop);
      }
      _buildMapElements(); // Rebuild to update marker colors
    });
  }

  void _animateCameraToRoute(List<LatLng> points) {
    if (points.isEmpty) return;

    // Calculate bounds
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    // Include target location in bounds
    if (widget.targetLocation.latitude < minLat)
      minLat = widget.targetLocation.latitude;
    if (widget.targetLocation.latitude > maxLat)
      maxLat = widget.targetLocation.latitude;
    if (widget.targetLocation.longitude < minLng)
      minLng = widget.targetLocation.longitude;
    if (widget.targetLocation.longitude > maxLng)
      maxLng = widget.targetLocation.longitude;

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  void _confirmAndNext() {
    if (_selectedStopsForCurrentBus.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor selecciona al menos una parada')),
      );
      return;
    }

    // Save current selections
    final currentBus = widget.selectedBuses[_currentBusIndex];
    final option = TransportOption(
      busId: currentBus.busId,
      busName: currentBus.busName,
      recommendedStops: _selectedStopsForCurrentBus
          .map((stop) => BusStopRecommendation(
                name: stop.name,
                lat: stop.position.latitude,
                lng: stop.position.longitude,
              ))
          .toList(),
    );

    _curatedOptions.add(option);

    // Check if this was the last bus
    if (_currentBusIndex >= widget.selectedBuses.length - 1) {
      // Finish curation - return results
      Navigator.of(context).pop([widget.targetLocation, _curatedOptions]);
    } else {
      // Move to next bus
      setState(() {
        _currentBusIndex++;
      });
      _loadRouteForCurrentBus();
    }
  }

  void _skipBus() {
    // Just move to next bus without adding to _curatedOptions
    if (_currentBusIndex >= widget.selectedBuses.length - 1) {
      // Finish curation - return results
      Navigator.of(context).pop([widget.targetLocation, _curatedOptions]);
    } else {
      // Move to next bus
      setState(() {
        _currentBusIndex++;
      });
      _loadRouteForCurrentBus();
    }
  }

  void _goBack() {
    if (_currentBusIndex > 0) {
      setState(() {
        _currentBusIndex--;
        // Remove the last curated option since we're going back
        // Logic check: if we skipped the previous bus, we shouldn't remove anything?
        // But we don't track which indices resulted in options vs skips easily.
        // Simple approach: pop if list is not empty.
        // However, this might delete a bus that WASN'T the one we just came from if we skipped?
        // Refinement: If we skipped, we didn't add. If we didn't skip, we added.
        // It's safer to not auto-remove or to track history.
        // Given complexity, let's keep it simple: assume user wants to redo previous step.
        // Ideally we should pop from _curatedOptions IF the previous bus was added.
        // But we don't know for sure without tracking. 
        // For now, let's just go back and let user re-decide. Note: this might duplicate if they re-add.
        // BETTER LOGIC: Find if we have an option for the (new) current index and remove it.
         
        final previousBusId = widget.selectedBuses[_currentBusIndex].busId;
        _curatedOptions.removeWhere((option) => option.busId == previousBusId);
      });
      _loadRouteForCurrentBus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentBus = widget.selectedBuses[_currentBusIndex];
    final isLastBus = _currentBusIndex >= widget.selectedBuses.length - 1;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Configurar: ${currentBus.busName}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Map
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white))
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.targetLocation,
                    zoom: 13,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _mapController?.setMapStyle(_darkMapStyle);
                    if (_currentRoute != null &&
                        _currentRoute!.routePoints.isNotEmpty) {
                      _animateCameraToRoute(_currentRoute!.routePoints);
                    }
                  },
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapToolbarEnabled: false,
                ),

          // Bottom control bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress indicator
                    Text(
                      'Bus ${_currentBusIndex + 1} de ${widget.selectedBuses.length}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value:
                          (_currentBusIndex + 1) / widget.selectedBuses.length,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF007BFF)),
                    ),
                    const SizedBox(height: 16),

                    // Instructions
                    Text(
                      _selectedStopsForCurrentBus.isEmpty
                          ? 'Toca marcadores azules para seleccionar paradas recomendadas'
                          : '✓ ${_selectedStopsForCurrentBus.length} parada${_selectedStopsForCurrentBus.length > 1 ? 's' : ''} seleccionada${_selectedStopsForCurrentBus.length > 1 ? 's' : ''}',
                      style: TextStyle(
                        color: _selectedStopsForCurrentBus.isEmpty
                            ? Colors.white70
                            : Colors.greenAccent,
                        fontSize: 14,
                        fontWeight: _selectedStopsForCurrentBus.isNotEmpty
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        // Back/Delete button combo
                        Expanded(
                          child: _currentBusIndex > 0
                              ? OutlinedButton(
                                  onPressed: _goBack,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.white54),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('ATRÁS'),
                                )
                              : OutlinedButton(
                                  onPressed: _skipBus,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.redAccent,
                                    side: const BorderSide(color: Colors.redAccent),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('OMITIR'),
                                ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Delete Button (only if not the first one, or maybe always?)
                        // User request: "un boton de eliminar bus y pasar al siguiente"
                        // I'll add a specific icon button for this in the middle or change logic.
                        // Let's make "Skip" available always if we want to remove the CURRENT bus.
                        
                        // REVISED DESIGN:
                        // Left: Back (if index > 0)
                        // Middle: Delete/Skip (Red icon)
                        // Right: Confirm/Next
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                         if (_currentBusIndex > 0)
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              onPressed: _goBack,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Icon(Icons.arrow_back, size: 20),
                            ),
                          ),
                          
                        if (_currentBusIndex > 0) const SizedBox(width: 8),

                        Expanded(
                          flex: 2,
                          child: OutlinedButton.icon(
                            onPressed: _skipBus,
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            label: const Text('OMITIR BUS'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                              side: const BorderSide(color: Colors.redAccent),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            onPressed: _selectedStopsForCurrentBus.isNotEmpty
                                ? _confirmAndNext
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007BFF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              disabledBackgroundColor: Colors.grey.shade800,
                            ),
                            child: Text(
                              isLastBus
                                  ? 'FINALIZAR'
                                  : 'SIGUIENTE',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
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

  final String _darkMapStyle = '''[
  {
    "elementType": "geometry",
    "stylers": [{"color": "#212121"}]
  },
  {
    "elementType": "labels.icon",
    "stylers": [{"visibility": "off"}]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#757575"}]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#212121"}]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [{"color": "#757575"}]
  },
  {
    "featureType": "administrative.country",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#9e9e9e"}]
  },
  {
    "featureType": "administrative.land_parcel",
    "stylers": [{"visibility": "off"}]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#bdbdbd"}]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#757575"}]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [{"color": "#181818"}]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#616161"}]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#1b1b1b"}]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [{"color": "#2c2c2c"}]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#8a8a8a"}]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [{"color": "#373737"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [{"color": "#3c3c3c"}]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [{"color": "#4e4e4e"}]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#616161"}]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#757575"}]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [{"color": "#000000"}]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#3d3d3d"}]
  }
]''';
}
