import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../widgets/widgets.dart';
import 'package:preferencias/share_preferences/preferences.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = 'settings';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingsScreen'),
      ),
      drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ajustes',
              style: TextStyle(fontSize: 45),
            ),
            const Divider(),
            SwitchListTile.adaptive(
              value: Preferences.isDarkMode,
              title: const Text('Dark Mode'),
              onChanged: (value) {
                Preferences.isDarkMode = value;
                final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                themeProvider.toggleDarkMode();
                setState(() {});
              },
            ),
            const Divider(),
            RadioListTile<int>(
              value: 1,
              groupValue: Preferences.gender,
              title: const Text('Masculino'),
              onChanged: (value) {
                Preferences.gender = value ?? 1;
                setState(() {});
              },
            ),
            const Divider(),
            RadioListTile<int>(
              value: 2,
              groupValue: Preferences.gender,
              title: const Text('Femenino'),
              onChanged: (value) {
                Preferences.gender = value ?? 2;
                setState(() {});
              },
            ),
            const Divider(),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  initialValue: Preferences.name,
                  decoration: const InputDecoration(
                      labelText: 'Nombre', helperText: 'Nombre del usuario'),
                  onChanged: (value) {
                    Preferences.name = value;
                    setState(() {});
                  },
                ))
          ],
        )),
      ),
    );
  }
}
