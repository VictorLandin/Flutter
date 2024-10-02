

import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget{
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {

  int counter = 0;

  void increase() {
   setState(() => counter++);
  }
  void reset() {
    setState(() => counter=0);
  }
  void decrease() {
  setState(() => counter--);
  }

  @override
  Widget build(BuildContext context) {

    const TextStyle fontSize30 = TextStyle( fontSize: 30);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
           child: Text('CounterScreen', style: TextStyle( color: Colors.white, fontSize: 20),),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomFloatingActions(
        increaseFn: increase, resetFn: reset, decreaseFn: decrease,),
    );
  }
}

class CustomFloatingActions extends StatelessWidget {

  final Function increaseFn;
  final Function resetFn;
  final Function decreaseFn;

  const CustomFloatingActions({
    super.key,
    required this.increaseFn,
    required this.resetFn,
    required this.decreaseFn,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => increaseFn(),
        ),

        FloatingActionButton(
          child: const Icon(Icons.circle_outlined),
          onPressed: () => resetFn(),
        ),

        FloatingActionButton(
          child: const Icon(Icons.remove),
          onPressed: () => increaseFn(),
        ),

      ],
    );
  }

}
