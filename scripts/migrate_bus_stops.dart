import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Data model for a bus stop
class BusStop {
  final double latitude;
  final double longitude;
  final String name;

  BusStop({
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'location': GeoPoint(latitude, longitude),
      'name': name,
    };
  }

  @override
  String toString() {
    return 'BusStop(lat: $latitude, lng: $longitude, name: $name)';
  }
}

/// Parser for extracting bus stop data from the hardcoded format
class BusStopParser {
  // Regex pattern to extract: latitude, longitude, and stop name from comment
  // Matches: const LatLng(-13.544466, -71.986992), // 1. Luis Vallejo Santoni
  static final RegExp _pattern = RegExp(
    r'const\s+LatLng\s*\(\s*(-?\d+\.?\d*)\s*,\s*(-?\d+\.?\d*)\s*\)\s*,\s*//\s*(?:\d+\.\s*)?(.+?)(?:\s*$)',
    multiLine: true,
  );

  /// Parses the raw file content and extracts all bus stops
  static List<BusStop> parseFile(String fileContent) {
    final List<BusStop> stops = [];
    final matches = _pattern.allMatches(fileContent);

    for (final match in matches) {
      try {
        final latitude = double.parse(match.group(1)!);
        final longitude = double.parse(match.group(2)!);
        final name = match.group(3)!.trim();

        // Skip entries that are just spread operators or empty names
        if (name.isNotEmpty && !name.startsWith('...')) {
          stops.add(BusStop(
            latitude: latitude,
            longitude: longitude,
            name: name,
          ));
        }
      } catch (e) {
        print('Warning: Failed to parse line: ${match.group(0)}');
        print('Error: $e');
      }
    }

    return stops;
  }
}

/// Firestore migration utility
class FirestoreMigration {
  final FirebaseFirestore _firestore;
  final String collectionPath;
  static const int _batchSize = 500;

  FirestoreMigration({
    required FirebaseFirestore firestore,
    this.collectionPath = 'routes',
  }) : _firestore = firestore;

  /// Deletes all existing documents in the collection
  Future<void> clearCollection() async {
    print('🗑️  Deleting existing documents in "$collectionPath" collection...');

    final collection = _firestore.collection(collectionPath);
    final snapshot = await collection.get();

    if (snapshot.docs.isEmpty) {
      print('✓ Collection is already empty (${snapshot.docs.length} docs)');
      return;
    }

    print('Found ${snapshot.docs.length} documents to delete');

    // Delete in batches to avoid limits
    final batches = <WriteBatch>[];
    WriteBatch currentBatch = _firestore.batch();
    int count = 0;

    for (final doc in snapshot.docs) {
      currentBatch.delete(doc.reference);
      count++;

      if (count >= _batchSize) {
        batches.add(currentBatch);
        currentBatch = _firestore.batch();
        count = 0;
      }
    }

    // Add the last batch if it has any operations
    if (count > 0) {
      batches.add(currentBatch);
    }

    // Commit all batches
    for (int i = 0; i < batches.length; i++) {
      await batches[i].commit();
      print('Deleted batch ${i + 1}/${batches.length}');
    }

    print('✓ Successfully deleted all existing documents\n');
  }

  /// Uploads bus stops to Firestore using batches
  Future<void> uploadBusStops(List<BusStop> stops) async {
    print('📤 Uploading ${stops.length} bus stops to Firestore...');

    final collection = _firestore.collection(collectionPath);
    final batches = <WriteBatch>[];
    WriteBatch currentBatch = _firestore.batch();
    int count = 0;
    int batchNumber = 1;

    for (int i = 0; i < stops.length; i++) {
      final stop = stops[i];
      final docRef = collection.doc(); // Auto-generate ID

      currentBatch.set(docRef, stop.toFirestore());
      count++;

      // When batch is full, start a new one
      if (count >= _batchSize) {
        batches.add(currentBatch);
        print('Prepared batch $batchNumber (${count} documents)');
        currentBatch = _firestore.batch();
        count = 0;
        batchNumber++;
      }
    }

    // Add the last batch if it has any operations
    if (count > 0) {
      batches.add(currentBatch);
      print('Prepared batch $batchNumber (${count} documents)');
    }

    // Commit all batches
    print('\n⏳ Committing ${batches.length} batches to Firestore...');
    for (int i = 0; i < batches.length; i++) {
      await batches[i].commit();
      print('✓ Committed batch ${i + 1}/${batches.length}');
    }

    print('✅ Successfully uploaded all ${stops.length} bus stops!\n');
  }

  /// Verifies the upload by counting documents
  Future<void> verifyUpload(int expectedCount) async {
    print('🔍 Verifying upload...');
    final collection = _firestore.collection(collectionPath);
    final snapshot = await collection.get();

    print('Expected: $expectedCount documents');
    print('Actual: ${snapshot.docs.length} documents');

    if (snapshot.docs.length == expectedCount) {
      print('✅ Verification successful!');
    } else {
      print('⚠️  Warning: Document count mismatch!');
    }
  }
}

/// Main migration script
Future<void> main(List<String> args) async {
  print('╔════════════════════════════════════════════════════╗');
  print('║   Bus Stops Migration Script - Firestore          ║');
  print('╚════════════════════════════════════════════════════╝\n');

  try {
    // 1. Read the file
    print('📂 Reading bus routes file...');
    final filePath = 'lib/delete/data/bus_routes.dart';
    final file = File(filePath);

    if (!await file.exists()) {
      print('❌ Error: File not found at: $filePath');
      print('Current directory: ${Directory.current.path}');
      exit(1);
    }

    final fileContent = await file.readAsString();
    print('✓ File loaded successfully (${fileContent.length} characters)\n');

    // 2. Parse the data
    print('🔍 Parsing bus stop data...');
    final stops = BusStopParser.parseFile(fileContent);
    print('✓ Parsed ${stops.length} bus stops\n');

    // Display first 5 stops as preview
    print('📋 Preview of parsed data (first 5 stops):');
    for (int i = 0; i < 5 && i < stops.length; i++) {
      print('  ${i + 1}. ${stops[i]}');
    }
    print('');

    // Ask for confirmation before proceeding with Firebase
    print('⚠️  NEXT STEP: Firebase Migration');
    print('This will:');
    print('  1. Initialize Firebase');
    print('  2. Delete all existing documents in the "routes" collection');
    print('  3. Upload ${stops.length} new bus stops');
    print('');
    stdout.write('Continue with Firebase migration? (yes/no): ');
    final response = stdin.readLineSync()?.toLowerCase();

    if (response != 'yes' && response != 'y') {
      print('❌ Migration cancelled by user.');
      exit(0);
    }

    // 3. Initialize Firebase
    print('\n🔥 Initializing Firebase...');
    await Firebase.initializeApp();
    final firestore = FirebaseFirestore.instance;
    print('✓ Firebase initialized\n');

    // 4. Create migration instance
    final migration = FirestoreMigration(
      firestore: firestore,
      collectionPath: 'routes',
    );

    // 5. Clear existing data
    await migration.clearCollection();

    // 6. Upload new data
    await migration.uploadBusStops(stops);

    // 7. Verify upload
    await migration.verifyUpload(stops.length);

    print('\n╔════════════════════════════════════════════════════╗');
    print('║          Migration Completed Successfully!        ║');
    print('╚════════════════════════════════════════════════════╝');
  } catch (e, stackTrace) {
    print('\n❌ ERROR: Migration failed!');
    print('Error: $e');
    print('Stack trace:\n$stackTrace');
    exit(1);
  }
}
