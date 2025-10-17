import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/features/4_driver_panel/data/models/bus_model.dart';

abstract class DriverPanelDataSource {
  Future<List<BusModel>> getBusList();
  Future<void> selectBus(String busName);
}

class DriverPanelDataSourceImpl implements DriverPanelDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  DriverPanelDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  @override
  Future<List<BusModel>> getBusList() async {
    // --- MODIFICACIÓN CLAVE ---
    // Ya no usamos una lista local. Ahora consultamos la colección 'buses' de Firestore.
    try {
      final querySnapshot = await _firestore.collection('buses').orderBy('mainName').get();

      // Si no hay buses en la base de datos, devolvemos una lista vacía.
      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      // Mapeamos cada documento a nuestro BusModel.
      // Asumimos que cada documento tiene un campo 'mainName' de tipo String.
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        // Usamos el campo 'mainName' del documento para el nombre del bus.
        return BusModel(name: data['mainName'] ?? 'Nombre no encontrado');
      }).toList();

    } catch (e) {
      // Si ocurre un error durante la consulta, lo imprimimos y lanzamos una excepción.
      print('Error al obtener la lista de buses desde Firestore: $e');
      throw Exception('No se pudo cargar la lista de buses.');
    }
  }

  @override
  Future<void> selectBus(String busName) async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) {
      throw Exception('Usuario no autenticado.');
    }

    // Actualizamos el documento del usuario en Firestore con el bus seleccionado.
    await _firestore.collection('users').doc(userId).update({
      'busName': busName,
      'isSharingLocation': true, // Al seleccionar un bus, activamos el seguimiento.
    });
  }
}