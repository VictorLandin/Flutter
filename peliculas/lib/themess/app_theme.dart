import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Colors.indigo;

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    //color primario
    primaryColor: primary,

    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.white,
      centerTitle: true,
      color: primary,
      elevation: 0
    )
  );
}
