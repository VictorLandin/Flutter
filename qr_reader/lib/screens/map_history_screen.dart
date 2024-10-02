import 'package:flutter/material.dart';

class MapasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (_, i) => ListTile(
              leading: const Icon(Icons.map),
              title: Text('Mapa $i'),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {},
            ));
  }
}
