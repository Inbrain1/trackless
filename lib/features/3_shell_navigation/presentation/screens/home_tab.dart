// lib/features/3_shell_navigation/presentation/screens/home_tab.dart

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../features/1_auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/1_auth/presentation/bloc/auth_event.dart';
import '../widgets/account_modal.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCustomHeader(context),
                const SizedBox(height: 10), // Reduced spacing
                _buildWelcomeHeader(), // Text moved to top
                const SizedBox(height: 20),
                _buildCarousel(), // Carousel below text
                const SizedBox(height: 30),
                _buildFeatureGrid(), // Feature grid at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    // Access AuthState to check for guest mode
    final authState = context.watch<AuthBloc>().state;
    final isGuest = authState.isGuest;
    final userName = isGuest ? 'Invitado' : (authState.user?.name ?? 'Ibrain'); // Fallback to Ibrain if no name
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (isGuest) {
                // Show simple login prompt for guests
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF2C2C2C),
                    title: const Text('Modo Invitado', style: TextStyle(color: Colors.white)),
                    content: const Text(
                      'Estás navegando como invitado. Inicia sesión para acceder a todas las funciones.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          // Sign out to go back to login screen (Guest is a state of auth)
                           context.read<AuthBloc>().add(SignOutRequested());
                        },
                        child: const Text('Iniciar Sesión', style: TextStyle(color: azulPrincipal)),
                      ),
                    ],
                  ),
                );
              } else {
                // Show full account modal for logged in users
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 30),
                    child: const AccountModal(),
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2), // FIX: withOpacity deprecated
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80'),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenido,',
                style: TextStyle(
                  color: textoSecundario,
                  fontSize: 14,
                ),
              ),
              Text(
                userName,
                style: const TextStyle(
                  color: textoPrincipal,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          // You can add a notification icon here if desired
          // IconButton(
          //   icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }

  // --- SECCIÓN 1: HEADER DE BIENVENIDA (TEXTO) ---
  Widget _buildWelcomeHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¡Bienvenido!',
            style: TextStyle(
              color: textoPrincipal,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Hey Bus es tu aplicación ideal para encontrar buses de transporte público.',
            style: TextStyle(color: textoSecundario, fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }

  // --- SECCIÓN 2: GRID DE FUNCIONALIDADES ---
  Widget _buildFeatureGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
        children: [
          _buildFeatureCard(
            icon: FontAwesomeIcons.locationDot,
            title: 'Ver Rutas y Paraderos',
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
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: negroTarjeta,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1), // FIX: withOpacity deprecated
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05), // FIX: withOpacity deprecated
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(icon, color: azulPrincipal, size: 24),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: textoPrincipal,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: textoSecundario,
                  fontSize: 12,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- SECCIÓN 3: CARRUSEL MEJORADO ---
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
            height: 220.0, // Taller for better impact
            autoPlay: true,
            viewportFraction: 0.9, // Wider items
            enlargeCenterPage: true,
            enlargeFactor: 0.2, // Subtle zoom
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (index, reason) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
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
                    : Colors.white24, // Softer inactive color
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
      margin:
          const EdgeInsets.symmetric(horizontal: 5), // Spacing between items
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3), // FIX: withOpacity deprecated
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        // Ensures gradient respects border radius
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.1),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.7),
                Colors.black.withValues(alpha: 0.9), // FIX: withOpacity deprecated
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.4, 0.8, 1.0],
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
                  style: const TextStyle(
                    color: textoPrincipal,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
