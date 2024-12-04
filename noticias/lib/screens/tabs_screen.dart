import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:noticias/router/app_routes.dart';
import 'package:noticias/services/auth_service.dart';
import 'package:noticias/services/notifications_service.dart';
import 'package:provider/provider.dart';
import '../services/news_service.dart';
import '../providers/theme_provider.dart';
import '../screens/screens.dart'; // Importar la pantalla de ajustes y otras si es necesario

class TabsScreen extends StatelessWidget {
  const TabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _NavegacionModel(),
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          final userId = authService.currentUser?.uid;

          return FutureBuilder<DataSnapshot>(
            future: FirebaseDatabase.instance.ref('users/$userId/favorites').get(),
            builder: (context, snapshot) {
              bool hasFavorites = false;
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data!.value != null) {
                hasFavorites = (snapshot.data!.value as Map).isNotEmpty;
              }

              return Scaffold(
                appBar: const _CustomAppBar(),
                body: _Pantallas(hasFavorites: hasFavorites),
                bottomNavigationBar: _Navegacion(hasFavorites: hasFavorites),
              );
            },
          );
        },
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return AppBar(
      title: const Text('Noticias'),
      actions: [
        Row(
          children: [
            if (authService.isAuthenticated)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  authService.currentUserName,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            else
              const Text('Invitado'),
            GestureDetector(
              onTapDown: (details) => _showMenu(context, details.globalPosition),
              child: const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showMenu(BuildContext context, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          position.dx, position.dy, position.dx, position.dy),
      items: [
        PopupMenuItem(
          value: 0,
          child: Text(_getLoginText(context)),
        ),
        const PopupMenuItem(
          value: 1,
          child: Text('Ajustes'),
        ),
        PopupMenuItem(
          enabled: false,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Cambiar tema'),
              Expanded(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.centerRight, child: _ThemeSwitch())),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) _onMenuItemSelected(context, value);
    });
  }

  String _getLoginText(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return authService.isAuthenticated ? 'Log Out' : 'Log In';
  }


  void _onMenuItemSelected(BuildContext context, int item) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    switch (item) {
      case 0:
        if (authService.isAuthenticated) {
          // Log Out
          await authService.logout();
          NotificationsService.showSnackbar('Has cerrado sesión');
        } else {
          // Log In
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
        break;
      case 1:
      // Navegar a Ajustes
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
        break;
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ThemeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: () {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleDarkMode();
      },
      child: Container(
        width: 60, // Ancho del contenedor
        height: 35, // Alto del contenedor
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), // Bordes redondeados
          border: Border.all(
            color: currentTheme.colorScheme.primary.withOpacity(0.5),
            width: 2,
          ), //borde para imitar al borde de un switch
          color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.grey[300],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: AnimatedAlign(
            alignment: themeProvider.isDarkMode
                ? Alignment.centerRight
                : Alignment.centerLeft,
            duration:
                const Duration(milliseconds: 200), // Duración de la animación
            child: Container(
              width: 28, // Ancho del círculo
              height: 28, // Alto del círculo
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentTheme.canvasColor, // Color del círculo
              ),
              child: Center(
                child: Icon(
                  themeProvider.isDarkMode
                      ? Icons.nightlight_round
                      : Icons.wb_sunny,
                  color: currentTheme.colorScheme.primary,
                  size: 20, // Tamaño del ícono dentro del círculo
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Navegacion extends StatelessWidget {
  final bool hasFavorites;

  const _Navegacion({required this.hasFavorites, super.key});

  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<_NavegacionModel>(context);

    return BottomNavigationBar(
      onTap: (i) => navegacionModel.pantallaActual = i,
      currentIndex: navegacionModel.pantallaActual,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Para ti',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.public),
          label: 'Encabezados',
        ),
        if (hasFavorites)
          const BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favoritos',
          ),
      ],
    );
  }
}

class _Pantallas extends StatelessWidget {
  final bool hasFavorites;

  const _Pantallas({required this.hasFavorites, super.key});

  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<_NavegacionModel>(context);

    final pages = [
      const Tab1Screen(),
      const Tab2Screen(),
      if (hasFavorites) const FavoritesScreen(),
    ];

    return PageView(
      controller: navegacionModel.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: pages,
    );
  }
}

class _NavegacionModel with ChangeNotifier {
  int _pantallaActual = 0;
  final PageController _pageController = PageController();

  int get pantallaActual => _pantallaActual;

  set pantallaActual(int value) {
    _pantallaActual = value;
    _pageController.animateToPage(value,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    notifyListeners();
  }

  PageController get pageController => _pageController;
}
