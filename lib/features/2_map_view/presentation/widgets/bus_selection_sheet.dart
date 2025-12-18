import 'package:flutter/material.dart';
import '../../../../delete/data/bus_names.dart'; // Importa la lista de buses

class BusSelectionSheet extends StatefulWidget {
  final Function(String busName) onBusSelected;
  final String? selectedBusName;

  const BusSelectionSheet({super.key, required this.onBusSelected, required this.selectedBusName});

  @override
  _BusSelectionSheetState createState() => _BusSelectionSheetState();
}

class _BusSelectionSheetState extends State<BusSelectionSheet> {
  // Mantengo initState para referencia, aunque la impresión no es necesaria en producción.
  @override
  void initState() {
    super.initState();
    print('Number of bus names: ${busNames.length}');
  }

  @override
  Widget build(BuildContext context) {
    // Usaremos un tema para obtener el color primario para el ícono de bus.
    final Color selectedColor = Theme.of(context).primaryColor;
    final Color unselectedColor = Colors.grey.shade600;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.1,
      maxChildSize: 1.0,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          // Se añade un borde redondeado y un manejador visual para el usuario
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Manija (handle) para indicar que es deslizable
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // Título
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  widget.selectedBusName == null
                      ? 'Selecciona una ruta para seguir'
                      : 'Ruta actual: ${widget.selectedBusName} (Tap para ocultar)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.selectedBusName == null ? Colors.black87 : selectedColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: busNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String busName = busNames[index];
                    final bool isSelected = widget.selectedBusName == busName;

                    return ListTile(
                      // Eliminación del Checkbox
                      // Uso de un ícono de bus con color condicional
                      leading: Icon(
                        Icons.directions_bus,
                        color: isSelected ? selectedColor : unselectedColor,
                      ),
                      title: Text(
                        busName,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? selectedColor : Colors.black87,
                        ),
                      ),
                      // El ícono de flecha ayuda a la usabilidad
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: selectedColor)
                          : Icon(Icons.chevron_right, color: unselectedColor),
                      selected: isSelected,
                      onTap: () {
                        // Al hacer tap, se llama a la función para seleccionar/deseleccionar
                        widget.onBusSelected(busName);
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}