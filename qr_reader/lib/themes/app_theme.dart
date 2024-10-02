import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Colors.deepPurple;
  static const Color secondary = Colors.deepPurpleAccent;
  static const Color primaryContrast = Colors.white;

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    //color primario
    primaryColor: primary,

    //appbar theme
    appBarTheme: const AppBarTheme(
        color: primary,
        elevation: 0,
        centerTitle: true,
        foregroundColor: primaryContrast),
    //TextButton Theme
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary)),
    // FloatingActionButton Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: primaryContrast,
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1000)))),
    //BottomNavigationBar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primary,
        elevation: 5,
        backgroundColor: primaryContrast,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false),
  );
}
