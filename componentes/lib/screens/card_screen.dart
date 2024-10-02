import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

			class CardScreen extends StatelessWidget {

			  const CardScreen({super.key});

			  @override
			  Widget build(BuildContext context) {
			    return Scaffold(
						appBar: AppBar(
							title: const Text('Card Widget'),
						),
			      body: ListView(
							padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
							children: const [
								CustomCardType1(),
								SizedBox(height: 20,),
								CustomCardType2(imageUrl: 'https://i.natgeofe.com/n/2a832501-483e-422f-985c-0e93757b7d84/6.jpg?w=1436&h=1078', name: "Carretera",),
								SizedBox(height: 20,),
								CustomCardType2(imageUrl: 'https://cdn.prod.website-files.com/63a02e61e7ffb565c30bcfc7/65ea99845e53084280471b71_most%20beautiful%20landscapes%20in%20the%20world.webp', name: null,),
								SizedBox(height: 20,),
								CustomCardType2(imageUrl: 'https://images.photowall.com/products/59453/landscape-waterfall.jpg?h=699&q=85',),
								SizedBox(height: 100,)
							],
						)
			    );
			  }
			}
