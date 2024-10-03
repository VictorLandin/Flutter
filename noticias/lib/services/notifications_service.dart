import 'package:flutter/material.dart';

class NotificationsService{

  static GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    if (messengerKey.currentState != null) {
      final snackBar = SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 20),
        ),
        duration: const Duration(seconds: 2),
      );

      messengerKey.currentState!.showSnackBar(snackBar);
    } else {
      // Opcional: Puedes imprimir un mensaje de error o manejarlo de otra manera
      print('Error: No hay un ScaffoldMessenger disponible para mostrar el Snackbar');
    }
  }

}
