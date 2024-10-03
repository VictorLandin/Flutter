import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noticias/services/news_service.dart';
import 'package:noticias/services/notifications_service.dart';
import 'package:noticias/share_preferences/preferences.dart';
import 'package:noticias/theme/theme.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart'; // Importa tu ThemeProvider
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(isDarkMode: Preferences.isDarkMode), // Añadido el ThemeProvider
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            scaffoldMessengerKey: NotificationsService.messengerKey,
            theme: themeProvider.currentTheme, // Usa el tema actual desde el ThemeProvider
            debugShowCheckedModeBanner: false,
            title: 'Material App',
            home: const TabsScreen(),
          );
        },
      ),
    );
  }
}
