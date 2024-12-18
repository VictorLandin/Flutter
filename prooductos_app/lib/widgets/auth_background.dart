import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [const _PurpleBox(), const _HeaderIcon(), child],
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: const Icon(
          Icons.person_pin,
          size: 100,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  const _PurpleBox({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        width: double.infinity,
        height: size.height * 0.4,
        decoration: _PurpleBackground(),
        child: Stack(
          children: [
            Positioned(
              top: 90,
              left: 30,
              child: _Bubble(),
            ),
            Positioned(
              top: -40,
              left: -30,
              child: _Bubble(),
            ),
            Positioned(
              top: -50,
              right: -20,
              child: _Bubble(),
            ),
            Positioned(
              bottom: -50,
              left: 10,
              child: _Bubble(),
            ),
            Positioned(
              bottom: 120,
              right: 20,
              child: _Bubble(),
            ),
          ],
        ));
  }

  BoxDecoration _PurpleBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(63, 63, 156, 1),
          Color.fromRGBO(90, 70, 178, 1),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );
  }
}
