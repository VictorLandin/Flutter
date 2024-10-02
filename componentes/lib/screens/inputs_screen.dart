import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class InputsScreen extends StatelessWidget {
  const InputsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

    final Map<String, String> formValues = {
      'first_name': 'Victor',
      'last_name': 'Landin',
      'email': 'bJt3M@example.com',
      'password': '123456',
      'role': 'Admin'
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Inputs y Forms')),
      body: SingleChildScrollView(
        // Optional
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: myFormKey,
              child: Column(
                children: [
                   CustomInputField(
                    hintText: 'Nombre del usuario',
                    labelText: 'Nombre',
                    helperText: 'Solo letras y espacios',
                    formProperty: 'first_name',
                    formValues: formValues,
                  ),
                  const SizedBox(height: 30),
                   CustomInputField(
                    hintText: 'Apellido del usuario',
                    labelText: 'Apellido',
                    helperText: 'Solo letras y espacios',
                    formProperty: 'last_name',
                    formValues: formValues,
                  ),
                  const SizedBox(height: 30),
                   CustomInputField(
                    hintText: 'Email del usuario',
                    labelText: 'Email',
                    helperText: 'Solo letras y espacios',
                    keyboard: TextInputType.emailAddress,
                    formProperty: 'email',
                    formValues: formValues,
                  ),
                  const SizedBox(height: 30),
                   CustomInputField(
                    hintText: 'Contrasena del usuario',
                    labelText: 'Contrasena',
                    helperText: 'Solo letras y espacios',
                    keyboard: TextInputType.visiblePassword,
                    isPassword: true,
                    formProperty: 'password',
                    formValues: formValues,
                  ),
                  const SizedBox(height: 30),
                  DropdownButtonFormField(
                      items: const [
                        DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                        DropdownMenuItem(value: 'SuperUser', child: Text('SuperUser')),
                        DropdownMenuItem(value: 'Developer', child: Text('Developer')),
                        DropdownMenuItem(value: 'Jr. Developer', child: Text('Jr. Developer')),
                      ],
                      onChanged: ( value ){
                        print(value);
                        formValues['role'] = value ?? 'Admin';
                      }),

                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (!myFormKey.currentState!.validate()) {
                          print('Formulario no valido');
                          return;
                        }
                        // imprimir valores del formulario
                        print(formValues);
                      },
                      child:
                          const SizedBox(child: Center(child: Text('Guardar'))))
                ],
              ),
            )),
      ),
    );
  }
}
