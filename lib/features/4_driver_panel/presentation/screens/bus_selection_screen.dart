import 'package:flutter/material.dart';
import '../../../../services/bus_service.dart';
import '../../../2_map_view/presentation/screens/driver_map_screen.dart';
import '../../../../data/bus_names.dart'; // Importa la lista desde el archivo bus_names.dart

class DriverScreen extends StatelessWidget {
  final BusService _busService = BusService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Buses'),
      ),
      body: ListView.builder(
        itemCount: busNames.length,
        itemBuilder: (context, index) {
          String busName = busNames[index];
          return GestureDetector(
            onTap: () async {
              await _busService.updateBusInfo(busName);
              Navigator.push(context, MaterialPageRoute(builder: (context) => DriverMapScreen()));
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.directions_bus, color: Colors.white),
                ),
                title: Text(
                  busName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward, color: Colors.blue),
              ),
            ),
          );
        },
      ),
    );
  }
}
