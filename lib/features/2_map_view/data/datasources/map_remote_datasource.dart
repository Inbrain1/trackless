import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/features/2_map_view/data/models/bus_location_model.dart';
import 'package:untitled2/features/2_map_view/data/models/bus_route_model.dart';

abstract class MapRemoteDataSource {
  Future<BusRouteModel> getBusRouteDetails(String busName);
  Stream<List<BusLocationModel>> watchBusLocations(String busName);
  Future<void> updateUserLocation(LatLng position);
  Future<void> stopSharingLocation();
  Stream<List<BusLocationModel>> watchAllActiveBuses(); // <-- NUEVO
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  MapRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  @override
  Future<BusRouteModel> getBusRouteDetails(String busName) async {
    // NOTA: Esta lógica asume que las rutas detalladas están en una colección 'busRoutes'.
    // Si tus rutas detalladas (con polilíneas y paradas) están en la colección 'buses',
    // deberás ajustar esta consulta. Por ejemplo:
    // final docSnapshot = await _firestore.collection('buses').doc(busName).get();
    final docSnapshot = await _firestore.collection('busRoutes').doc(busName).get();
    if (!docSnapshot.exists) {
      // Intentar obtener de 'buses' si no se encuentra en 'busRoutes'
      final busDocSnapshot = await _firestore.collection('buses').doc(busName).get();
      if (!busDocSnapshot.exists) {
        throw Exception('Ruta no encontrada para $busName en busRoutes ni en buses.');
      }
      // Asumiendo que BusRouteModel puede parsear desde el doc de 'buses'
      // Si la estructura es diferente, necesitarás adaptar BusRouteModel.fromFirestore
      return BusRouteModel.fromFirestore(busDocSnapshot);
      // throw Exception('Ruta no encontrada para $busName');
    }
    return BusRouteModel.fromFirestore(docSnapshot);
  }

  @override
  Stream<List<BusLocationModel>> watchBusLocations(String busName) {
    // Devuelve la ubicación en tiempo real SÓLO para el busName especificado.
    return _firestore
        .collection('users')
        .where('busName', isEqualTo: busName) // Filtra por el bus específico
        .where('isSharingLocation', isEqualTo: true) // Y que esté activo
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BusLocationModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Future<void> updateUserLocation(LatLng position) async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection('users').doc(userId).update({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'lastUpdate': FieldValue.serverTimestamp(),
      'isSharingLocation': true, // Asegurarse que esté activo al actualizar
    });
  }

  @override
  Future<void> stopSharingLocation() async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection('users').doc(userId).update({
      'isSharingLocation': false, // Desactivar el seguimiento
    });
  }

  // --- NUEVO MÉTODO IMPLEMENTADO ---
  // Observa todos los documentos de 'users' que estén compartiendo ubicación.
  @override
  Stream<List<BusLocationModel>> watchAllActiveBuses() {
    return _firestore
        .collection('users')
        .where('isSharingLocation', isEqualTo: true) // Filtra solo los activos
        .snapshots() // Escucha cambios en tiempo real
        .map((snapshot) {
      // Convierte cada documento encontrado a BusLocationModel
      return snapshot.docs.map((doc) => BusLocationModel.fromFirestore(doc)).toList();
    });
  }
}