import 'package:flutter/material.dart';

final myTheme = ThemeData.dark().copyWith(
  colorScheme: ThemeData.dark().colorScheme.copyWith(
    primary: Colors.red,
    secondary: Colors.blue,
  ),
  bottomNavigationBarTheme: ThemeData.dark().bottomNavigationBarTheme.copyWith(
    selectedItemColor: Colors.red,
  ),
);
