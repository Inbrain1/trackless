import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationDataSource {
  Stream<LatLng> watchUserLocation();
}

class LocationDataSourceImpl implements LocationDataSource {
  @override
  Stream<LatLng> watchUserLocation() async* {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('El permiso de ubicación fue denegado.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Los permisos de ubicación están permanentemente denegados.');
    }

    // --- MODIFICACIÓN CLAVE ---
    // Ajustamos la configuración para obtener actualizaciones más frecuentes.
    yield* Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high, // Máxima precisión
        distanceFilter: 0, // Notificar en cada mínimo cambio (ideal para 'cada segundo')
      ),
    ).map((position) => LatLng(position.latitude, position.longitude));
  }
}