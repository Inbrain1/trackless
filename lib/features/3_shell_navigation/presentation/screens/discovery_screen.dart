import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled2/core/di/service_locator.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_bloc.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_state.dart';
import 'package:untitled2/features/3_shell_navigation/data/datasources/discovery_service.dart';
import 'package:untitled2/features/3_shell_navigation/data/models/discovery_card_model_new.dart';
import 'package:untitled2/features/3_shell_navigation/presentation/screens/create_card_screen.dart';
import 'place_detail_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  final VoidCallback? onSwitchToMap;

  const DiscoveryScreen({super.key, this.onSwitchToMap});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final DiscoveryService _discoveryService = DiscoveryService(firestore: sl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        title: const Text("Descubre Cusco",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {}),
        ],
      ),
      floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.user?.role == 'Development') {
            return FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color(0xFF1A1A1A),
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (ctx) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading:
                            const Icon(Icons.add_card, color: Colors.white),
                        title: const Text('Create New Card',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const CreateCardScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              backgroundColor: Colors.amber,
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text('Nueva Tarjeta',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Lo más popular"),
              const SizedBox(height: 16),
              _buildPopularCarousel(),
              const SizedBox(height: 30),
              _buildSectionTitle("Explorar por Categoría"),
              const SizedBox(height: 16),
              _buildSteamCategories(),
              const SizedBox(height: 30),
              _buildSectionTitle("Descuentos y Eventos"),
              const SizedBox(height: 16),
              _buildDynamicSteamStyleOffers(context),
              const SizedBox(height: 30),
              _buildSectionTitle("Lugares Recomendados"),
              const SizedBox(height: 16),
              _buildRecommendedList(),
            ],
          ),
        ),
      ),
    );
  }

  // --- COLOR PALETTE (Matched to previous design) ---
  static const Color azulPrincipal = Color(0xFF007BFF);
  static const Color negroTarjeta = Color(0xFF2C2C2C);
  static const Color textoPrincipal = Colors.white;
  static const Color textoSecundario = Colors.white70;

  Widget _buildDynamicSteamStyleOffers(BuildContext context) {
    return StreamBuilder<List<DiscoveryCardModel>>(
      stream: _discoveryService.getDiscoveryCards(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error al cargar ofertas',
              style: TextStyle(color: Colors.white));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final cards = snapshot.data ?? [];
        if (cards.isEmpty) {
          return const Text('No hay ofertas disponibles',
              style: TextStyle(color: Colors.white70));
        }

        // Logic to group cards for the Steam style layout
        // For simplicity in this demo, we'll just show them in a horizontal list
        // preserving the card style but without the complex group logic for now
        // or we can try to adapt it if we have at least 3 cards.

        return SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: SizedBox(
                  width: 260, // Fixed width for individual cards in list
                  child: _buildSteamCard(
                    card: card,
                    isBig:
                        true, // Make them all 'big' style for uniformity in this dynamic list
                    context: context,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSteamCard({
    required DiscoveryCardModel card,
    required bool isBig,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaceDetailScreen(
              card: card,
              onSwitchToMap: widget.onSwitchToMap,
              location:
                  const LatLng(-13.5170887, -71.9785356), // Sample location
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: negroTarjeta,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(card.imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            // Gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Tag
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: azulPrincipal.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  card.tag,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            // Text Content
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isBig ? 20 : 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isBig ? 4 : 2),
                  Text(
                    card.subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    maxLines: isBig ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

// ... (existing imports)

  Widget _buildPopularCarousel() {
    return StreamBuilder<List<DiscoveryCardModel>>(
      stream: _discoveryService.getDiscoveryCards(),
      builder: (context, snapshot) {
        // Fallback or Loading
        if (!snapshot.hasData) {
          return const SizedBox(
              height: 420, child: Center(child: CircularProgressIndicator()));
        }

        // Filter specifically for carousel items
        final carouselCards =
            snapshot.data!.where((card) => card.type == 'carousel').toList();

        // If no dynamic cards, show default placeholder items
        if (carouselCards.isEmpty) {
          return _buildDefaultCarousel();
        }

        return SizedBox(
          height: 420,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              final card = carouselCards[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlaceDetailScreen(
                        card: card,
                        onSwitchToMap: widget.onSwitchToMap,
                        location: const LatLng(-13.516801, -71.977463),
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      image: NetworkImage(card.imageUrl),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.25), BlendMode.darken),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 25,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                      blurRadius: 10,
                                      color: Colors.black,
                                      offset: Offset(0, 2)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white30),
                              ),
                              child: const Text(
                                "Ver Detalles",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: carouselCards.length,
            itemWidth: 280.0,
            itemHeight: 420.0,
            layout: SwiperLayout.STACK,
          ),
        );
      },
    );
  }

  Widget _buildDefaultCarousel() {
    final popularItems = [
      {
        'title': 'Ruta del Barroco',
        'image': 'https://picsum.photos/600/900?random=1'
      },
      {
        'title': 'Cafés San Blas',
        'image': 'https://picsum.photos/600/900?random=2'
      },
      {
        'title': 'Mercado San Pedro',
        'image': 'https://picsum.photos/600/900?random=3'
      },
      {
        'title': 'Miradores Secretos',
        'image': 'https://picsum.photos/600/900?random=4'
      },
    ];

    return SizedBox(
      height: 420,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          final item = popularItems[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PlaceDetailScreen(
                    card: DiscoveryCardModel(
                      title: item['title']!,
                      subtitle: 'Destino popular en Cusco',
                      imageUrl: item['image']!,
                      tag: 'Popular',
                      type: 'popular',
                      createdAt: DateTime.now(),
                      price: 0,
                      rating: 4.8,
                      description:
                          'Descubre los lugares más populares de Cusco.',
                    ),
                    onSwitchToMap: widget.onSwitchToMap,
                    location: const LatLng(
                        -13.516801, -71.977463), // Saqsaywaman approx
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: NetworkImage(item['image']!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.25), BlendMode.darken),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 25,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  blurRadius: 10,
                                  color: Colors.black,
                                  offset: Offset(0, 2)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: const Text(
                            "Ver Detalles",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: popularItems.length,
        itemWidth: 280.0,
        itemHeight: 420.0,
        layout: SwiperLayout.STACK,
      ),
    );
  }

  Widget _buildSteamCategories() {
    final categories = [
      {
        'name': 'GASTRONOMÍA',
        'images': [
          'https://picsum.photos/150/150?random=10',
          'https://picsum.photos/150/150?random=11',
          'https://picsum.photos/150/150?random=12',
          'https://picsum.photos/150/150?random=13',
        ],
        'color': Colors.blueAccent
      },
      {
        'name': 'HISTORIA',
        'images': [
          'https://picsum.photos/150/150?random=20',
          'https://picsum.photos/150/150?random=21',
          'https://picsum.photos/150/150?random=22',
          'https://picsum.photos/150/150?random=23',
        ],
        'color': Colors.amberAccent
      },
      {
        'name': 'AVENTURA',
        'images': [
          'https://picsum.photos/150/150?random=30',
          'https://picsum.photos/150/150?random=31',
          'https://picsum.photos/150/150?random=32',
          'https://picsum.photos/150/150?random=33',
        ],
        'color': Colors.greenAccent
      },
      {
        'name': 'NOCTURNA',
        'images': [
          'https://picsum.photos/150/150?random=40',
          'https://picsum.photos/150/150?random=41',
          'https://picsum.photos/150/150?random=42',
          'https://picsum.photos/150/150?random=43',
        ],
        'color': Colors.purpleAccent
      },
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final images = cat['images'] as List<String>;
          final color = cat['color'] as Color;

          return Container(
            width: 240, // Slightly wider for collage
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[900],
            ),
            clipBehavior: Clip.antiAlias, // Clip children to border radius
            child: Stack(
              children: [
                // Collage Background
                _buildCollageBackground(images),

                // Gradient Overlay (Blue/Teal tinted)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.withOpacity(0.3), // Light tint top
                        Colors.blue.shade900.withOpacity(0.8), // Darker bottom
                      ],
                    ),
                  ),
                ),

                // Pill Label
                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black45,
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ],
                      ),
                      child: Text(
                        cat['name']! as String,
                        style: TextStyle(
                          color: Colors.blue
                              .shade900, // Deep blue text similar to steam ref
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCollageBackground(List<String> images) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: Image.network(images[0], fit: BoxFit.cover)),
              Expanded(child: Image.network(images[1], fit: BoxFit.cover)),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: Image.network(images[2], fit: BoxFit.cover)),
              Expanded(child: Image.network(images[3], fit: BoxFit.cover)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedList() {
    // Placeholder items
    return Column(
      children: List.generate(3, (index) => _buildPlaceCard(index)),
    );
  }

  Widget _buildPlaceCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(
              'https://picsum.photos/500/300?random=${index + 10}'),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Negocio Destacado ${index + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text("4.8 (120 reviews)",
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
