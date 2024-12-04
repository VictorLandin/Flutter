import 'package:flutter/material.dart';
import '../screens/screens.dart';

class AppRoutes {
  // Ruta inicial de la aplicación
  static const String initialRoute = 'home';

  // Generador de rutas
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routes = getAppRoutes();
    final routeBuilder = routes[settings.name];

    if (routeBuilder != null) {
      return MaterialPageRoute(
        builder: routeBuilder,
        settings: settings,
      );
    }

    // Ruta por defecto si no coincide ninguna
    return MaterialPageRoute(
      builder: (context) => const TabsScreen(),
    );
  }

  // Mapa de rutas registradas
  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    return {
      initialRoute: (context) => const TabsScreen(),
      'home': (context) => const TabsScreen(),
      'login': (context) => LoginScreen(),
      'register': (context) => const RegisterScreen(),
      // Si en el futuro necesitas favoritos, descomenta esta línea:
      // 'favorite': (context) => const FavoritesScreen(),
      'settings': (context) => const SettingsScreen(),
    };
  }

  // Navegar a una ruta con reemplazo
  static void navigateToReplacement(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  // Navegar a una ruta con nueva entrada en la pila
  static void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  // Navegar eliminando todas las rutas anteriores
  static void navigateAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
          (Route<dynamic> route) => false,
    );
  }
}
