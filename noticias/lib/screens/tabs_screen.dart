import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../router/app_routes.dart';
import '../services/auth_service.dart';
import '../services/notifications_service.dart';
import '../services/news_service.dart';
import '../screens/screens.dart';

class TabsScreen extends StatelessWidget {
  const TabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _NavegacionModel(),
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          final userId = authService.currentUser?.uid;

          return Scaffold(
            appBar: const _CustomAppBar(),
            body: _Pantallas(isAuthenticated: userId != null),
            bottomNavigationBar: _Navegacion(isAuthenticated: userId != null),
          );
        },
      ),
    );
  }
}

class _Navegacion extends StatelessWidget {
  final bool isAuthenticated;

  const _Navegacion({required this.isAuthenticated, super.key});

  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<_NavegacionModel>(context);
    final localization = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      onTap: (i) => navegacionModel.pantallaActual = i,
      currentIndex: navegacionModel.pantallaActual,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline),
          label: localization.forYou,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.public),
          label: localization.headlines,
        ),
        if (isAuthenticated)
          BottomNavigationBarItem(
            icon: const Icon(Icons.star),
            label: localization.favorites,
          ),
      ],
    );
  }
}

class _Pantallas extends StatelessWidget {
  final bool isAuthenticated;

  const _Pantallas({required this.isAuthenticated, super.key});

  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<_NavegacionModel>(context);

    final pages = [
      const Tab1Screen(),
      const Tab2Screen(),
      if (isAuthenticated) const FavoritesScreen(),
    ];

    return PageView(
      controller: navegacionModel.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: pages,
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final localization = AppLocalizations.of(context)!;

    return AppBar(
      title: Text(localization.appTitle),
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
              Text(localization.guest),
            const SizedBox(width: 8),
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
    final localization = AppLocalizations.of(context)!;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          position.dx, position.dy, position.dx, position.dy),
      items: [
        PopupMenuItem(
          value: 0,
          child: Text(_getLoginText(context)),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(localization.settings),
        ),
        PopupMenuItem(
          enabled: false,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localization.darkMode),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: _ThemeSwitch(),
                ),
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
    final authService = Provider.of<AuthService>(context, listen: false);
    final localization = AppLocalizations.of(context)!;

    return authService.isAuthenticated ? localization.logOut : localization.logIn;
  }

  void _onMenuItemSelected(BuildContext context, int item) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final localization = AppLocalizations.of(context)!;

    switch (item) {
      case 0:
        if (authService.isAuthenticated) {
          await authService.logout();
          NotificationsService.showSnackbar(localization.loggedOut);
        } else {
          AppRoutes.navigateTo(context, 'login');
        }
        break;
      case 1:
        AppRoutes.navigateTo(context, 'settings');
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
        width: 60,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: currentTheme.colorScheme.primary.withOpacity(0.5),
            width: 2,
          ),
          color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.grey[300],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: AnimatedAlign(
            alignment: themeProvider.isDarkMode
                ? Alignment.centerRight
                : Alignment.centerLeft,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentTheme.canvasColor,
              ),
              child: Center(
                child: Icon(
                  themeProvider.isDarkMode
                      ? Icons.nightlight_round
                      : Icons.wb_sunny,
                  color: currentTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavegacionModel with ChangeNotifier {
  int _pantallaActual = 0;
  final PageController _pageController = PageController();

  int get pantallaActual => _pantallaActual;

  set pantallaActual(int value) {
    _pantallaActual = value;
    _pageController.animateToPage(
      value,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
    notifyListeners();
  }

  PageController get pageController => _pageController;
}
