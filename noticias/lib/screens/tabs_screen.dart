import 'package:flutter/material.dart';
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
      child: const Scaffold(
        appBar: _CustomAppBar(),
        body: _Pantallas(),
        bottomNavigationBar: _Navegacion(),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Noticias'),
      actions: [
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
                    alignment: Alignment.centerRight,
                      child: _ThemeSwitch()
                  )
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) _onMenuItemSelected(context, value);
    });
  }

  String _getLoginText(BuildContext context) {
    final loggedIn = false; // Placeholder
    return loggedIn ? 'Log Out' : 'Log In';
  }

  void _onMenuItemSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        // Lógica para Log In / Log Out
        final loggedIn = false; // Placeholder
        if (loggedIn) {
          print('Logging out...');
        } else {
          print('Logging in...');
        }
        break;
      case 1:
        // Navegar a la pantalla de ajustes
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
        width: 70, // Ancho del contenedor
        height: 35, // Alto del contenedor
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), // Bordes redondeados
          color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.grey[300],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: AnimatedAlign(
            alignment: themeProvider.isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
            duration: const Duration(milliseconds: 200), // Duración de la animación
            child: Container(
              width: 28, // Ancho del círculo
              height: 28, // Alto del círculo
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentTheme.canvasColor, // Color del círculo
              ),
              child: Center(
                child: Icon(
                  themeProvider.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
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
  const _Navegacion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<_NavegacionModel>(context);
    return BottomNavigationBar(
        onTap: (i) => navegacionModel.pantallaActual = i,
        currentIndex: navegacionModel.pantallaActual,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Para ti',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Encabezados',
          ),
        ]);
  }
}

class _Pantallas extends StatelessWidget {
  const _Pantallas({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<_NavegacionModel>(context);

    return PageView(
      controller: navegacionModel.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const <Widget>[
        Tab1Screen(),
        Tab2Screen(),
      ],
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
