import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

			class FullScreenMap extends StatelessWidget {

			  const FullScreenMap({Key? key}) : super(key: key);

			  @override
			  Widget build(BuildContext context) {
			    return Scaffold(
						body: MapWidget(),
			    );
			  }
			}
