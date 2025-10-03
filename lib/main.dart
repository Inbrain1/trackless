import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/features/1_auth/presentation/screens/splash_screen.dart';
import 'package:untitled2/features/1_auth/presentation/screens/login_screen.dart';
import 'package:untitled2/features/1_auth/presentation/screens/register_screen.dart';
import 'package:untitled2/screens/home_screen.dart';
import 'package:untitled2/features/1_auth/presentation/screens/welcome_screen.dart';
import 'package:untitled2/services/auth_service.dart';
import 'package:untitled2/services/notifications_service.dart';
import 'package:untitled2/features/2_map_view/presentation/screens/driver_map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MyApp(), // Asegúrate de envolver `MyApp` aquí
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/':(context)=> CheckAuthScreen(),
        '/welcome':(context)=> WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        'driverMap': (context) => DriverMapScreen(),
      },
      scaffoldMessengerKey: NotificationsService.messengerKey,

    );
  }
}
