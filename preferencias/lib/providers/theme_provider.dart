import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeData currentTheme;

  ThemeProvider({
    required bool isDarkMode
}): currentTheme = isDarkMode ? ThemeData.dark() : ThemeData.light();

  void toggleDarkMode() {
    currentTheme = currentTheme == ThemeData.dark()
        ? ThemeData.light()
        : ThemeData.dark();
    notifyListeners();
  }
}
