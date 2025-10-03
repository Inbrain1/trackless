import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerAnimationService {
  /// Añade marcadores con animación escalonada o sin animación según parámetro.
  static Future<void> animateAddMarkers({
    required Set<Marker> markers,
    required void Function(Set<Marker>) setMarkers,
    required List<LatLng> stopCoords,
    required String busName,
    int delayMs = 50,
    BitmapDescriptor? icon,
    double currentZoom = 14.0,
    bool animate = true,
  }) async {
    if (stopCoords.isEmpty || stopCoords.length < 1) {
      print("❌ stopCoords vacío o no válido. Se cancela animación.");
      return;
    }
    markers.removeWhere((m) => m.markerId.value.startsWith('checkpoint_'));
    setMarkers(Set.of(markers));

    if (currentZoom < 16.0) return;

    if (!animate) {
      for (int i = 0; i < stopCoords.length; i++) {
        if (i >= stopCoords.length) break;
        final coord = stopCoords[i];
        markers.add(
          Marker(
            markerId: MarkerId('checkpoint_${busName}_$i'),
            position: coord,
            icon: icon ?? BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: 'Paradero ${i + 1}'),
          ),
        );
      }
      setMarkers(Set.of(markers));
      return;
    }

    for (int i = 0; i < stopCoords.length; i++) {
      if (i >= stopCoords.length) break;
      await Future.delayed(Duration(milliseconds: delayMs));
      final coord = stopCoords[i];
      markers.add(
        Marker(
          markerId: MarkerId('checkpoint_${busName}_$i'),
          position: coord,
          icon: icon ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: 'Paradero ${i + 1}'),
        ),
      );
      setMarkers(Set.of(markers));
    }
  }
}