import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';
import 'package:qr_reader/themes/app_theme.dart';

import 'screens/screens.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UiProvider()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR reader',
        initialRoute: 'home',
        routes: {
          'home': (BuildContext context) => HomeScreen(),
          'map': (BuildContext context) => MapScreen(),
        },
          theme: AppTheme.lightTheme
      ),
    );
  }
}
