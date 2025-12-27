/// Model for a curated transport recommendation
/// Contains a bus route and specific recommended stops (can be multiple)
class TransportOption {
  final String busId;
  final String busName;
  final List<BusStopRecommendation> recommendedStops;

  TransportOption({
    required this.busId,
    required this.busName,
    required this.recommendedStops,
  });

  factory TransportOption.fromMap(Map<String, dynamic> map) {
    final stopsData = map['recommended_stops'] as List<dynamic>?;
    return TransportOption(
      busId: map['bus_id'] ?? '',
      busName: map['bus_name'] ?? '',
      recommendedStops: stopsData
              ?.map((stop) =>
                  BusStopRecommendation.fromMap(stop as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bus_id': busId,
      'bus_name': busName,
      'recommended_stops':
          recommendedStops.map((stop) => stop.toMap()).toList(),
    };
  }
}

/// Model for a recommended bus stop within a transport option
class BusStopRecommendation {
  final String name;
  final double lat;
  final double lng;

  BusStopRecommendation({
    required this.name,
    required this.lat,
    required this.lng,
  });

  factory BusStopRecommendation.fromMap(Map<String, dynamic> map) {
    return BusStopRecommendation(
      name: map['name'] ?? '',
      lat: (map['lat'] ?? 0.0).toDouble(),
      lng: (map['lng'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lat': lat,
      'lng': lng,
    };
  }
}
