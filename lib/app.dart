import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled2/core/config/router/app_router.dart';
import 'package:untitled2/core/di/service_locator.dart';
import 'package:untitled2/features/1_auth/presentation/bloc/auth_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    // Obtenemos la instancia del BLoC desde nuestro Service Locator
    _authBloc = sl<AuthBloc>();
    // Creamos la instancia del router, pasándole el BLoC
    _appRouter = AppRouter(authBloc: _authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc, // Usamos BlocProvider.value porque ya tenemos la instancia
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'SmartBus App',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // Usamos el router creado en el initState
        routerConfig: _appRouter.router,
      ),
    );
  }
}