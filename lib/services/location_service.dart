import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  StreamSubscription<Position>? positionStream;

  Future<void> checkPermissionAndGetLocation(Function(LatLng) onLocationUpdate) async {
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
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      LatLng latLng = LatLng(position.latitude, position.longitude);
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Obtener el número de bus desde Firestore
        FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((doc) {
          if (doc.exists) {
            String busName = doc.data()?['busName'];
            // Subir la ubicación junto con el número de bus a Firestore
            FirebaseFirestore.instance.collection('users').doc(user.uid).update({
              'latitude': position.latitude,
              'longitude': position.longitude,
              'busName': busName,
              'timestamp': FieldValue.serverTimestamp(),
            });
          }
        });
      }

      onLocationUpdate(latLng);
    });
  }

  void dispose() {
    positionStream?.cancel();
  }
}class UserLocationService {
  StreamSubscription<Position>? positionStream;

  Future<void> checkPermissionAndGetLocation(Function(LatLng) onLocationUpdate) async {
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
      locationSettings: LocationSettings(
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