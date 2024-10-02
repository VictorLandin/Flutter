import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScrollScreen extends StatelessWidget {

	final boxDecoration = const BoxDecoration(
			gradient: LinearGradient(
				begin: Alignment.topCenter,
				end: Alignment.bottomCenter,
				stops: [0.5, 0.5],
				colors: [Color(0xff79E3C4), Color(0xff30BAD6)],
			)
		);
  const ScrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
				decoration: boxDecoration,
        child: Center(
            child: PageView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: const [
            Page1(),
            Page2(),
          ],
        )),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xff30BAD6),
        child: Center(
            child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xff0098fa),
						shape: const StadiumBorder(),
						elevation: 20,
          ),
          onPressed: () {},
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Bienvenido',
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),
        )));
  }
}

class Page1 extends StatelessWidget {
  const Page1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Background(),
        MainContent(),
      ],
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
        fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white);

    return const SafeArea(
      bottom: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('11º', style: textStyle),
            Text('Miercoles', style: textStyle),
            Expanded(child: SizedBox()),
            Icon(Icons.keyboard_arrow_down_rounded,
                size: 100, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xff30BAD6),
        alignment: Alignment.topCenter,
        child: const Image(
          image: AssetImage('assets/scroll-1.png'),
        ));
  }
}
