import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        title: const Text("Descubre Cusco", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
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
              _buildDiscountsMosaic(),
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

  Widget _buildDiscountsMosaic() {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: _buildDiscountCard(
            title: "Tour Valle Sagrado",
            discount: "-30%",
            price: "S/. 85.00",
            originalPrice: "S/. 120.00",
            image: "https://picsum.photos/400/400?random=50",
            isTall: false,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: _buildDiscountCard(
            title: "Cena Show",
            discount: "-25%",
            price: "S/. 45.00",
            originalPrice: "S/. 60.00",
            image: "https://picsum.photos/400/400?random=51",
            isTall: false,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 2,
          child: _buildDiscountCard(
            title: "Expedición Salkantay",
            discount: "-50%",
            price: "S/. 250.00",
            originalPrice: "S/. 500.00",
            image: "https://picsum.photos/400/800?random=52",
            badge: "OFERTA SEMANAL",
            isTall: true,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountCard({
    required String title,
    required String discount,
    required String price,
    required String originalPrice,
    required String image,
    bool isTall = false,
    String? badge,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B2838), // Steam-like dark blue background
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Image takes up most space but leaves room for bottom info
          Positioned.fill(
            bottom: 60, // Leave space for info text
            child: Image.network(
              image,
              fit: BoxFit.cover,
            ),
          ),
          
          // Gradient Overlay on Image
          Positioned.fill(
             bottom: 60,
             child: Container(
               decoration: BoxDecoration(
                 gradient: LinearGradient(
                   begin: Alignment.topCenter,
                   end: Alignment.bottomCenter,
                   colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                 ),
               ),
             ),
          ),

          if (badge != null)
             Positioned(
               top: 12,
               left: 0,
               right: 0,
               child: Center(
                 child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                   decoration: BoxDecoration(
                     color: Colors.blueAccent.withOpacity(0.9),
                     borderRadius: BorderRadius.circular(4),
                   ),
                   child: Text(
                     badge,
                     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                   ),
                 ),
               ),
             ),

          // Bottom Info Section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Container(
              color: const Color(0xFF16202D), // Dark footer
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Row(
                children: [
                  // Green Discount Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: const Color(0xFF4C6B22), // Steam green
                    child: Text(
                      discount,
                      style: const TextStyle(
                        color: Color(0xFFBECC23), // Lime green text
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Prices
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end, // Align prices to right
                      children: [
                        Text(
                          originalPrice,
                          style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          price,
                          style: const TextStyle(
                             color: Color(0xFFBECC23), // Lime price color
                             fontWeight: FontWeight.bold,
                             fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          
          // Title Overlay (Above the footer)
          Positioned(
            bottom: 65,
            left: 10,
            right: 10,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          )
        ],
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
      {'title': 'Ruta del Barroco', 'image': 'https://picsum.photos/600/900?random=1'}, // Taller images
      {'title': 'Cafés San Blas', 'image': 'https://picsum.photos/600/900?random=2'},
      {'title': 'Mercado San Pedro', 'image': 'https://picsum.photos/600/900?random=3'},
      {'title': 'Miradores Secretos', 'image': 'https://picsum.photos/600/900?random=4'},
    ];

    return SizedBox(
      height: 420, // Increased height for elongated look
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          final item = popularItems[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                image: NetworkImage(item['image']!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.25), BlendMode.darken),
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
                            Shadow(blurRadius: 10, color: Colors.black, offset: Offset(0, 2)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Optional: Add a "Explore" or subtitle if desired
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: const Text(
                          "Ver Detalles",
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: popularItems.length,
        itemWidth: 280.0, // Fixed width for cards
        itemHeight: 420.0, // Increased height
        layout: SwiperLayout.STACK, // Stack layout gives a cool depth effect often associated with "cards"
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
                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(4), 
                         boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2))],
                       ),
                       child: Text(
                         cat['name']! as String,
                         style: TextStyle(
                           color: Colors.blue.shade900, // Deep blue text similar to steam ref
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
          image: NetworkImage('https://picsum.photos/500/300?random=${index + 10}'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
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
                    Text("4.8 (120 reviews)", style: TextStyle(color: Colors.white70)),
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
