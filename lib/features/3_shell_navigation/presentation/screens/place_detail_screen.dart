import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/core/di/service_locator.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_bloc.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_state.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_bloc.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_event.dart';
import 'package:untitled2/features/3_shell_navigation/data/datasources/discovery_service.dart';
import 'package:untitled2/features/3_shell_navigation/data/models/discovery_card_model_new.dart';
import 'package:untitled2/screens/consumer/transport_options_screen.dart';

class PlaceDetailScreen extends StatefulWidget {
  final DiscoveryCardModel card;
  final VoidCallback? onSwitchToMap;
  final LatLng? location;

  const PlaceDetailScreen({
    super.key,
    required this.card,
    this.onSwitchToMap,
    this.location,
  });

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  final DiscoveryService _discoveryService = DiscoveryService(firestore: sl());

  Future<void> _deleteCard(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title:
            const Text('Delete Card?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete this card? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      if (widget.card.id == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Card ID is missing.')),
          );
        }
        return;
      }

      try {
        await _discoveryService.deleteDiscoveryCard(widget.card.id!);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Card deleted successfully')),
          );
          Navigator.of(context).pop(); // Return to previous screen
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting card: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate percentage if originalPrice is present
    String discountString = "";
    if (widget.card.originalPrice != null &&
        widget.card.originalPrice! > widget.card.price) {
      final discount = ((widget.card.originalPrice! - widget.card.price) /
              widget.card.originalPrice!) *
          100;
      discountString = "-${discount.toInt()}%";
    }

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
                        widget.card.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[800],
                            child: const Icon(Icons.error)),
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
                  // --- DELETE BUTTON (Development Only) ---
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state.user?.role == 'Development') {
                        return IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCard(context),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
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
                        widget.card.title,
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
                          Text(
                            widget.card.year,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 14),
                          ),
                          const SizedBox(width: 8),
                          if (widget.card.isVerified) ...[
                            const Icon(Icons.circle,
                                size: 4, color: Colors.white54),
                            const SizedBox(width: 8),
                            const Text(
                              "Hey Bus Verified",
                              style: TextStyle(
                                  color: Colors.blueAccent, fontSize: 14),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.check_circle,
                                size: 14, color: Colors.blueAccent),
                          ],
                          const Spacer(),
                          // Rating stars
                          ...List.generate(5, (index) {
                            if (index < widget.card.rating.floor()) {
                              return const Icon(Icons.star,
                                  color: Colors.amber, size: 18);
                            } else if (index < widget.card.rating &&
                                widget.card.rating % 1 != 0) {
                              return const Icon(Icons.star_half,
                                  color: Colors.amber, size: 18);
                            } else {
                              return const Icon(Icons.star_border,
                                  color: Colors.amber, size: 18);
                            }
                          }),
                          const SizedBox(width: 4),
                          Text(
                            "${widget.card.rating}k", // Just suffixing k for style if that's what user wants, or just show rating
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ACTION BUTTONS (Chips)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildChip(widget.card.tag, isPrimary: true),
                            const SizedBox(width: 10),
                            _buildChip(
                                "Familia"), // Hardcoded extra tags for now, or add tags list to model
                            const SizedBox(width: 10),
                            _buildChip(widget.card.type),
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
                            _buildVideoThumbnail(widget.card
                                .imageUrl), // Main image as video thumbnail
                            if (widget.card.galleryImages.isNotEmpty)
                              ...widget.card.galleryImages.map((img) => Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: _buildImageThumbnail(img),
                                  ))
                            else ...[
                              // Fallback static images if no gallery
                              const SizedBox(width: 12),
                              _buildImageThumbnail(
                                  'https://picsum.photos/300/200?random=1'),
                              const SizedBox(width: 12),
                              _buildImageThumbnail(
                                  'https://picsum.photos/300/200?random=2'),
                            ]
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // DESCRIPTION
                      Text(
                        widget.card.subtitle, // Using subtitle as short intro
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.card.description.isNotEmpty
                            ? widget.card.description
                            : "Sumérgete en una experiencia única...",
                        style: const TextStyle(
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
                  if (discountString.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4C6B22), // Steam-like green hint
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        discountString,
                        style: const TextStyle(
                          color: Color(0xFFBECC23), // Lime green
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  const SizedBox(width: 16),
                  if (widget.card.price > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.card.originalPrice != null &&
                            widget.card.originalPrice! > widget.card.price)
                          Text(
                            "S/. ${widget.card.originalPrice!.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12,
                            ),
                          ),
                        Text(
                          "S/. ${widget.card.price.toStringAsFixed(2)}",
                          style: const TextStyle(
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
                        // If transport options are available, navigate to full-screen selector
                        if (widget.card.transportOptions.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransportOptionsScreen(
                                transportOptions: widget.card.transportOptions,
                                discoveryCardTitle: widget.card.title,
                              ),
                            ),
                          );
                        } else {
                          // Fallback: If no transport options but coordinates are provided, focus map on them
                          if (widget.location != null) {
                            sl<MapBloc>()
                                .add(FocusOnLocation(widget.location!));
                          }
                          Navigator.of(context).pop(); // Close detail screen
                          widget.onSwitchToMap?.call(); // Switch to Map tab
                        }
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
