import 'package:flutter/material.dart';
import 'package:noticias/services/news_service.dart';
import 'package:noticias/theme/theme.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsService(),
        ),
      ],
      child: MaterialApp(
        theme: myTheme,
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: const TabsScreen(),
      ),
    );
  }
}

