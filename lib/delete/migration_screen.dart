import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Importamos los buses y el modelo de tu carpeta 'delete'
import 'package:untitled2/delete/data/bus_routes.dart' as legacy_routes;
import 'package:untitled2/delete/data/bus_model.dart' as legacy_model;

class MigrationScreen extends StatefulWidget {
  const MigrationScreen({super.key});

  @override
  State<MigrationScreen> createState() => _MigrationScreenState();
}

class _MigrationScreenState extends State<MigrationScreen> {
  bool _isLoading = false;
  String _statusMessage = 'Listo para migrar los datos a Firestore.';
  double _progress = 0.0;
  int _totalBuses = legacy_routes.buses.length;

  // Función para borrar todos los buses y rutas existentes
  Future<void> _deleteOldData(FirebaseFirestore firestore, WriteBatch batch, Function(String) updateMessage) async {
    updateMessage('Borrando datos antiguos (buses)...');
    final busesSnapshot = await firestore.collection('buses').limit(500).get();
    if (busesSnapshot.docs.isNotEmpty) {
      for (var doc in busesSnapshot.docs) {
        batch.delete(doc.reference);
      }
    }

    updateMessage('Borrando datos antiguos (busRoutes)...');
    final routesSnapshot = await firestore.collection('busRoutes').limit(500).get();
    if (routesSnapshot.docs.isNotEmpty) {
      for (var doc in routesSnapshot.docs) {
        batch.delete(doc.reference);
      }
    }
  }

  // Función para subir los nuevos buses
  Future<void> _uploadNewData(FirebaseFirestore firestore, WriteBatch batch, Function(String, double) updateMessage) async {
    int count = 0;

    // Iteramos sobre la lista de buses de tu archivo 'delete/data/bus_routes.dart'
    for (final legacy_model.Bus bus in legacy_routes.buses) {
      count++;
      updateMessage(
        'Subiendo bus $count/$_totalBuses: ${bus.name}',
        count / _totalBuses,
      );

      // Convertimos la lista de LatLng a lista de GeoPoint (formato de Firestore)
      final List<GeoPoint> routeGeoPoints = bus.route
          .map((latLng) => GeoPoint(latLng.latitude, latLng.longitude))
          .toList();

      // 1. Creamos el documento en la colección 'buses' (para la lista)
      // Usamos el nombre del bus como ID del documento
      final busDocRef = firestore.collection('buses').doc(bus.name);
      batch.set(busDocRef, {
        'mainName': bus.name,
        'routeIdentifier': bus.code,
        'schedule': '6:00 AM - 10:00 PM', // Valor de relleno
        'rutaCorta': 'Ruta: ${bus.code}', // Valor de relleno
      });

      // 2. Creamos el documento en la colección 'busRoutes' (para el mapa)
      // Usamos el nombre del bus como ID del documento
      final routeDocRef = firestore.collection('busRoutes').doc(bus.name);
      batch.set(routeDocRef, {
        'name': bus.name,
        'route': routeGeoPoints, // La polilínea
        'stops': routeGeoPoints, // Usamos la ruta como paradas (puedes ajustar esto luego en Firestore)
      });

      // Firestore batch solo soporta 500 operaciones. Hacemos commit cada 490 (2 op por bus)
      if (count % 245 == 0) {
        await batch.commit();
        batch = firestore.batch(); // Inicia un nuevo batch
        updateMessage('Lote parcial subido ($count)...', count / _totalBuses);
      }
    }
    // Commit final para los buses restantes
    await batch.commit();
  }

  void _runMigration() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Iniciando migración...';
      _progress = 0.0;
    });

    final firestore = FirebaseFirestore.instance;
    var batch = firestore.batch();

    try {
      // 1. Borrar datos
      await _deleteOldData(firestore, batch, (message) {
        setState(() {
          _statusMessage = message;
        });
        print(message);
      });

      // Commit de las eliminaciones
      await batch.commit();
      batch = firestore.batch(); // Nuevo batch para las subidas

      // 2. Subir datos
      await _uploadNewData(firestore, batch, (message, progress) {
        setState(() {
          _statusMessage = message;
          _progress = progress;
        });
        print(message);
      });

      // 3. Mostrar éxito
      _statusMessage = '¡Éxito! Se subieron $_totalBuses buses a Firestore.';
      print(_statusMessage);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_statusMessage), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      _statusMessage = 'Error en la migración: $e';
      print(_statusMessage);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_statusMessage), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Migración de Datos'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Presiona el botón para borrar los buses antiguos y subir los $_totalBuses buses de la carpeta "delete/" a Firestore.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              if (_isLoading)
                Column(
                  children: [
                    LinearProgressIndicator(value: _progress),
                    const SizedBox(height: 20),
                    Text(_statusMessage),
                  ],
                )
              else
                ElevatedButton.icon(
                  onPressed: _runMigration,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Iniciar Migración'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}