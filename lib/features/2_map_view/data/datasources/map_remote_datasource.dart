import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/features/2_map_view/data/models/bus_location_model.dart';
import 'package:untitled2/features/2_map_view/data/models/bus_route_model.dart';

abstract class MapRemoteDataSource {
  Future<BusRouteModel> getBusRouteDetails(String busName);
  Stream<List<BusLocationModel>> watchBusLocations(String busName);
  Future<void> updateUserLocation(LatLng position);
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
    final docSnapshot = await _firestore.collection('busRoutes').doc(busName).get();
    if (!docSnapshot.exists) {
      throw Exception('Ruta no encontrada para $busName');
    }
    return BusRouteModel.fromFirestore(docSnapshot);
  }

  @override
  Stream<List<BusLocationModel>> watchBusLocations(String busName) {
    return _firestore
        .collection('users')
        .where('busName', isEqualTo: busName)
        .where('isSharingLocation', isEqualTo: true)
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
    });
  }
}