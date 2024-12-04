import 'package:flutter/material.dart';
import 'package:noticias/router/app_routes.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../theme/input_decorations.dart';
import '../widgets/widgets.dart';
import '../providers/login_form_provider.dart';
import '../services/services.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Register', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _RegisterForm(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                ),
                child: const Text(
                  '¿Ya tienes cuenta?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'login');
                },
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<LoginFormProvider>(context);
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;

    return Form(
      key: registerForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // Campo de nombre
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Tu Nombre',
              labelText: 'Nombre de Usuario',
              prefixIcon: Icons.person,
              currentTheme: currentTheme,
            ),
            onChanged: (value) => registerForm.name = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El nombre no puede estar vacío';
              }
              if (value.length < 2) {
                return 'El nombre debe tener al menos 2 caracteres';
              }
              return null; // Validación exitosa
            },
          ),
          const SizedBox(height: 30),

          // Campo de correo
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'email@example.com',
              labelText: 'Correo Electrónico',
              prefixIcon: Icons.alternate_email_rounded,
              currentTheme: currentTheme,
            ),
            onChanged: (value) => registerForm.emailOrUsername = value,
            validator: (value) {
              String pattern = r'^[^@]+@[^@]+\.[a-zA-Z]{2,}$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '') ? null : 'Correo no válido';
            },
          ),
          const SizedBox(height: 30),

          // Campo de contraseña
          TextFormField(
            autocorrect: false,
            obscureText: true,
            decoration: InputDecorations.authInputDecoration(
              hintText: '******',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline_rounded,
              currentTheme: currentTheme,
            ),
            onChanged: (value) => registerForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe tener al menos 6 caracteres';
            },
          ),
          const SizedBox(height: 30),

          // Botón de registro
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            onPressed: registerForm.isLoading
                ? null
                : () async {
              FocusScope.of(context).unfocus();
              final authService = Provider.of<AuthService>(context, listen: false);

              if (!registerForm.isValidForm()) return;

              registerForm.isLoading = true;

              final String? errorMessage = await authService.createUser(
                registerForm.emailOrUsername,
                registerForm.password,
                registerForm.name,
              );

              if (errorMessage == null) {
                AppRoutes.navigateAndRemoveUntil(context, 'home');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(errorMessage)),
                );
                registerForm.isLoading = false;
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                registerForm.isLoading ? 'Cargando...' : 'Registrar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
