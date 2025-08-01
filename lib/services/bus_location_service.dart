import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BusLocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para actualizar la ubicación del conductor en Firestore
  Future<void> updateBusLocation(String busName, LatLng newLocation) async {
    User? user = _auth.currentUser; // Obtener usuario actual (conductor)
    if (user != null && user.uid.isNotEmpty) {
      try {
        // Actualizar la ubicación del conductor en la colección 'users'
        await _firestore.collection('users').doc(user.uid).update({
          'latitude': newLocation.latitude,
          'longitude': newLocation.longitude,
          'busName': busName,  // Asignamos el bus al conductor
          'timestamp': FieldValue.serverTimestamp(), // Marca la hora de la actualización
        });

        // También podemos actualizar la ubicación del bus en la colección de buses
        await _firestore.collection('buses').doc(busName).update({
          'currentLocation': GeoPoint(newLocation.latitude, newLocation.longitude),
        });
      } catch (e) {
        print("Error al actualizar la ubicación: $e");
      }
    }
  }

  // Obtener la ubicación del bus en tiempo real para visualizar en el mapa
  Stream<LatLng> getBusLocation(String busName) {
    return _firestore
        .collection('users')
        .where('busName', isEqualTo: busName)  // Filtramos por el nombre del bus
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        double latitude = doc['latitude'];
        double longitude = doc['longitude'];
        return LatLng(latitude, longitude);
      } else {
        throw Exception('Bus not found');
      }
    });
  }
}