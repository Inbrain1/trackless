import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const NavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color itemColor = isSelected ? selectedColor : unselectedColor;
    final FontWeight fontWeight = isSelected ? FontWeight.bold : FontWeight.normal;
    // Icono un poco más grande si está seleccionado (opcional)
    final double iconSize = isSelected ? 26 : 24;

    return Expanded( // Asegura que cada ítem tome el mismo espacio horizontal
      child: InkWell(
        onTap: onTap,
        // Puedes configurar splashColor y highlightColor como transparentes si no quieres el efecto visual al tocar
        // splashColor: Colors.transparent,
        // highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra icono y texto verticalmente
          children: [
            Icon(
              icon,
              color: itemColor,
              size: iconSize,
            ),
            const SizedBox(height: 4), // Espacio entre icono y texto
            Text(
              label,
              style: TextStyle(
                color: itemColor,
                fontWeight: fontWeight,
                fontSize: 12, // Tamaño de fuente del label
              ),
              maxLines: 1, // Evita que el texto se parta en dos líneas
              overflow: TextOverflow.ellipsis, // Añade '...' si el texto es muy largo
            ),
          ],
        ),
      ),
    );
  }
}