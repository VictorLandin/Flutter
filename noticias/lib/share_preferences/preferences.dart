import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _preferences;

  static bool _isDarkMode = false;
  static String _locale = 'en'; // Valor predeterminado del idioma

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Getter y Setter para el modo oscuro
  static bool get isDarkMode => _preferences.getBool('isDarkMode') ?? _isDarkMode;
  static set isDarkMode(bool value) {
    _isDarkMode = value;
    _preferences.setBool('isDarkMode', value);
  }

  // Getter y Setter para el idioma (locale)
  static String get locale => _preferences.getString('locale') ?? _locale;
  static set locale(String value) {
    _locale = value;
    _preferences.setString('locale', value);
  }

}
