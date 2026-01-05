import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled2/firebase_options.dart';

// --- DATA DE EJEMPLO ---
// Estos son los mismos datos que tenías en `bus_list_tab.dart`
const List<Map<String, dynamic>> _busData = [
  {
    'id': 'Andinito A',
    'mainName': 'Andinito A',
    'routeIdentifier': 'Ruta A1',
    'schedule': '6 AM - 7 AM / 3 PM - 4 PM',
    'rutaCorta': 'Wanchaq -> Av. Cultura -> UNSAAC'
  },
  {
    'id': 'Andinito B',
    'mainName': 'Andinito B',
    'routeIdentifier': 'Ruta B1',
    'schedule': '12 PM - 1 PM / 8 PM - 9 PM',
    'rutaCorta': 'Plaza de Armas -> San Blas -> Recoleta'
  },
  {
    'id': 'Andinito C',
    'mainName': 'Andinito C',
    'routeIdentifier': 'Ruta C1',
    'schedule': '7 AM - 8 AM / 4 PM - 5 PM',
    'rutaCorta': 'Óvalo Pachacútec -> Santiago -> Almudena'
  },
  {
    'id': 'Andinito D',
    'mainName': 'Andinito D',
    'routeIdentifier': 'Ruta D1',
    'schedule': '11 AM - 12 PM / 6 PM - 7 PM',
    'rutaCorta': 'Mercado Huancaro -> Av. Infancia'
  },
  {
    'id': 'Andinito E',
    'mainName': 'Andinito E',
    'routeIdentifier': 'Ruta E1',
    'schedule': '9 AM - 10 AM / 5 PM - 6 PM',
    'rutaCorta': 'Magisterio -> Marcavalle -> Santa Úrsula'
  },
  {
    'id': 'Andinito F',
    'mainName': 'Andinito F',
    'routeIdentifier': 'Ruta F1',
    'schedule': '10 AM - 11 AM / 7 PM - 8 PM',
    'rutaCorta': 'San Sebastián (Paraderos 1-7)'
  },
];


/// Este script se ejecuta una sola vez para poblar la base de datos de Firestore
/// con la colección 'buses' y sus documentos iniciales.
Future<void> main() async {
  // Aseguramos la inicialización de los servicios de Flutter y Firebase.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('✅ Conectado a Firebase.');

  // Obtenemos la instancia de Firestore.
  final firestore = FirebaseFirestore.instance;

  // Usamos un 'WriteBatch' para enviar todas las operaciones en un solo lote.
  // Es más eficiente y económico que hacer una escritura por cada documento.
  final batch = firestore.batch();

  print('⏳ Preparando la colección "buses"...');

  for (final bus in _busData) {
    // Creamos una referencia al documento que queremos crear o sobreescribir.
    // Usamos el 'id' del bus como el ID del documento para fácil acceso.
    final docRef = firestore.collection('buses').doc(bus['id'] as String);

    // Añadimos la operación de 'set' al lote.
    batch.set(docRef, bus);
    print('  -> Añadiendo bus: ${bus['mainName']}');
  }

  try {
    // Enviamos el lote completo a Firestore.
    await batch.commit();
    print('\n🎉 ¡Éxito! La colección "buses" ha sido creada con ${_busData.length} documentos.');
  } catch (e) {
    print('\n❌ Ocurrió un error al intentar subir los datos: $e');
  }
}