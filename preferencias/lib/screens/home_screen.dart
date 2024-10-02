import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        drawer: SideMenu(),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(),
            Text('isDarkMode: '),
            Divider(),
            Text('Genero: '),
            Divider(),
            Text('Nombre: '),
            Divider(),

          ],
        ));
  }
}
