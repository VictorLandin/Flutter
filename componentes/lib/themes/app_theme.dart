import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Colors.indigo;

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    //color primario
    primaryColor: primary,

    //appbar theme
    appBarTheme:
        const AppBarTheme(color: primary, elevation: 0, centerTitle: true, foregroundColor: Colors.white),
    //TextButton Theme
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary)),
    // FloatingActionButton Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1000)))),
    //ElevatedButton Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            shape: const StadiumBorder(),
            elevation: 0,
            foregroundColor: Colors.white)),

    //Input Theme
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: primary),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10))),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10))),
          ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      //color primario
      primaryColor: primary,
      scaffoldBackgroundColor: Colors.black,

      //appbar theme
      appBarTheme: const AppBarTheme(color: primary, elevation: 0),
      //TextButton Theme
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primary)));
}
