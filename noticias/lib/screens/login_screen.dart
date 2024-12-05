import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/login_form_provider.dart';
import '../providers/theme_provider.dart';
import '../services/notifications_service.dart';
import '../services/auth_service.dart';
import '../theme/input_decorations.dart';
import '../widgets/widgets.dart';
import '../router/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                      localization.login,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'register');
                },
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.indigo.withOpacity(0.1)),
                ),
                child: Text(
                  localization.createNewAccount,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context).currentTheme;
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // Campo para correo o nombre de usuario
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: localization.emailHint,
              labelText: localization.email,
              prefixIcon: Icons.alternate_email_rounded,
              currentTheme: themeProvider,
            ),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              return (value != null && value.isNotEmpty)
                  ? null
                  : localization.fieldCannotBeEmpty;
            },
          ),
          const SizedBox(height: 30),

          // Campo de contraseña
          TextFormField(
            autocorrect: false,
            obscureText: true,
            decoration: InputDecorations.authInputDecoration(
              hintText: localization.passwordHint,
              labelText: localization.password,
              prefixIcon: Icons.lock_outline_rounded,
              currentTheme: themeProvider,
            ),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : localization.passwordMinLength;
            },
          ),
          const SizedBox(height: 30),

          // Botón de inicio de sesión
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            onPressed: loginForm.isLoading
                ? null
                : () async {
              FocusScope.of(context).unfocus();
              final authService = Provider.of<AuthService>(context, listen: false);

              if (!loginForm.isValidForm()) return;

              loginForm.isLoading = true;

              final String? errorMessage = await authService.signIn(
                loginForm.email,
                loginForm.password,
              );

              if (errorMessage == null) {
                AppRoutes.navigateAndRemoveUntil(context, 'home');
              } else {
                NotificationsService.showSnackbar(errorMessage);
              }

              loginForm.isLoading = false;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                loginForm.isLoading ? localization.loading : localization.login,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
