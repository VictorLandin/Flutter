import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importa AppLocalizations
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
    final localization = AppLocalizations.of(context)!;

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
                    Text(
                      localization.registerTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
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
                child: Text(
                  localization.alreadyHaveAccount,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
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
    final localization = AppLocalizations.of(context)!;

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
              hintText: localization.nameHint,
              labelText: localization.nameLabel,
              prefixIcon: Icons.person,
              currentTheme: currentTheme,
            ),
            onChanged: (value) => registerForm.name = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return localization.nameEmptyError;
              }
              if (value.length < 2) {
                return localization.nameLengthError;
              }
              return null;
            },
          ),
          const SizedBox(height: 30),

          // Campo de correo
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: localization.emailHint,
              labelText: localization.emailLabel,
              prefixIcon: Icons.alternate_email_rounded,
              currentTheme: currentTheme,
            ),
            onChanged: (value) => registerForm.email = value,
            validator: (value) {
              String pattern = r'^[^@]+@[^@]+\.[a-zA-Z]{2,}$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '') ? null : localization.emailInvalidError;
            },
          ),
          const SizedBox(height: 30),

          // Campo de contraseña
          TextFormField(
            autocorrect: false,
            obscureText: true,
            decoration: InputDecorations.authInputDecoration(
              hintText: localization.passwordHint,
              labelText: localization.passwordLabel,
              prefixIcon: Icons.lock_outline_rounded,
              currentTheme: currentTheme,
            ),
            onChanged: (value) => registerForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : localization.passwordLengthError;
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
                registerForm.email,
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
                registerForm.isLoading
                    ? localization.registerLoading
                    : localization.registerButton,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
