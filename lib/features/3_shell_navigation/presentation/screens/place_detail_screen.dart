import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/core/di/service_locator.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_bloc.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_event.dart';

class PlaceDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String tag;
  final VoidCallback? onSwitchToMap;
  final LatLng? location;

  const PlaceDetailScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.tag,
    this.onSwitchToMap,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark background
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // --- HEADER IMAGE ---
              SliverAppBar(
                expandedHeight: 400.0,
                pinned: true,
                backgroundColor: const Color(0xFF1A1A1A),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                      // Gradient Overlay for text readability & merging with body
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              const Color(0xFF1A1A1A).withOpacity(0.5),
                              const Color(0xFF1A1A1A),
                            ],
                            stops: const [0.5, 0.8, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),

              // --- CONTENT ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE & RATING
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            "2024",
                            style:
                                TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.circle,
                              size: 4, color: Colors.white54),
                          const SizedBox(width: 8),
                          const Text(
                            "Hey Bus Verified",
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 14),
                          ),
                          const Spacer(),
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const Icon(Icons.star_half,
                              color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          const Text(
                            "4.8k",
                            style:
                                TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ACTION BUTTONS (Chips)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildChip(tag, isPrimary: true),
                            const SizedBox(width: 10),
                            _buildChip("Familia"),
                            const SizedBox(width: 10),
                            _buildChip("Aventura"),
                            const SizedBox(width: 10),
                            _buildChip("Naturaleza"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // MEDIA GALLERY (Video preview + Images)
                      const Text(
                        "Cómo es el lugar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 180,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _buildVideoThumbnail(imageUrl),
                            const SizedBox(width: 12),
                            _buildImageThumbnail(
                                'https://picsum.photos/300/200?random=1'),
                            const SizedBox(width: 12),
                            _buildImageThumbnail(
                                'https://picsum.photos/300/200?random=2'),
                            const SizedBox(width: 12),
                            _buildImageThumbnail(
                                'https://picsum.photos/300/200?random=3'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // DESCRIPTION
                      Text(
                        subtitle, // Using subtitle as a short intro
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Sumérgete en una experiencia única en el corazón de Cusco. Este destino ofrece una combinación perfecta de historia, gastronomía y paisajes impresionantes. Ideal para quienes buscan desconectar y disfrutar de lo auténtico.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 100), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ],
          ),

          // --- FIXED LOG ACTION BUTTON ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFF1A1A1A),
                    const Color(0xFF1A1A1A).withOpacity(0.0),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C6B22), // Steam-like green hint
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "-20%",
                      style: TextStyle(
                        color: Color(0xFFBECC23), // Lime green
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "S/. 120.00",
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "S/. 96.00",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // If coordinates are provided, focus map on them
                        if (location != null) {
                          sl<MapBloc>().add(FocusOnLocation(location!));
                        }
                        Navigator.of(context).pop(); // Close detail screen
                        onSwitchToMap?.call(); // Switch to Map tab
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF007BFF), // Vibrant Blue
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: Colors.blueAccent.withOpacity(0.5),
                      ),
                      child: const Text(
                        "LLEGAR YA",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPrimary ? Colors.blueAccent : Colors.grey.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: isPrimary ? Colors.blueAccent : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildVideoThumbnail(String imageUrl) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(String imageUrl) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
