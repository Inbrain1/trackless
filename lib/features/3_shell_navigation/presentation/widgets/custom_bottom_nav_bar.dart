import 'package:flutter/material.dart';
import 'nav_bar_item.dart'; // Asegúrate que este archivo exista en la misma carpeta

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  // Define los ítems aquí para fácil acceso y modificación
  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home_outlined, 'label': 'Inicio'},
    {'icon': Icons.map_outlined, 'label': 'Mapa'},
    {'icon': Icons.directions_bus_outlined, 'label': 'Buses'},
  ];

  CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Colores (puedes personalizarlos según tu tema)
    final Color backgroundColor = Colors.grey.shade100; // Fondo casi blanco
    final Color selectedColor = Colors.blue; // Azul para seleccionado
    final Color unselectedColor = Colors.grey.shade600; // Gris para no seleccionado

    // Envuelve el Container con ClipPath
    return ClipPath(
      clipper: BottomNavBarClipper(), // Usa el clipper que definimos abajo
      child: Container(
        // Ajusta la altura para dar espacio a la curva
        height: 80,
        // Padding superior para bajar los ítems y no se corten por la curva
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -3), // Sombra hacia arriba
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribuye los ítems
          crossAxisAlignment: CrossAxisAlignment.center, // Centra verticalmente los NavBarItem
          children: List.generate(_navItems.length, (index) {
            final item = _navItems[index];
            final bool isSelected = index == currentIndex;

            return NavBarItem(
              icon: item['icon'] as IconData,
              label: item['label'] as String,
              isSelected: isSelected,
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
              onTap: () => onTap(index), // Llama al callback con el índice
            );
          }),
        ),
      ),
    );
  }
}

// Clase Clipper para definir la forma curva
class BottomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double curveHeight = 20.0; // Altura de la curva (ajústala)
    final double controlPointOffset = size.width * 0.25; // Ancho de la curva (ajústala)

    // Empezar un poco más abajo para la curva
    path.moveTo(0, curveHeight);

    // Curva Bezier cuadrática izquierda
    path.quadraticBezierTo(
      controlPointOffset, // Control X1
      0,                  // Control Y1 (punto más alto)
      size.width / 2,     // Punto medio X
      0,                  // Punto medio Y (punto más alto)
    );

    // Curva Bezier cuadrática derecha
    path.quadraticBezierTo(
      size.width - controlPointOffset, // Control X2
      0,                               // Control Y2 (punto más alto)
      size.width,                      // Punto final X (esquina derecha)
      curveHeight,                     // Punto final Y (donde termina la curva)
    );

    // Líneas rectas para cerrar la forma
    path.lineTo(size.width, size.height); // Bajar por la derecha
    path.lineTo(0, size.height);        // Ir por abajo a la izquierda
    path.close();                       // Cerrar subiendo por la izquierda

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // Si la forma no cambia dinámicamente, retorna false
    return false;
  }
}