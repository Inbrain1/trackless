import 'dart:io';

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

  @override
  String toString() {
    return 'BusStop(lat: $latitude, lng: $longitude, name: "$name")';
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

/// Test parsing logic without Firebase
Future<void> main() async {
  print('╔════════════════════════════════════════════════════╗');
  print('║      Bus Stops Parser Test (No Firebase)          ║');
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

    // 3. Display statistics
    print('📊 Statistics:');
    print('  Total stops parsed: ${stops.length}');
    
    // Count unique names
    final uniqueNames = stops.map((s) => s.name).toSet();
    print('  Unique stop names: ${uniqueNames.length}');

    // Find stops with duplicate names
    final nameFrequency = <String, int>{};
    for (final stop in stops) {
      nameFrequency[stop.name] = (nameFrequency[stop.name] ?? 0) + 1;
    }
    final duplicates = nameFrequency.entries.where((e) => e.value > 1).toList();
    print('  Stops with duplicate names: ${duplicates.length}');
    
    print('');

    // 4. Display first 10 stops
    print('📋 First 10 parsed stops:');
    for (int i = 0; i < 10 && i < stops.length; i++) {
      print('  ${i + 1}. ${stops[i]}');
    }
    print('');

    // 5. Display last 10 stops
    print('📋 Last 10 parsed stops:');
    final startIdx = stops.length - 10 > 0 ? stops.length - 10 : 0;
    for (int i = startIdx; i < stops.length; i++) {
      print('  ${i + 1}. ${stops[i]}');
    }
    print('');

    // 6. Show some duplicate examples if they exist
    if (duplicates.isNotEmpty) {
      print('🔄 Examples of duplicate stop names (top 5):');
      for (int i = 0; i < 5 && i < duplicates.length; i++) {
        final dup = duplicates[i];
        print('  "${dup.key}" appears ${dup.value} times');
      }
      print('');
    }

    // 7. Validate data ranges
    print('✅ Data validation:');
    final allLatValid = stops.every((s) => s.latitude >= -90 && s.latitude <= 90);
    final allLngValid = stops.every((s) => s.longitude >= -180 && s.longitude <= 180);
    final allNamesValid = stops.every((s) => s.name.isNotEmpty);

    print('  Latitude range valid (-90 to 90): ${allLatValid ? "✓" : "✗"}');
    print('  Longitude range valid (-180 to 180): ${allLngValid ? "✓" : "✗"}');
    print('  All names non-empty: ${allNamesValid ? "✓" : "✗"}');
    
    // Check if coordinates are in Cusco area
    final inCuscoArea = stops.every((s) => 
      s.latitude >= -14.0 && s.latitude <= -13.0 &&
      s.longitude >= -72.5 && s.longitude <= -71.5
    );
    print('  All coordinates in Cusco area: ${inCuscoArea ? "✓" : "✗"}');

    print('\n╔════════════════════════════════════════════════════╗');
    print('║         Parsing Test Completed Successfully!       ║');
    print('╚════════════════════════════════════════════════════╝');

    print('\n💡 Next step: Review the parsed data above.');
    print('If everything looks correct, run the full migration script:');
    print('   dart scripts/migrate_bus_stops.dart');

  } catch (e, stackTrace) {
    print('\n❌ ERROR: Parsing failed!');
    print('Error: $e');
    print('Stack trace:\n$stackTrace');
    exit(1);
  }
}
