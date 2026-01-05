import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_bloc.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_event.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_state.dart';
import 'package:untitled2/features/1_auth/presentation/widgets/glowing_text_field.dart';
import 'package:untitled2/features/1_auth/presentation/widgets/gradient_auth_button.dart';
import 'package:untitled2/features/1_auth/presentation/widgets/university_auth_header.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const UniversityAuthHeader(),
              const SizedBox(height: 30),
              // Optional: Change header text or add subtitle for Register
              const Text(
                'REGISTRO',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 30),
              const _RegisterForm(),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Usuario';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
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
            GlowingTextField(
              controller: _nameController,
              hintText: 'Nombre Completo',
              prefixIcon: Icons.person_outline,
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Campo obligatorio';
              },
            ),
            const SizedBox(height: 20),
            GlowingTextField(
              controller: _emailController,
              hintText: 'Código Estudiante',
              prefixIcon: Icons.badge_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) return 'El formato es incorrecto';
                // Similar to login, relaxed check or strict email
                return null;
              },
            ),
            const SizedBox(height: 20),
            GlowingTextField(
              controller: _passwordController,
              hintText: 'Contraseña',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              // FIX: Added missing validator
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La contraseña es obligatoria';
                }
                if (value.length < 6) {
                  return 'Mínimo 6 caracteres';
                }
                return null;
              },
            ), // FIX: Proper widget closing
            const SizedBox(height: 30),
            // FIX: Replaced MaterialButton with GradientAuthButton for consistency
            GradientAuthButton(
              onPressed: _isLoading ? null : _submit,
              text: _isLoading ? 'Espere...' : 'Registrar',
            )
          ],
        ),
      ),
    );
  }
}