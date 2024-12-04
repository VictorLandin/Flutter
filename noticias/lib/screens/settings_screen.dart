import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:noticias/main.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final localization = AppLocalizations.of(context)!;
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Cambiar Tema
          ListTile(
            title: Text(localization.darkMode),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleDarkMode(),
            ),
          ),
          const Divider(),

          // Cambiar Idioma
          ListTile(
            title: Text(localization.language),
            trailing: DropdownButton<String>(
              value: Localizations.localeOf(context).languageCode,
              items: const [
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: 'es',
                  child: Text('Español'),
                ),
              ],
              onChanged: (String? languageCode) {
                if (languageCode != null) {
                  final newLocale = Locale(languageCode);
                  MyApp.setLocale(context, newLocale); // Cambiar idioma
                }
              },
            ),
          ),
          const Divider(),

          // Borrar Cuenta
          ListTile(
            enabled: authService.isAuthenticated,
            title: Text(localization.deleteAccount),
            subtitle: Text(localization.deleteAccountSubtitle),
            onTap: () => _confirmDeleteAccount(context, localization),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context, AppLocalizations localization) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        bool isConfirmButtonEnabled = false;

        return StatefulBuilder(
          builder: (context, setState) {
            Timer(const Duration(seconds: 5), () {
              if (isConfirmButtonEnabled == false) {
                setState(() {
                  isConfirmButtonEnabled = true;
                });
              }
            });

            return SingleChildScrollView(
              child: AlertDialog(
                title: Text(localization.confirmDelete),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(localization.deleteAccountSubtitle),
                    const SizedBox(height: 16),
                    Text(localization.enterPassword),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: localization.passwordHint,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Cerrar diálogo
                      passwordController.dispose(); // Liberar controlador
                    },
                    child: Text(localization.cancel),
                  ),
                  TextButton(
                    onPressed: isConfirmButtonEnabled
                        ? () async {
                      final password = passwordController.text;
                      if (password.isNotEmpty) {
                        final success = await authService.deleteAccount(password);
                        Navigator.pop(context);
                        passwordController.dispose(); // Liberar controlador
              
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(localization.accountDeleted)),
                          );
                          Navigator.of(context).pushReplacementNamed('login');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(localization.invalidPassword)),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localization.passwordRequired)),
                        );
                      }
                    }
                        : null,
                    child: Text(localization.confirm),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) => passwordController.dispose()); // Eliminar controlador al cerrar el diálogo
  }
}
