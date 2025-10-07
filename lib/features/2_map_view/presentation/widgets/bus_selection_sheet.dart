import 'package:flutter/material.dart';
import '../../../../delete/data/bus_names.dart'; // Importa la lista de buses

class DraggableSheet extends StatefulWidget {
  final Function(String busName) onBusSelected;
  final String? selectedBusName;

  DraggableSheet({required this.onBusSelected, required this.selectedBusName});

  @override
  _DraggableSheetState createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet> {
  @override
  void initState() {
    super.initState();
    print('Number of bus names: ${busNames.length}');
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
            itemCount: busNames.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(busNames[index]),
                trailing: Checkbox(
                  value: widget.selectedBusName == busNames[index],
                  onChanged: (bool? value) {
                    widget.onBusSelected(busNames[index]);
                  },
                ),
                selected: widget.selectedBusName == busNames[index],
                onTap: () {
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
