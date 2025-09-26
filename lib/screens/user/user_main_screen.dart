import 'package:flutter/material.dart';
import 'navigation/main_screen.dart';

class UserMainScreen extends StatelessWidget {
  const UserMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Aquí cargamos directamente el MainScreen con las pestañas
    return const MainScreen();
  }
}