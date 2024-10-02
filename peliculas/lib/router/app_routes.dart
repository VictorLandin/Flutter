// To access a route from outside, use AppRoutes.getAppRoutes()[routeName]
import 'package:flutter/material.dart';

import '../screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'home';

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    return {
      initialRoute: (context) => const HomeScreen(),
      'details': (context) => const DetailsScreen(),
    };
  }
}
