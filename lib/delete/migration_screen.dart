import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;

class MigrationScreen extends StatefulWidget {
  const MigrationScreen({super.key});

  @override
  State<MigrationScreen> createState() => _MigrationScreenState();
}

class _MigrationScreenState extends State<MigrationScreen> {
  bool _isLoading = false;
  String _statusMessage = 'Listo para migrar los datos a Firestore.';
  double _progress = 0.0;
  
  // Use the exact path as defined in pubspec.yaml
  final String _jsonAssetPath = 'lib/delete/data/full_bus_routes copy.json';

  Future<void> _deleteOldData(FirebaseFirestore firestore, WriteBatch batch, Function(String) updateMessage) async {
    updateMessage('Borrando datos antiguos (busRoutes)...');
    
    // We only need to clean busRoutes as per requirements, but cleaning buses is also good practice if we are rebuilding.
    // However, the prompt specifically asks to overwrite/update existing entries.
    // Deleting first ensures no stale data remains.
    
    final routesSnapshot = await firestore.collection('busRoutes').limit(500).get();
    if (routesSnapshot.docs.isNotEmpty) {
      for (var doc in routesSnapshot.docs) {
        batch.delete(doc.reference);
      }
    }
  }

  Future<void> _runMigration() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Iniciando migración...';
      _progress = 0.0;
    });

    final firestore = FirebaseFirestore.instance;
    var batch = firestore.batch();

    try {
      // 1. Load JSON file
      _updateStatus('Leyendo archivo JSON...');
      // Note: Ensure the path matches your pubspec.yaml assets entry
      final String jsonString = await rootBundle.loadString(_jsonAssetPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      
      final int totalRoutes = jsonList.length;
      _updateStatus('Archivo leído. Encontradas $totalRoutes rutas.');

      // 2. Prepare for Batch Processing
      int processedCount = 0;
      int batchOperationCount = 0;
      int successCount = 0;

      for (var i = 0; i < totalRoutes; i++) {
        final routeData = jsonList[i];
        processedCount++;
        
        final String name = routeData['name']?.toString() ?? '';
        final String code = routeData['code']?.toString() ?? '';
        final List<dynamic> routePoints = routeData['route'] ?? [];
        
        // Report progress periodically to avoid UI flooding
        if (processedCount % 5 == 0 || processedCount == 1) {
           _updateStatus('Procesando ruta $processedCount/$totalRoutes: $name', processedCount / totalRoutes);
        }

        if (name.isEmpty) {
          print('WARNING: Skipping route at index $i due to missing name.');
          continue;
        }

        // 3. Map Data (Stops & Polyline)
        List<Map<String, dynamic>> stopsList = [];
        List<GeoPoint> polylinePoints = [];

        for (var point in routePoints) {
          final String pointName = point['name']?.toString() ?? '';
          final Map<String, dynamic> location = point['location'] ?? {};
          
          // Safer casting
          double? lat = (location['lat'] is num) ? (location['lat'] as num).toDouble() : null;
          double? lng = (location['lng'] is num) ? (location['lng'] as num).toDouble() : null;

          if (lat != null && lng != null) {
            stopsList.add({
              'name': pointName,
              'lat': lat,
              'lng': lng,
            });
            polylinePoints.add(GeoPoint(lat, lng));
          }
        }

        if (stopsList.isEmpty) {
           print('WARNING: Route "$name" has no valid stops/locations. Skipping.');
           continue;
        }

        // 4. Create Document Reference & Data
        final docRef = firestore.collection('busRoutes').doc(name);
        
        final Map<String, dynamic> docData = {
          'name': name,
          'code': code,
          'stops': stopsList, // Requirement: Array of objects
          'route': polylinePoints, // Polyline for map
          'lastUpdated': FieldValue.serverTimestamp(),
        };

        batch.set(docRef, docData);
        batchOperationCount++;
        successCount++;

        // 5. Commit Batch periodically (limit is 500, we use 400 for safety)
        if (batchOperationCount >= 400) {
          print('Committing partial batch of $batchOperationCount operations...');
          await batch.commit();
          batch = firestore.batch(); // Create new batch
          batchOperationCount = 0;
        }
      }

      // Final Commit for remaining docs
      if (batchOperationCount > 0) {
        print('Committing final batch of $batchOperationCount operations...');
        await batch.commit();
      }
      
      _updateStatus('¡Completado! $successCount/$totalRoutes rutas migradas exitosamente.', 1.0);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text('Migración finalizada. $successCount rutas subidas.'), 
             backgroundColor: Colors.green
           ),
        );
      }

    } catch (e, stackTrace) {
      print('CRITICAL ERROR: $e');
      print(stackTrace);
      _updateStatus('Error crítico: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateStatus(String message, [double? progress]) {
    setState(() {
      _statusMessage = message;
      if (progress != null) {
        _progress = progress;
      }
    });
    print(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Migración de Datos JSON'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Presiona el botón para migrar los datos desde "full_bus_routes copy.json" a Firestore.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                'Importante: Reinicia la app si acabas de agregar el archivo a assets.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
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
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Iniciar Migración JSON'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
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