import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

  class BusLocationService {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<LatLng> getBusLocation(String busName) async {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('busName', isEqualTo: busName)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        double latitude = doc['latitude'];
        double longitude = doc['longitude'];
        return LatLng(latitude, longitude);
      } else {
        throw Exception('Bus not found');
      }
    }
  }
