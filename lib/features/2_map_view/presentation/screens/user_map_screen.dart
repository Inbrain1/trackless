import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// Quitamos la importación de service_locator y MapEvent ya que no se crea el BLoC aquí
import 'package:untitled2/features/2_map_view/presentation/bloc/map_bloc.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_state.dart';
// Quitamos la importación de BusSelectionSheet si no se usa directamente aquí

class UserMapScreen extends StatelessWidget {
  const UserMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- CORRECCIÓN: Ya no creamos el BlocProvider aquí ---
    // Simplemente devolvemos la vista, que accederá al BLoC proporcionado por MainScreen.
    return const _UserMapView();
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
  BitmapDescriptor? _activeBusIcon; // Icono para buses activos

  @override
  void initState() {
    super.initState();
    _loadMarkerIcons();
    // Opcional: Si quieres asegurar que la ubicación del usuario se cargue al entrar a esta pestaña
    // context.read<MapBloc>().add(LoadMap()); // Asegúrate que LoadMap haga lo correcto ahora
  }

  void _loadMarkerIcons() async {
    // Icono para las paradas (bus stop)
    _stopBusIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(24, 24)), // Tamaño ajustado
      'assets/stopbus.png', // Asegúrate que esta ruta sea correcta
    ).catchError((e) {
      print("Error loading stopbus.png: $e"); // Manejo de error si no carga
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange); // Fallback icon
    });


    // Icono para buses activos (ejemplo: un bus verde)
    // Puedes crear otro asset o usar uno por defecto con color
    _activeBusIcon = await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar eliminada ya que la navegación es por BottomNavBar
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state.status == MapStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          }
          // Animar cámara a la ubicación del usuario la primera vez que se obtiene
          // Opcional: Podrías querer centrar solo si no hay un bus seleccionado
          if (state.userLocation != null && _mapController != null && state.selectedBusRoute == null) {
            //_mapController!.animateCamera(CameraUpdate.newLatLng(state.userLocation!));
            _mapController!.animateCamera(CameraUpdate.newLatLngZoom(state.userLocation!, 15)); // Zoom inicial
          }
          // Si se selecciona una ruta, animar para mostrarla (opcional)
          if (state.selectedBusRoute != null && state.selectedBusRoute!.routePoints.isNotEmpty && _mapController != null) {
            // Calcular límites para mostrar toda la ruta
            try {
              LatLngBounds bounds = _boundsFromLatLngList(state.selectedBusRoute!.routePoints);
              _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0)); // 50px padding
            } catch (e) {
              print("Error calculating bounds: $e");
              // Fallback: Centrar en el primer punto de la ruta si falla el cálculo de límites
              if (state.selectedBusRoute!.routePoints.isNotEmpty) {
                _mapController!.animateCamera(CameraUpdate.newLatLngZoom(state.selectedBusRoute!.routePoints.first, 14));
              }
            }
          }
        },
        builder: (context, state) {
          final Set<Marker> markers = {};
          final Set<Polyline> polylines = {};

          // Añadir marcador de usuario (Tu ubicación)
          if (state.userLocation != null) {
            markers.add(Marker(
              markerId: const MarkerId('user_location'),
              position: state.userLocation!,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet), // Color distintivo
              infoWindow: const InfoWindow(title: 'Tu Ubicación'),
              anchor: const Offset(0.5, 0.5), // Centrar el icono
            ));
          }

          // Añadir polilínea y paradas de la ruta seleccionada (si existe)
          if (state.selectedBusRoute != null && _stopBusIcon != null) {
            polylines.add(Polyline(
              polylineId: PolylineId(state.selectedBusRoute!.name),
              color: Colors.blue.shade700, // Color más oscuro
              width: 5, // Grosor
              points: state.selectedBusRoute!.routePoints,
              jointType: JointType.round, // Uniones redondeadas
              startCap: Cap.roundCap, // Inicio redondeado
              endCap: Cap.roundCap, // Fin redondeado
            ));

            // Añadir marcadores para las paradas
            for (var i = 0; i < state.selectedBusRoute!.stops.length; i++) {
              markers.add(Marker(
                markerId: MarkerId('stop_${state.selectedBusRoute!.name}_$i'),
                position: state.selectedBusRoute!.stops[i],
                icon: _stopBusIcon!, // Icono de parada
                infoWindow: InfoWindow(title: 'Parada ${i + 1}'),
                anchor: const Offset(0.5, 0.5), // Centrar icono de parada
              ));
            }
          }

          // Añadir marcadores de buses en tiempo real (SOLO para el bus SELECCIONADO)
          if (_activeBusIcon != null) {
            for (final busLocation in state.busLocations) { // busLocations ahora solo tiene el bus seleccionado
              markers.add(Marker(
                markerId: MarkerId('bus_${busLocation.busName}'), // Usar busName para ID único
                position: busLocation.position,
                icon: _activeBusIcon!, // Icono de bus activo (verde)
                infoWindow: InfoWindow(title: busLocation.busName),
                anchor: const Offset(0.5, 0.5), // Centrar icono del bus
                // Opcional: Añadir rotación si la API la proporciona
                // rotation: busLocation.heading ?? 0.0,
                flat: true, // Para que el marcador rote con el mapa
              ));
            }
          }

          return GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: const CameraPosition(
              target: LatLng(-13.52264, -71.96226), // Cusco por defecto
              zoom: 14,
            ),
            markers: markers,
            polylines: polylines,
            myLocationButtonEnabled: true, // Botón para ir a tu ubicación
            myLocationEnabled: false, // Deshabilitamos el punto azul por defecto (usamos nuestro marcador)
            zoomControlsEnabled: false, // Opcional: Ocultar botones de zoom
            mapToolbarEnabled: false, // Opcional: Ocultar barra de herramientas (abrir en Google Maps)
            compassEnabled: true, // Mostrar brújula
            mapType: MapType.normal, // Tipo de mapa
          );
        },
      ),
    );
  }

  // Helper para calcular los límites de una lista de coordenadas
  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    if (list.isEmpty) {
      // Si no hay puntos, devuelve un área pequeña cerca del centro por defecto
      return LatLngBounds(
        southwest: const LatLng(-13.523, -71.963),
        northeast: const LatLng(-13.522, -71.962),
      );
    }
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    // Asegurarse de que y0 y y1 no sean nulos antes de usarlos
    // y que northeast tenga lat > southwest y lon > southwest
    if (y0 == null || y1 == null || x0 == null || x1 == null) {
      return LatLngBounds(
        southwest: const LatLng(-13.523, -71.963),
        northeast: const LatLng(-13.522, -71.962),
      );
    }

    // Corrección para asegurar que southwest < northeast
    double swLat = x0;
    double swLng = y0;
    double neLat = x1;
    double neLng = y1;

    if (swLat > neLat) {
      swLat = x1;
      neLat = x0;
    }
    if (swLng > neLng) {
      swLng = y1;
      neLng = y0;
    }


    return LatLngBounds(northeast: LatLng(neLat, neLng), southwest: LatLng(swLat, swLng));
  }

}