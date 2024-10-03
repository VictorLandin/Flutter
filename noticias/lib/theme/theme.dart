import 'package:flutter/material.dart';

final myThemeDark = ThemeData.dark().copyWith(
  colorScheme: ThemeData.dark().colorScheme.copyWith(
    primary: Colors.red,
    secondary: Colors.blue,
  ),
  bottomNavigationBarTheme: ThemeData.dark().bottomNavigationBarTheme.copyWith(
    selectedItemColor: Colors.red,
  ),
);

final myThemeLight = ThemeData.light().copyWith(
  colorScheme: ThemeData.light().colorScheme.copyWith(
    primary: Colors.deepPurple,
    secondary: Colors.blue,
  ),
  bottomNavigationBarTheme: ThemeData.light().bottomNavigationBarTheme.copyWith(
    selectedItemColor: Colors.deepPurple,
  ),
);
