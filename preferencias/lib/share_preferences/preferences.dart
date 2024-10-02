
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  static late SharedPreferences _preferences;

  static String _name = '';
  static bool _isDarkMode = false;
  static int _gender = 1;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String get name => _preferences.getString('name') ?? _name;
  static set name(String value) {
    _name = value;
    _preferences.setString('name', value);
  }

  static bool get isDarkMode => _preferences.getBool('isDarkMode') ?? _isDarkMode;
  static set isDarkMode(bool value) {
    _isDarkMode = value;
    _preferences.setBool('isDarkMode', value);
  }

  static int get gender => _preferences.getInt('gender') ?? _gender;
  static set gender(int value) {
    _gender = value;
    _preferences.setInt('gender', value);
  }
}
