import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;

  static bool show = false;

  const CardContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: _createCardShape(),
          child: child,
        ));
  }
}

BoxDecoration _createCardShape() => const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(25)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 5))
        ]);
