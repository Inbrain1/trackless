import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/features/3_shell_navigation/data/models/transport_option_model.dart';

class DiscoveryCardModel {
  final String? id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String tag;
  final String type; // e.g., 'steam_style', 'popular', 'recommended'
  final DateTime createdAt;

  // Premium fields
  final double price;
  final double? originalPrice;
  final double rating;
  final String description;
  final List<String> galleryImages;
  final String year;
  final bool isVerified;
  final bool isVideo;

  // Location & Navigation
  final double? latitude;
  final double? longitude;
  final List<String> busIds; // Deprecated - kept for backward compatibility
  final List<TransportOption> transportOptions;

  DiscoveryCardModel({
    this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tag,
    required this.type,
    required this.createdAt,
    this.price = 0.0,
    this.originalPrice,
    this.rating = 0.0,
    this.description = '',
    this.galleryImages = const [],
    this.year = '2024',
    this.isVerified = false,
    this.isVideo = false, // Default to false (image)
    this.latitude,
    this.longitude,
    this.busIds = const [],
    this.transportOptions = const [],
  });

  factory DiscoveryCardModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DiscoveryCardModel(
      id: doc.id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      tag: data['tag'] ?? '',
      type: data['type'] ?? 'steam_style',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      price: (data['price'] ?? 0.0).toDouble(),
      originalPrice: data['originalPrice'] != null
          ? (data['originalPrice'] as num).toDouble()
          : null,
      rating: (data['rating'] ?? 0.0).toDouble(),
      description: data['description'] ?? '',
      galleryImages: List<String>.from(data['galleryImages'] ?? []),
      year: data['year'] ?? '2024',
      isVerified: data['isVerified'] ?? false,
      isVideo: data['isVideo'] ?? false,
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      busIds: List<String>.from(data['busIds'] ?? []),
      transportOptions: (data['transport_options'] as List<dynamic>?)
              ?.map((item) =>
                  TransportOption.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'tag': tag,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
      'price': price,
      'originalPrice': originalPrice,
      'rating': rating,
      'description': description,
      'galleryImages': galleryImages,
      'year': year,
      'isVerified': isVerified,
      'latitude': latitude,
      'longitude': longitude,
      'busIds': busIds,
      'transport_options':
          transportOptions.map((option) => option.toMap()).toList(),
      'isVideo': isVideo,
    };
  }
}
