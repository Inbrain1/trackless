import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email    = '';
  String password = '';
  String? role    = 'Usuario'; // Rol predeterminado

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    // Imprimir para depuración
    print(formKey.currentState?.validate());
    print('$email - $password - $role');

    // Validar el formulario y asegurarse de que un rol esté seleccionado
    return formKey.currentState?.validate() ?? false && role != null && role!.isNotEmpty;
  }

  // Método para establecer el rol
  void setRole(String newRole) {
    role = newRole;
    notifyListeners();
  }
}
