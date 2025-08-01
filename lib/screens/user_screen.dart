import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/services/directions_service.dart';
import '../helpers/ai_handler.dart';
import '../services/location_service.dart';
import '../widgets/draggable_sheet.dart';
import '../services/bus_location_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/marker_animation_service.dart';

class UserMapScreen extends StatefulWidget {
  @override
  _UserMapScreenState createState() => _UserMapScreenState();
}

class _UserMapScreenState extends State<UserMapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  final directionsService = DirectionsService();
  final userLocationService = UserLocationService();
  final busLocationService = BusLocationService();
  String? selectedBusName; // Variable para almacenar el bus seleccionado
  bool isLoadingRoute = false;

  BitmapDescriptor? stopBusIcon;
  bool isStopBusIconReady = false;

  double currentZoom = 14.0;
  double previousZoom = 14.0;
  bool markersVisible = false;
  bool firstLoad = true;

  String? lastBusLoaded;

  void _setMarkers(Set<Marker> newMarkers) {
    setState(() {
      markers = newMarkers;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.getZoomLevel().then((zoom) {
      setState(() {
        currentZoom = zoom;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(0, 0)),
      'assets/stopbus.png',
    ).then((icon) {
      setState(() {
        stopBusIcon = icon;
        isStopBusIconReady = true;
      });
    });

    userLocationService.checkPermissionAndGetLocation((LatLng latLng) {
      setState(() {
        // Actualiza el marcador de ubicación del usuario con color violeta
        markers.removeWhere((marker) => marker.markerId.value == 'user_location');
        markers.add(
          Marker(
            markerId: const MarkerId('user_location'),
            position: latLng,
            infoWindow: const InfoWindow(title: 'Tu ubicación'),
            // Mantener el color original del marcador del usuario (violeta)
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          ),
        );

        // Mueve la cámara a la ubicación actual del usuario
        mapController.animateCamera(CameraUpdate.newLatLng(latLng));
      });
    });
  }

  void _onBusSelected(String busName) async {
    if (selectedBusName == busName) {
      // Si el bus seleccionado es el mismo, lo deseleccionamos
      setState(() {
        selectedBusName = null;
        lastBusLoaded = null;
        lastStopCoords.clear();
        markers.clear();
        polylines.clear();
        markers.removeWhere((m) =>
        m.markerId.value.startsWith('checkpoint_') ||
            m.markerId.value.contains(busName));
      });
      return;
    }

    setState(() {
      isLoadingRoute = true;
    });

    // Primero limpiamos los marcadores de la ruta anterior
    markers.clear();

    // Cargar la nueva ruta y ubicaciones del bus
    await _loadBusRoute(busName);
    await _loadBusLocations(busName);

    setState(() {
      isLoadingRoute = false;
      selectedBusName = busName;
    });
  }

  List<LatLng> lastStopCoords = [];

  Future<void> _loadBusRoute(String busName) async {
    if (!isStopBusIconReady) {
      print("Ícono de paradero no cargado aún");
      return;
    }

    if (busName == lastBusLoaded && lastStopCoords.isNotEmpty) {
      print("Ruta $busName ya está cargada. Usando datos en caché.");
      await MarkerAnimationService.animateAddMarkers(
        markers: markers,
        setMarkers: _setMarkers,
        stopCoords: lastStopCoords,
        busName: busName,
        icon: stopBusIcon,
        currentZoom: currentZoom,
        animate: false,
      );
      return;
    }

    print("Cargando ruta para $busName");

    setState(() {
      selectedBusName = busName;
      polylines.clear();
      markers.removeWhere((m) => m.markerId.value.startsWith('checkpoint_'));
    });

    final doc = await FirebaseFirestore.instance.collection('busRoutes').doc(busName).get();

    if (!doc.exists) {
      print("Ruta no encontrada para $busName");
      return;
    }

    final data = doc.data();
    final List<dynamic> routeData = data?['route'] ?? [];
    final List<dynamic> stopData = data?['stops'] ?? [];

    // Ruta detallada
    final List<LatLng> routeCoords = routeData
        .map((point) => LatLng(point['lat'] as double, point['lng'] as double))
        .toList();

    // Paraderos reales
    final List<LatLng> stopCoords = stopData
        .map((point) => LatLng(point['lat'] as double, point['lng'] as double))
        .toList();

    print("Total paraderos: ${stopCoords.length}");
    print("Total puntos de ruta: ${routeCoords.length}");

    setState(() {
      // Dibuja la línea
      polylines.add(
        Polyline(
          polylineId: PolylineId(busName),
          color: Colors.blue,
          width: 4,
          points: routeCoords,
        ),
      );
      // Guarda los paraderos para uso posterior
      lastStopCoords = stopCoords;
    });

    await MarkerAnimationService.animateAddMarkers(
      markers: markers,
      setMarkers: _setMarkers,
      stopCoords: stopCoords,
      busName: busName,
      icon: stopBusIcon,
      currentZoom: currentZoom,
      animate: !firstLoad,
    );
    firstLoad = false;
    markersVisible = currentZoom >= 16.0;
    previousZoom = currentZoom;
    lastBusLoaded = busName;
  }

  Future<void> _loadBusLocations(String busName) async {
    print("Cargando ubicaciones en tiempo real para $busName");

    // Escuchar cambios en la ubicación de los conductores de ese bus
    FirebaseFirestore.instance
        .collection('users')
        .where('busName', isEqualTo: busName)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Actualizar los marcadores con los conductores y sus ubicaciones
        snapshot.docs.forEach((doc) {
          double latitude = doc['latitude'];
          double longitude = doc['longitude'];

          // Asignar un icono diferente para cada ruta de bus
          BitmapDescriptor icon = _getBusIcon(busName);

          markers.add(
            Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(title: busName),
              icon: icon,
            ),
          );
        });
      }
      setState(() {});
    });
  }

  // Método para obtener el icono del bus según la ruta
  BitmapDescriptor _getBusIcon(String busName) {
    if (busName == "Patron de San Jerónimo") {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    } else if (busName == "Satélite") {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    } else if (busName == "Saylla Tipon Oropesa") {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    } else {
      // Valor predeterminado
      return BitmapDescriptor.defaultMarker;
    }
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
        title: const Text('Seleccionar Ruta de Bus'),
        leading :IconButton(
          icon: const Icon(FontAwesomeIcons.robot),
          onPressed: () {
            AIHandler.showAIAlertDialog(context);
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.7749, -122.4194), // Coordenadas iniciales
              zoom: 14.0,
            ),
            markers: markers,
            polylines: polylines,
            onCameraMove: (position) {
              currentZoom = position.zoom;
            },
            onCameraIdle: () {
              if (selectedBusName != null && lastStopCoords.isNotEmpty) {
                if ((previousZoom < 16.0 && currentZoom >= 16.0) ||
                    (previousZoom >= 16.0 && currentZoom < 16.0)) {
                  MarkerAnimationService.animateAddMarkers(
                    markers: markers,
                    setMarkers: _setMarkers,
                    stopCoords: lastStopCoords,
                    busName: selectedBusName!,
                    icon: stopBusIcon,
                    currentZoom: currentZoom,
                    animate: true,
                  );
                  markersVisible = currentZoom >= 16.0;
                  previousZoom = currentZoom;
                }
              }
            },
          ),
          DraggableSheet(onBusSelected: _onBusSelected, selectedBusName: selectedBusName), // DraggableSheet para seleccionar bus
          if (isLoadingRoute)
            Positioned.fill(
              child: Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}