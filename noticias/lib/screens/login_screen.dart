import 'package:flutter/material.dart';
import '../providers/login_form_provider.dart';
import '../providers/theme_provider.dart';
import '../services/notifications_service.dart';
import '../theme/input_decorations.dart';
import '../widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
          child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 250),
                CardContainer(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text('Login', style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 30),
                        ChangeNotifierProvider(
                            create: (_) => LoginFormProvider(), child: _LoginForm())
                      ],
                    )),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'register');
                  },
                  child: const Text(
                    'Crear una nueva cuenta',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 50),
              ])),
        ));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            // Campo para correo o nombre de usuario
            TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.text, // Ahora acepta texto libre
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'email@example.com o Nombre de usuario',
                    labelText: 'Correo o Nombre de usuario',
                    prefixIcon: Icons.alternate_email_rounded,
                    currentTheme: currentTheme),
                onChanged: (value) => loginForm.emailOrUsername = value,
                validator: (value) {
                  return (value != null && value.isNotEmpty)
                      ? null
                      : 'Este campo no puede estar vacío';
                }),
            const SizedBox(height: 30),

            // Campo de contraseña
            TextFormField(
                autocorrect: false,
                obscureText: true,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '******',
                    labelText: 'Contraseña',
                    prefixIcon: Icons.lock_outline_rounded,
                    currentTheme: currentTheme),
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  return (value != null && value.length >= 6)
                      ? null
                      : 'La contraseña debe de ser de 6 caracteres';
                }),
            const SizedBox(height: 30),

            // Botón de inicio de sesión
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                FocusScope.of(context).unfocus();
                final authService =
                Provider.of<AuthService>(context, listen: false);
                if (!loginForm.isValidForm()) return;

                loginForm.isLoading = true;

                // Intentar iniciar sesión con correo o nombre de usuario
                final String? errorMessage = await authService.signInWithEmailOrUsername(
                    loginForm.emailOrUsername, loginForm.password);

                if (errorMessage == null) {
                  Navigator.pushReplacementNamed(context, 'home');
                } else {
                  print(errorMessage);
                  NotificationsService.showSnackbar(errorMessage);
                  loginForm.isLoading = false;
                }

                loginForm.isLoading = false;
              },
              child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Cargando...' : 'Ingresar',
                    style: const TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
