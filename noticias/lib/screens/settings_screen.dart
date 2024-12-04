import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Preferencias',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Modo Claro/Oscuro
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Modo oscuro'),
            trailing: _ThemeSwitch(), // Diseño personalizado para cambiar tema
          ),
          const Divider(),

          // Cambiar idioma
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Idioma'),
            subtitle: Text('Actualmente: ${_getCurrentLanguage()}'),
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          const Divider(),

          // Eliminar cuenta
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Eliminar cuenta'),
            subtitle: const Text('Esta acción es irreversible'),
            onTap: () {
              _showDeleteAccountDialog(context, authService);
            },
          ),
        ],
      ),
    );
  }

  // Obtener el idioma actual
  String _getCurrentLanguage() {
    return 'Español'; // O 'Inglés', ajusta según tu configuración
  }

  // Mostrar diálogo para cambiar idioma
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Seleccionar idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Español'),
              onTap: () {
                Navigator.pop(context);
                _changeLanguage(context, 'es');
              },
            ),
            ListTile(
              title: const Text('Inglés'),
              onTap: () {
                Navigator.pop(context);
                _changeLanguage(context, 'en');
              },
            ),
          ],
        ),
      ),
    );
  }

  // Cambiar idioma (placeholder)
  void _changeLanguage(BuildContext context, String languageCode) {
    print('Idioma cambiado a: $languageCode'); // Placeholder
  }

  // Mostrar diálogo para eliminar cuenta
  void _showDeleteAccountDialog(BuildContext context, AuthService authService) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Por favor, introduce tu contraseña para confirmar la eliminación de tu cuenta.'),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final password = passwordController.text;
              if (password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor, introduce tu contraseña')),
                );
                return;
              }

              final result = await authService.deleteAccount(password);
              if (result == null) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cuenta eliminada exitosamente')),
                );
                Navigator.pushReplacementNamed(context, 'login');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $result')),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _ThemeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: () {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleDarkMode();
      },
      child: Container(
        width: 60, // Ancho del contenedor
        height: 35, // Alto del contenedor
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), // Bordes redondeados
          border: Border.all(
            color: currentTheme.colorScheme.primary.withOpacity(0.5),
            width: 2,
          ), //borde para imitar al borde de un switch
          color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.grey[300],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: AnimatedAlign(
            alignment: themeProvider.isDarkMode
                ? Alignment.centerRight
                : Alignment.centerLeft,
            duration:
            const Duration(milliseconds: 200), // Duración de la animación
            child: Container(
              width: 28, // Ancho del círculo
              height: 28, // Alto del círculo
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentTheme.canvasColor, // Color del círculo
              ),
              child: Center(
                child: Icon(
                  themeProvider.isDarkMode
                      ? Icons.nightlight_round
                      : Icons.wb_sunny,
                  color: currentTheme.colorScheme.primary,
                  size: 20, // Tamaño del ícono dentro del círculo
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
