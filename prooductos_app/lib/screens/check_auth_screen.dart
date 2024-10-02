import 'package:flutter/material.dart';
import '../screens/screens.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class CheckAuthScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) {
              return const Text('Espere');
            }

            if (snapshot.data == '') {
              Future.microtask(() {
                Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => LoginScreen(),transitionDuration: const Duration(milliseconds: 0)));
              });
            } else {
              Future.microtask(() {
                Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => HomeScreen(),transitionDuration: const Duration(milliseconds: 0)));
              });
            }

            return Container();
          }
        )
      ),
    );
  }
}
