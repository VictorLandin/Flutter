import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.pink,
      backgroundColor: const Color.fromRGBO(55, 57, 84, 1),
      unselectedItemColor: const Color.fromRGBO(116, 117, 152, 1),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Calendario'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.graphic_eq_outlined),
          label: 'Graficos'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.supervised_user_circle_outlined),
          label: 'Usuarios'
        ),
      ],
    );
  }
}
