import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/services/auth_service.dart';

import '../../../../providers/login_form_provider.dart';
import '../../../../services/notifications_service.dart';
import '../../../../core/ui/input_decorations.dart';
import '../widgets/auth_background.dart';
import '../widgets/card_container.dart';

class RegisterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  SizedBox( height: 250 ),

                  CardContainer(
                      child: Column(
                        children: [

                          SizedBox( height: 10 ),
                          Text('Crear cuenta', style: Theme.of(context).textTheme.headlineMedium ),
                          SizedBox( height: 30 ),

                          ChangeNotifierProvider(
                              create: ( _ ) => LoginFormProvider(),
                              child: _LoginForm()
                          )


                        ],
                      )
                  ),

                  SizedBox( height: 50 ),
                  TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all( Colors.indigo.withOpacity(0.1)),
                          shape: MaterialStateProperty.all( StadiumBorder() )
                      ),
                      child: Text('¿Ya tienes una cuenta?', style: TextStyle( fontSize: 18, color: Colors.black87 ),)
                  ),
                  SizedBox( height: 50 ),
                ],
              ),
            )
        )
    );
  }
}


class _LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'john.doe@gmail.com',
                  labelText: 'Correo electrónico',
                  prefixIcon: Icons.alternate_email_rounded
              ),
              onChanged: ( value ) => loginForm.email = value,
              validator: ( value ) {

                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';

              },
            ),

            SizedBox( height: 30 ),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*****',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline
              ),
              onChanged: ( value ) => loginForm.password = value,
              validator: ( value ) {

                return ( value != null && value.length >= 6 )
                    ? null
                    : 'La contraseña debe de ser de 6 caracteres';

              },
            ),
            SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: loginForm.role,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Selecciona tu rol',
                labelText: 'Rol',
                prefixIcon: Icons.person_outline,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Usuario',
                  child: Text('Usuario'),
                ),
                DropdownMenuItem(
                  value: 'Conductor',
                  child: Text('Conductor'),
                ),
              ],
              onChanged: (value) {
                loginForm.role = value;
              },
              validator: (value) {
                return value != null && value.isNotEmpty
                    ? null
                    : 'Por favor selecciona un rol';
              },
            ),

            SizedBox( height: 30 ),

            MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                child: Container(
                    padding: EdgeInsets.symmetric( horizontal: 80, vertical: 15),
                    child: Text(
                      loginForm.isLoading
                          ? 'Espere'
                          : 'Ingresar',
                      style: TextStyle( color: Colors.white ),
                    )
                ),onPressed: loginForm.isLoading ? null : () async {
              FocusScope.of(context).unfocus();
              final authService = Provider.of<AuthService>(context, listen: false);

              if (!loginForm.isValidForm()) return;

              loginForm.isLoading = true;

              try {
                // Intentar registrar el usuario
                final User? user = await authService.register(
                  loginForm.email,
                  loginForm.password,
                  loginForm.role!,
                );

                if (user != null) {
                  // Si el registro es exitoso, navegar a la pantalla de inicio
                  await Navigator.pushReplacementNamed(context, '/home');
                } else {
                  // Si hay un error, mostrar un mensaje de error
                  NotificationsService.showSnackbar('Error al registrarse. Inténtalo de nuevo.');
                }
              } catch (e) {
                // Manejar excepciones generales
                NotificationsService.showSnackbar('Error inesperado: $e');
              } finally {
                // Restablecer el estado de carga
                loginForm.isLoading = false;
              }
            }

            )

          ],
        ),
      ),
    );
  }
}