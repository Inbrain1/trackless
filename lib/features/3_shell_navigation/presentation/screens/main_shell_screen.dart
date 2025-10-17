import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import BLoC
import 'package:untitled2/core/di/service_locator.dart'; // Import GetIt
import 'package:untitled2/features/2_map_view/presentation/bloc/map_bloc.dart'; // Import MapBloc
import 'package:untitled2/features/2_map_view/presentation/bloc/map_event.dart'; // Import MapEvent
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

  // --- CORRECCIÓN: Definimos las pestañas directamente ---
  // Ya no necesitan BlocProvider individual si lo ponemos aquí
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeTab(),
    const UserMapScreen(), // Quitamos el BlocProvider de aquí
    const BusListScreen(), // Esta ya no tenía BlocProvider
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- CORRECCIÓN: Proporcionamos el MapBloc aquí ---
    return BlocProvider(
      create: (_) => sl<MapBloc>()..add(LoadMap()), // Creamos el BLoC usando GetIt y cargamos el mapa
      child: Scaffold(
        body: Center(
          // Usamos IndexedStack para mantener el estado de las pestañas
          child: IndexedStack(
            index: _selectedIndex,
            children: _widgetOptions,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Mapa'),
            BottomNavigationBarItem(icon: Icon(Icons.directions_bus_outlined), label: 'Buses'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue, // Puedes ajustar el color
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}