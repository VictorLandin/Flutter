import 'package:flutter/material.dart';
import 'package:noticias/screens/screens.dart';
import 'package:provider/provider.dart';

import '../services/news_service.dart';

class TabsScreen extends StatelessWidget {
  const TabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _NavegacionModel(),
      child: const Scaffold(
        body: _Pantallas(),
        bottomNavigationBar: _Navegacion(),
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
    _pageController.animateToPage(value, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
		notifyListeners();
	}

  PageController get pageController => _pageController;
}
