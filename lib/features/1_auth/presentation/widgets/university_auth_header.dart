import 'package:flutter/material.dart';

class UniversityAuthHeader extends StatelessWidget {
  const UniversityAuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipOval(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Logo Andina
                  Expanded(
                    child: Image.asset(
                      'assets/universidades/andina.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 5),
                  // Logo UNSAAC
                  Expanded(
                    child: Image.asset(
                      'assets/universidades/unssac.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          'INGRESO UNIVERSITARIO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
