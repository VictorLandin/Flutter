import 'package:flutter/material.dart';
import 'package:prooductos_app/ui/input_decorations.dart';
import 'package:prooductos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/login_form_provider.dart';
import '../services/services.dart';

class RegisterScreen extends StatelessWidget {
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
            Text('Register', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 30),
            ChangeNotifierProvider(
                create: (_) => LoginFormProvider(), child: _RegisterForm())
          ],
        )),
        const SizedBox(height: 50),
        TextButton(
          child: const Text('¿Ya tienes cuenta?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        SizedBox(height: 50),
      ])),
    ));
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
        key: registerForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'email@example.com',
                    labelText: 'Correo Electronico',
                    prefixIcon: Icons.alternate_email_rounded),
                onChanged: (value) => registerForm.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);

                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'El valor ingresado no luce como un correo';
                }),
            const SizedBox(height: 30),
            TextFormField(
                autocorrect: false,
                obscureText: true,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '******',
                    labelText: 'Contraseña',
                    prefixIcon: Icons.lock_outline_rounded),
                onChanged: (value) => registerForm.password = value,
                validator: (value) {
                  return (value != null && value.length >= 6)
                      ? null
                      : 'La contraseña debe de ser de 6 caracteres';
                }),
            const SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: registerForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService = Provider.of<AuthService>(context,
                          listen: false);
                      if (!registerForm.isValidForm()) return;

                      registerForm.isLoading = true;

                      final String? errorMessage = await authService.createUser(
                          registerForm.email, registerForm.password);

                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        print(errorMessage);
                        registerForm.isLoading = false;
                      }
                    },
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(registerForm.isLoading ? 'Cargando...' : 'Ingresar',
                    style: const TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
