import 'package:flutter/material.dart';

class NotificationsService{

  static GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message){
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white, fontSize: 20),),
      duration: const Duration(seconds: 2),
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
