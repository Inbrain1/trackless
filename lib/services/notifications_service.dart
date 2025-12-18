import 'package:flutter/material.dart';

class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackbar(String message) {
    final scaffoldMessenger = messengerKey.currentState;

    if (scaffoldMessenger != null) {
      final snackBar = SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      );

      scaffoldMessenger.showSnackBar(snackBar);
    } else {
      // Manejo opcional en caso de que messengerKey.currentState sea null
      print('No se puede mostrar el SnackBar: ScaffoldMessengerState es null');
    }
  }
}
