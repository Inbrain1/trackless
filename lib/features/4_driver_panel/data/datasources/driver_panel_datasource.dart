import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/features/4_driver_panel/data/models/bus_model.dart';

// Esta es una lista temporal. Idealmente, esta lista también vendría de Firestore.
const List<String> _busNames = [
  'Saylla huasao', 'Saylla Tipon Oropesa', 'Pachacute', 'Leon de San Jeronimo',
  'Señor del Huerto', 'Nuevo Mirador', 'Cristo Blanco', 'Saylla Tipon',
  "Señor del Cabildo ", 'Patron de San Jerónimo', 'Satélite', 'EL Dorado',
  'Pegaso', 'Inka Express', 'Wimpillay', 'Liebre', 'Culumbia', 'Nuevo Amanecer',
  'Luis Vallejo Santoni', 'Imperial', 'Tupac Amaru II', 'El Chaski', 'Rápidos',
  'Servicio Rápido', 'Ttio la Florida', 'Correcaminos', 'C4M', ' Arco Iris',
  'Huancaro', 'Servicio Andino',
];


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
    // Simulamos una llamada a API retornando la lista local.
    // Esto hace que sea fácil cambiar a una fuente remota en el futuro.
    await Future.delayed(const Duration(milliseconds: 300)); // Simula latencia de red
    return _busNames.map((name) => BusModel(name: name)).toList();
  }

  @override
  Future<void> selectBus(String busName) async {
    // Obtenemos el ID del usuario actual.
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) {
      throw Exception('Usuario no autenticado.');
    }

    // Actualizamos el documento del usuario en Firestore con el bus seleccionado.
    // Esto era lo que hacía el antiguo `BusService`.
    await _firestore.collection('users').doc(userId).update({
      'busName': busName,
      'isSharingLocation': true, // Asumimos que al seleccionar un bus, empieza a compartir.
    });
  }
}