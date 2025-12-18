import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart'; // Importa el paquete GNav
import 'package:untitled2/core/di/service_locator.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_bloc.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_event.dart';
import '../../../2_map_view/presentation/screens/user_map_screen.dart';
import 'home_tab.dart';
import 'bus_list_tab.dart';
import 'discovery_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions = <Widget>[
    const HomeTab(),
    const UserMapScreen(),
    BusListScreen(onSwitchToMap: () {
      _onItemTapped(1); // Cambiar a la pestaña Mapa (índice 1)
    }),
    DiscoveryScreen(onSwitchToMap: () {
      _onItemTapped(1); // Switch to Map Tab (index 1)
    }),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MapBloc>()..add(LoadMap()),
      child: Scaffold(
        extendBody: true, // Mantenemos esto
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
        bottomNavigationBar: SafeArea(
          // SafeArea afuera
          // SafeArea removed from here to allow floating effect if desired, but kept for padding logic.
          // Changed layout to support Glassmorphism
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20,
                0), // Removed bottom padding to sit closer to SafeArea
            child: Container(
              decoration: BoxDecoration(
                // No color here, we use the child for blur
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: _sigmaXY(20, 20), // Strong blur
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.5), // Semi-transparent black
                      border: Border.all(
                          color: Colors.white.withOpacity(0.12), width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 12.0),
                    child: GNav(
                      rippleColor: Colors.white.withOpacity(0.2),
                      hoverColor: Colors.white.withOpacity(0.1),
                      gap: 5, // Reduced gap further
                      activeColor: Colors.white,
                      iconSize: 26,
                      textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12), // Reduced padding further to 8
                      duration: const Duration(milliseconds: 300),
                      tabBackgroundColor: Colors.white.withOpacity(0.15),
                      color: Colors.white.withOpacity(0.6),
                      tabs: const [
                        GButton(
                          icon: Icons.home_rounded,
                          text: 'Inicio',
                          iconColor: Colors.white60,
                        ),
                        GButton(
                          icon: Icons.map_rounded,
                          text: 'Mapa',
                          iconColor: Colors.white60,
                        ),
                        GButton(
                          icon: Icons.directions_bus_rounded,
                          text: 'Buses',
                          iconColor: Colors.white60,
                        ),
                        GButton(
                          icon: Icons.explore_rounded,
                          text: 'Descubre',
                          iconColor: Colors.white60,
                        ),
                      ],
                      selectedIndex: _selectedIndex,
                      onTabChange: (index) {
                        _onItemTapped(index);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper for matrix blur
ImageFilter _sigmaXY(double x, double y) {
  return ImageFilter.blur(sigmaX: x, sigmaY: y);
}
