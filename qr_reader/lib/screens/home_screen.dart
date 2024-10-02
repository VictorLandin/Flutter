import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/db_provider.dart';
import 'package:qr_reader/screens/direction_history_screen.dart';
import 'package:qr_reader/screens/map_history_screen.dart';

import '../models/scan_model.dart';
import '../providers/ui_provider.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {},
          ),
        ],
      ),
      body: _HomePageBody(),
      bottomNavigationBar: CustomNavigatorBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    int currentIndex = uiProvider.selectedMenuOpt;

    final nuevoScan = ScanModel(valor: 'https://google.com');
    DBProvider.db.nuevoScan(nuevoScan);
    DBProvider.db.getScanById(1).then((scan) {
      print(scan?.valor);
    });

    switch (currentIndex) {
      case 0:
        return MapasScreen();
      case 1:
        return DireccionesScreen();
      default:
        return MapasScreen();
    }
  }
}
