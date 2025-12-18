import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  StreamSubscription<Position>? positionStream;

  Future<void> checkPermissionAndGetLocation(
      Function(LatLng) onLocationUpdate) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('El servicio de ubicación está deshabilitado.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Permisos denegados.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Permisos denegados permanentemente.');
      return;
    }

    startLocationUpdates(onLocationUpdate);
  }

  void startLocationUpdates(Function(LatLng) onLocationUpdate) {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      LatLng latLng = LatLng(position.latitude, position.longitude);
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Obtener el número de bus desde Firestore una sola vez
        // Nota: Esto asume que el busName no cambia durante la sesión de tracking.
        // Si cambia, se debería manejar externamente o recargar.
        _updateLocationToFirestore(user, position);
      }

      onLocationUpdate(latLng);
    });
  }

  // Cache para el nombre del bus para evitar lecturas constantes
  String? _cachedBusName;
  bool _hasFetchedBusName = false;

  Future<void> _updateLocationToFirestore(User user, Position position) async {
    try {
      if (!_hasFetchedBusName) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          _cachedBusName = doc.data()?['busName'];
        }
        _hasFetchedBusName = true;
      }

      if (_cachedBusName != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'busName': _cachedBusName,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  void dispose() {
    positionStream?.cancel();
  }
}

class UserLocationService {
  StreamSubscription<Position>? positionStream;

  Future<void> checkPermissionAndGetLocation(
      Function(LatLng) onLocationUpdate) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('El servicio de ubicación está deshabilitado.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Permisos denegados.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Permisos denegados permanentemente.');
      return;
    }

    startLocationUpdates(onLocationUpdate);
  }

  void startLocationUpdates(Function(LatLng) onLocationUpdate) {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      LatLng latLng = LatLng(position.latitude, position.longitude);
      onLocationUpdate(latLng);
    });
  }

  void dispose() {
    positionStream?.cancel();
  }
}
