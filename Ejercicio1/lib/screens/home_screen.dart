

import 'package:flutter/material.dart';

class HomeScreen  extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    const TextStyle fontSize30 = TextStyle( fontSize: 30);
    int counter = 10;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
           child: Text('HomeScreen', style: TextStyle( color: Colors.white, fontSize: 30),),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Numero de clicks', style: fontSize30 ),
                  Text('$counter', style: fontSize30)],

              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          counter++;

      },
      ),
    );
  }

}
