import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/router/app_routes.dart';
import 'package:peliculas/themess/app_theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppState());


class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => MoviesProvider(), lazy: false),
    ],
    child: MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas',
        initialRoute: AppRoutes.initialRoute,
        routes: AppRoutes.getAppRoutes(),
      theme: AppTheme.lightTheme
      );
  }
}
