import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  // Clave global para el formulario
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  // Campo de entrada que puede ser nombre de usuario o correo
  String emailOrUsername = '';
  String password = '';

  // Estado de carga
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Setter para controlar el estado de carga
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Método para validar el formulario
  bool isValidForm() {
    print(formKey.currentState?.validate());

    // Solo imprimimos el campo de entrada y la contraseña
    print('$emailOrUsername - $password');

    return formKey.currentState?.validate() ?? false;
  }
}
