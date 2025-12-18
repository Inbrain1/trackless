import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'place_detail_screen.dart';

class DiscoveryScreen extends StatelessWidget {
  final VoidCallback? onSwitchToMap;

  const DiscoveryScreen({super.key, this.onSwitchToMap});

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
              _buildSteamStyleOffers(context),
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

  Widget _buildSteamStyleOffers(BuildContext context) {
    return SizedBox(
      height: 300, // Fixed height for horizontal scroll
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          // GROUP 1
          _buildSteamGroup(
            bigItem: _buildSteamCard(
              imageUrl:
                  'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=800&q=80',
              title: 'Cena Romántica',
              subtitle: '20% OFF en Restaurante Central',
              tag: 'Oferta',
              isBig: true,
              context: context,
            ),
            smallItem1: _buildSteamCard(
              imageUrl:
                  'https://images.unsplash.com/photo-1544148103-0773bf10d330?auto=format&fit=crop&w=400&q=80',
              title: 'Café Gratis',
              subtitle: 'Por compra > \$10',
              tag: 'Promo',
              isBig: false,
              context: context,
            ),
            smallItem2: _buildSteamCard(
              imageUrl:
                  'https://images.unsplash.com/photo-1574680096145-d05b474e2155?auto=format&fit=crop&w=400&q=80',
              title: 'Gym Pass',
              subtitle: 'Clase de prueba gratis',
              tag: 'Evento',
              isBig: false,
              context: context,
            ),
          ),
          const SizedBox(width: 16),
          // GROUP 2
          _buildSteamGroup(
            bigItem: _buildSteamCard(
              imageUrl:
                  'https://images.unsplash.com/photo-1493770348161-369560ae357d?auto=format&fit=crop&w=800&q=80',
              title: 'Menú Ejecutivo',
              subtitle: 'Almuerzos desde \$15',
              tag: 'Diario',
              isBig: true,
              context: context,
            ),
            smallItem1: _buildSteamCard(
              imageUrl:
                  'https://picsum.photos/400/400?random=101', // Fixed broken URL
              title: 'Co-Working',
              subtitle: 'Day Pass 50% OFF',
              tag: 'Descuento',
              isBig: false,
              context: context,
            ),
            smallItem2: _buildSteamCard(
              imageUrl:
                  'https://picsum.photos/400/400?random=102', // Fixed broken URL
              title: 'Feria Libro',
              subtitle: 'Entrada Libre',
              tag: 'Evento',
              isBig: false,
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSteamGroup({
    required Widget bigItem,
    required Widget smallItem1,
    required Widget smallItem2,
  }) {
    return SizedBox(
      height: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Large Card
          SizedBox(
            width: 260,
            height: 300,
            child: bigItem,
          ),
          const SizedBox(width: 8),
          // Column of 2 Small Cards
          SizedBox(
            width: 160,
            child: Column(
              children: [
                Expanded(child: smallItem1),
                const SizedBox(height: 8),
                Expanded(child: smallItem2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSteamCard({
    required String imageUrl,
    required String title,
    required String subtitle,
    required String tag,
    required bool isBig,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaceDetailScreen(
              imageUrl: imageUrl,
              title: title,
              subtitle: subtitle,

              tag: tag,
              onSwitchToMap: onSwitchToMap,
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
            image: NetworkImage(imageUrl),
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
                  tag,
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
                    title,
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
                    subtitle,
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
    final popularItems = [
      {
        'title': 'Ruta del Barroco',
        'image': 'https://picsum.photos/600/900?random=1'
      }, // Taller images
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
      height: 420, // Increased height for elongated look
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          final item = popularItems[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PlaceDetailScreen(
                    imageUrl: item['image']!,
                    title: item['title']!,
                    subtitle: 'Destino popular en Cusco',
                    tag: 'Popular',
                    onSwitchToMap: onSwitchToMap,
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
                        // Optional: Add a "Explore" or subtitle if desired
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
        itemWidth: 280.0, // Fixed width for cards
        itemHeight: 420.0, // Increased height
        layout: SwiperLayout
            .STACK, // Stack layout gives a cool depth effect often associated with "cards"
        // Alternatively use DEFAULT with viewportFraction
        // layout: SwiperLayout.DEFAULT,
        // viewportFraction: 0.75,
        // scale: 0.9,
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
