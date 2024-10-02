import 'package:flutter/material.dart';
import 'package:mapas/src/view/fullscreenmap.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        body:  FullScreenMap(),
      ),
    );
  }
}
