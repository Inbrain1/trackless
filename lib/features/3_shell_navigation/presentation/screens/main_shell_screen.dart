import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart'; // Importa el paquete GNav
import 'package:untitled2/core/di/service_locator.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_bloc.dart';
import 'package:untitled2/features/2_map_view/presentation/bloc/map_event.dart';
import '../../../2_map_view/presentation/screens/user_map_screen.dart';
import 'home_tab.dart';
import 'bus_list_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeTab(),
    const UserMapScreen(),
    const BusListScreen(),
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
        bottomNavigationBar: SafeArea( // SafeArea afuera
          child: Padding(
            // --- AJUSTE ---
            // 1. Aumentar MÁS AÚN el padding vertical exterior para BAJAR la barra
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0.01), // Más padding vertical (era 24)
            // -------------
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0), // Padding interno del container
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(35), // Muy redondeado
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    color: Colors.black.withOpacity(.25),
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: ClipRRect( // ClipRRect para mantener la forma
                borderRadius: BorderRadius.circular(30),
                child: GNav(
                  rippleColor: Colors.grey[800]!,
                  hoverColor: Colors.grey[700]!,
                  gap: 6,
                  activeColor: Colors.white,
                  iconSize: 32, // Icono grande
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // Píldora más compacta
                  duration: const Duration(milliseconds: 300),
                  tabBackgroundColor: Colors.grey.shade800.withOpacity(0.6),
                  color: Colors.grey.shade400,
                  tabs: const [
                    GButton(
                      icon: Icons.home,
                      text: 'Inicio',
                    ),
                    GButton(
                      icon: Icons.map,
                      text: 'Mapa',
                    ),
                    GButton(
                      icon: Icons.directions_bus,
                      text: 'Buses',
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
    );
  }
}