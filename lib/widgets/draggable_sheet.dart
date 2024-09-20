import 'package:flutter/material.dart';
import '../data/bus_names.dart'; // Importa la lista de buses

class DraggableSheet extends StatefulWidget {
  final Function(String busName) onBusSelected;

  DraggableSheet({required this.onBusSelected});

  @override
  _DraggableSheetState createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet> {
  List<bool> _selectedItems = List.generate(busNames.length, (index) => false); // Usa la longitud de busNames

  @override
  void initState() {
    super.initState();
    print('Number of bus names: ${busNames.length}'); // Verifica la longitud de busNames
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.1,
      maxChildSize: 1.0,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Colors.white,
          child: ListView.builder(
            controller: scrollController,
            itemCount: busNames.length, // Usa la longitud de busNames
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(busNames[index]), // Muestra el nombre del bus
                trailing: Checkbox(
                  value: _selectedItems[index],
                  onChanged: (bool? value) {
                    setState(() {
                      _selectedItems[index] = value!;
                    });
                  },
                ),
                selected: _selectedItems[index],
                onTap: () {
                  setState(() {
                    _selectedItems[index] = !_selectedItems[index];
                  });
                  widget.onBusSelected(busNames[index]);
                },
              );
            },
          ),
        );
      },
    );
  }
}
