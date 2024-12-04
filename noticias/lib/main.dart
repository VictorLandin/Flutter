import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Generado automáticamente
import 'package:noticias/share_preferences/preferences.dart';
import 'package:provider/provider.dart';
import 'package:noticias/providers/theme_provider.dart';
import 'package:noticias/services/auth_service.dart';
import 'package:noticias/services/news_service.dart';
import 'package:noticias/router/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  await Firebase.initializeApp();

  // Configurar URL de Realtime Database
  FirebaseDatabase.instance.databaseURL = 'https://noticias-trabajo-practicas-default-rtdb.europe-west1.firebasedatabase.app';

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    context.findAncestorStateOfType<_MyAppState>()?.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale(Preferences.locale);

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      Preferences.locale = locale.languageCode; // Guardar preferencia
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsService()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(isDarkMode: Preferences.isDarkMode),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'News App',
            theme: themeProvider.currentTheme,
            locale: _locale, // Usar el idioma seleccionado
            supportedLocales: const [
              Locale('en', ''), // Inglés
              Locale('es', ''), // Español
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: AppRoutes.initialRoute,
            routes: AppRoutes.getAppRoutes(),
            onGenerateRoute: AppRoutes.onGenerateRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
