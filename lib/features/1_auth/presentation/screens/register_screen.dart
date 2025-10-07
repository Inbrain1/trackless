import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled2/core/ui/input_decorations.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_bloc.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_event.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_state.dart';
import 'package:untitled2/features/1_auth/presentation/widgets/auth_background.dart';
import 'package:untitled2/features/1_auth/presentation/widgets/card_container.dart';

class RegisterScreen extends StatelessWidget {
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
                    Text('Crear cuenta', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 30),
                    const _RegisterForm(),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: () => context.go('/login'),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                ),
                child: const Text('¿Ya tienes una cuenta?', style: TextStyle(fontSize: 18, color: Colors.black87)),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Usuario';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      context.read<AuthBloc>().add(
        SignUpRequested(
          _emailController.text,
          _passwordController.text,
          _selectedRole,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated && state.message.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded,
              ),
              validator: (value) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '') ? null : 'El correo no es válido';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _passwordController,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline,
              ),
              validator: (value) {
                return (value != null && value.length >= 6) ? null : 'La contraseña debe tener al menos 6 caracteres';
              },
            ),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: InputDecorations.authInputDecoration(
                labelText: 'Rol',
                prefixIcon: Icons.person_outline, hintText: 'Seleciona tu rol',
              ),
              items: const [
                DropdownMenuItem(value: 'Usuario', child: Text('Usuario')),
                DropdownMenuItem(value: 'Conductor', child: Text('Conductor')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRole = value;
                  });
                }
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: _isLoading ? null : _submit,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  _isLoading ? 'Espere' : 'Registrar',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}