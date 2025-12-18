import 'package:flutter/material.dart';

class BusListItem extends StatelessWidget {
  final int busNumber;

  const BusListItem({super.key, required this.busNumber});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Bus $busNumber'),
      leading: const Icon(Icons.directions_bus),
    );
  }
}
