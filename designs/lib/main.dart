import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      )
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diseños de Flutter',
      theme: ThemeData.dark(),
      initialRoute: 'home',
      routes: {
        'basic_design': (_) => const BasicDesignScreen(),
        'scroll_design': (_) => const ScrollScreen(),
        'home': (_) => const HomeScreen(),
      },

    );
  }
}

