import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    required ThemeData currentTheme,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: currentTheme.colorScheme.secondary),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: currentTheme.colorScheme.secondary, width: 2),
      ),
      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle(
        color: Colors.grey,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: currentTheme.colorScheme.secondary)
          : null,
    );
  }
}
