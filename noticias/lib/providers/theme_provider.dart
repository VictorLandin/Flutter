import 'package:flutter/material.dart';

import '../theme/theme.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeData _currentTheme;

  ThemeProvider({
    required bool isDarkMode
}): _currentTheme = isDarkMode ? ThemeData.dark() : ThemeData.light();

  get isDarkMode => _currentTheme == myThemeDark;
  get currentTheme => _currentTheme;

  void toggleDarkMode() {
    _currentTheme = _currentTheme == myThemeDark
        ? myThemeLight
        : myThemeDark;
    notifyListeners();
  }
}
