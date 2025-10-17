// lib/features/3_shell_navigation/presentation/screens/home_tab.dart

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import BLoC
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_bloc.dart'; // Import AuthBloc
import 'package:untitled2/features/1_auth/presentation/bloc/auth_event.dart'; // Import AuthEvent

// DEFINIMOS LA PALETA DE COLORES EXACTA DE TU DISEÑO
const Color azulPrincipal = Color(0xFF007BFF); // Azul brillante y moderno
const Color negroFondo = Color(0xFF1A1A1A); // Un negro ligeramente suave
const Color negroTarjeta = Color(0xFF2C2C2C); // El color de las tarjetas
const Color textoPrincipal = Colors.white;
const Color textoSecundario = Colors.white70;

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _currentCarouselIndex = 0;

  final List<Map<String, String>> carouselItems = [
    {
      'imageUrl':
      'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=1200&q=80',
      'title': '¡Bienvenido a Hey Bus!',
      'subtitle': 'Encuentra tu ruta de forma rápida y sencilla',
    },
    {
      'imageUrl':
      'https://images.unsplash.com/photo-1607045914798-0a9eff3845c4?q=80&w=1174&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'title': 'Explora la Ciudad',
      'subtitle': 'Descubre nuevos lugares con nuestras rutas',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: negroFondo,
      appBar: AppBar(
        backgroundColor: negroFondo,
        elevation: 0,
        title: const Text(
          'Hey Bus',
          style: TextStyle(fontWeight: FontWeight.bold, color: textoPrincipal),
        ),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: FaIcon(FontAwesomeIcons.busSimple, color: azulPrincipal),
        ),
        // --- BOTÓN DE LOGOUT AÑADIDO AQUÍ ---
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: textoPrincipal), // Icono de logout
            tooltip: 'Cerrar Sesión', // Texto de ayuda
            onPressed: () {
              // Obtenemos el AuthBloc del contexto
              context.read<AuthBloc>().add(SignOutRequested());
              // El AppRouter se encargará de la redirección
            },
          ),
        ],
        // --- FIN DEL BOTÓN DE LOGOUT ---
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              _buildWelcomeSection(),
              const SizedBox(height: 30),
              _buildCarousel(),
              const SizedBox(height: 30),
              _buildRecommendedBusinesses(),
            ],
          ),
        ),
      ),
    );
  }

  // --- SECCIÓN 1: BIENVENIDA ---
  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¡Bienvenido!',
            style: TextStyle(
              color: textoPrincipal,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Hey Bus es tu aplicación ideal para encontrar buses de transporte público. Con nuestra app podrás:',
            style: TextStyle(color: textoSecundario, fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
            children: [
              _buildFeatureCard(
                icon: FontAwesomeIcons.locationDot,
                title: 'Ubicación en Tiempo Real',
                subtitle: 'Localiza tu bus más cercano',
              ),
              _buildFeatureCard(
                icon: FontAwesomeIcons.route,
                title: 'Planifica Rutas',
                subtitle: 'Encuentra el mejor camino',
              ),
              _buildFeatureCard(
                icon: FontAwesomeIcons.store,
                title: 'Negocios Cercanos',
                subtitle: 'Descubre establecimientos',
              ),
              _buildFeatureCard(
                icon: FontAwesomeIcons.solidStar,
                title: 'Calificaciones',
                subtitle: 'Evalúa los mejores lugares',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: negroTarjeta,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(icon, color: azulPrincipal, size: 32),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: textoPrincipal,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: textoSecundario,
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SECCIÓN 2: CARRUSEL ---
  Widget _buildCarousel() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: carouselItems.length,
          itemBuilder: (context, index, realIndex) {
            final item = carouselItems[index];
            return _buildCarouselItem(
              imageUrl: item['imageUrl']!,
              title: item['title']!,
              subtitle: item['subtitle']!,
            );
          },
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(carouselItems.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentCarouselIndex == index ? 24.0 : 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentCarouselIndex == index
                    ? azulPrincipal
                    : Colors.grey.withOpacity(0.5),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCarouselItem({
    required String imageUrl,
    required String title,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textoPrincipal,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 5.0, color: Colors.black54)],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: textoSecundario,
                  fontSize: 15,
                  shadows: [Shadow(blurRadius: 5.0, color: Colors.black54)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- SECCIÓN 3: NEGOCIOS RECOMENDADOS ---
  Widget _buildRecommendedBusinesses() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Negocios Recomendados',
            style: TextStyle(
              color: textoPrincipal,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildBusinessCard(
            imageUrl:
            'https://images.unsplash.com/photo-1528605248644-14dd04022da1?auto=format&fit=crop&w=400&q=80',
            name: 'Cafetería Central',
            category: 'Café • Breakfast',
            rating: 4.5,
            reviews: 128,
          ),
          _buildBusinessCard(
            imageUrl:
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=400&q=80',
            name: 'Restaurante La Estación',
            category: 'Comida Internacional',
            rating: 4.8,
            reviews: 245,
          ),
          _buildBusinessCard(
            imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTK6reMhIr4SZa5clXg6UD4TvCeIEjXEqyq2ydAEeXZwcCJZoJNOKI24EA0HtcTl2imz_M&usqp=CAU',
            name: 'Super Ahorro',
            category: 'Supermercado • 24h',
            rating: 4.0,
            reviews: 89,
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessCard({
    required String imageUrl,
    required String name,
    required String category,
    required double rating,
    required int reviews,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: negroTarjeta,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[800],
                  child: const Icon(FontAwesomeIcons.image, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: textoPrincipal,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  category,
                  style: const TextStyle(color: textoSecundario, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.solidStar,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$rating',
                      style: const TextStyle(
                        color: textoPrincipal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '($reviews)',
                      style: const TextStyle(color: textoSecundario),
                    ),
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