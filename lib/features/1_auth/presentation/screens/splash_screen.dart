import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/features/1_auth/presentation/screens/login_screen.dart';
import 'package:untitled2/features/1_auth/presentation/screens/welcome_screen.dart';
import 'package:untitled2/services/auth_service.dart';

import '../../../../screens/home_screen.dart';

class CheckAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) return Text('login');
            if (snapshot.data == '') {
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => WelcomeScreen(),
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
              });

            }
         else{
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => HomeScreen(),
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
              });
            }
         return Container();
          },
        ),
      ),
    );
  }
}
