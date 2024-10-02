import 'package:flutter/material.dart';

			class AvatarScreen extends StatelessWidget {

			  const AvatarScreen({super.key});

			  @override
			  Widget build(BuildContext context) {
			    return Scaffold(
			      appBar: AppBar(
			        title: const Text('Stan Lee'),
							actions: [
								Container(
									margin: const EdgeInsets.only(right: 5),
								  child: CircleAvatar(
								  	backgroundColor: Colors.indigo[900],
										foregroundColor: Colors.white,
								  	child: const Text('SL'),
								  ),
								)
							],
			      ),
			      body: const Center(
			         child: CircleAvatar(
								 maxRadius: 110,
								 backgroundImage: NetworkImage('https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSd26ch-MdWqVQQQl62BnDneJFrAdAnDvm_PVFZVrenIwYKLedn'),
							 )
			      ),
			    );
			  }
			}
