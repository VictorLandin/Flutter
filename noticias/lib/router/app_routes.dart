// To access a route from outside, use AppRoutes.getAppRoutes()[routeName]
import 'package:flutter/material.dart';

import '../screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'home';

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    return {
      initialRoute: (context) => const TabsScreen(),
      'home': (context) => const TabsScreen(),
      'login': (context) => LoginScreen(),
      'register': (context) => RegisterScreen(),
      //'favorite': (context) => const FavoritesScreen(),
      'settings': (context) => const SettingsScreen(),
    };
  }
}
