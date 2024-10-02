import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key});

  void displayDialogIOS(BuildContext context) {
    showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
              title: const Text('Título'),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Este es el contenido de la alerta'),
                  SizedBox(height: 10),
                  FlutterLogo(size: 100),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.red),
                    )),
              ]);
        });
  }

  void displayDialogAndroid(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Text('Titulo'),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Este es el contenido de la alerta'),
                SizedBox(height: 10),
                FlutterLogo(size: 100),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
              onPressed: () => Platform.isAndroid
                  ? displayDialogAndroid(context)
                  : displayDialogIOS(context),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text('Mostrar alerta', style: TextStyle(fontSize: 20)),
              ))),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }
}
