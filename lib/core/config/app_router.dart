
import 'package:esvilla_app/presentation/views/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../presentation/controller/auth_controller.dart';
import '../../injection/injection.dart' as di;

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';

  static final GoRouter appRouter = GoRouter(
    initialLocation: splash,
    routes: <GoRoute>[
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) {
          return ChangeNotifierProvider(
            create: (_) => di.sl<AuthController>(),
            child: LoginScreen(),
          );
        },
      ),
    ],
    redirect: _redirectLogic,
  );

  static String? _redirectLogic(BuildContext context, GoRouterState state) {
    // Aquí puedes verificar el estado de autenticación
    final authController = di.sl<AuthController>();
    final isAuthenticated = authController.token.isNotEmpty;
    final loggingIn = state.uri.path == login;

    if (!isAuthenticated && !loggingIn) return splash;
    if (isAuthenticated && loggingIn) return home;

    return null; // Sin redirección


  }
}