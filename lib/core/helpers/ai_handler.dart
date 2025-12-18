import 'package:flutter/material.dart';

class AIHandler {
  // Método para mostrar el diálogo al presionar el ícono de IA
  static void showAIAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("IA Presionada"),
          content: const Text("En Desarollo. PROXIMAMENTE...."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }
}