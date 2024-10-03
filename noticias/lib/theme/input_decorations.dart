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
        borderSide: BorderSide(color: currentTheme.colorScheme.primary),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: currentTheme.colorScheme.primary, width: 2),
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
