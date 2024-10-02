import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasicDesignScreen extends StatelessWidget {
  const BasicDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const Image(image: AssetImage('assets/landscape.jpg')),
            Center(
              child: Column(
                children: [
                  const Title(),
                  const Buttons(),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: const Text(
                          'Phasellusnonumy malorum mi latine contentiones primis invidunt pellentesque sagittis augue ornatus ornare pro possim.  Tepercipit adhuc utinam primis accumsan explicari tristique.'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Oeschinen Lake Campground',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                'Kandersteg, Switzerland',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Expanded(child: Container()),
          const Icon(Icons.star, color: Colors.red),
          const Text('41'),
        ],
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(Colors.blue, Colors.blue, Icons.call, 'CALL'),
          _buildButtonColumn(Colors.blue, Colors.blue, Icons.near_me, 'ROUTE'),
          _buildButtonColumn(Colors.blue, Colors.blue, Icons.share, 'SHARE'),
        ],
      ),
    );
  }
}

Column _buildButtonColumn(
    Color color, Color splashColor, IconData icon, String label) {
  return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(icon),
          color: color,
          splashColor: splashColor,
          onPressed: () {
            print('pressed');
          },
        ),
        Container(
            child: Text(label,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: color,
                ))),
      ]);
}
