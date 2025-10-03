import 'package:flutter/material.dart';

class AIHandler {
  // Método para mostrar el diálogo al presionar el ícono de IA
  static void showAIAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("IA Presionada"),
          content: Text("En Desarollo. PROXIMAMENTE...."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }
}