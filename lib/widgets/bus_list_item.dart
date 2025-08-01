import 'package:flutter/material.dart';

class BusListItem extends StatelessWidget {
  final int busNumber;

  BusListItem({required this.busNumber});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Bus $busNumber'),
      leading: Icon(Icons.directions_bus),
    );
  }
}
