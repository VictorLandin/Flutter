import 'package:flutter/material.dart';

class ListView2Screen extends StatelessWidget {
  final options = const [
    'Megaman',
    'Metal Gear',
    'Super Smash',
    'Final Fantasy'
  ];

  const ListView2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listview Tipo 2')),
      body: ListView.separated(
          itemBuilder: (context, index) => ListTile(
                title: Text(options[index]),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.indigo,
                ),
                onTap: () {
                  final game = options[index];
                },
              ),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: options.length),
    );
  }
}
