import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Stack(children: [
        Background(),
        _HomeBody(),
      ]),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
		return const SingleChildScrollView(
      physics: BouncingScrollPhysics(),
			child: Column(
				children: [
					PageTitle(),
					CardTable(),
				],
			),

		);
  }
}
