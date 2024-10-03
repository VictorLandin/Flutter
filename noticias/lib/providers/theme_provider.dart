import 'package:flutter/material.dart';
import 'package:noticias/share_preferences/preferences.dart';

import '../theme/theme.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeData _currentTheme;

  ThemeProvider({
    required bool isDarkMode
}): _currentTheme = isDarkMode ? myThemeDark : myThemeLight;

  get isDarkMode => _currentTheme == myThemeDark;
  ThemeData get currentTheme => _currentTheme;


  void toggleDarkMode() {
    _currentTheme = _currentTheme == myThemeDark
        ? myThemeLight
        : myThemeDark;
    Preferences.isDarkMode = _currentTheme == myThemeDark;
    notifyListeners();
  }
}
