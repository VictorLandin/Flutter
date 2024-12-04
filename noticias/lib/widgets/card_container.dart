import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Obtiene el tema actual

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: _createCardShape(theme),
        child: child,
      ),
    );
  }

  BoxDecoration _createCardShape(ThemeData theme) => BoxDecoration(
    color: theme.cardColor, // Usa el color del tema para el fondo
    borderRadius: const BorderRadius.all(Radius.circular(25)),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 15,
        offset: Offset(0, 5),
      ),
    ],
  );
}
