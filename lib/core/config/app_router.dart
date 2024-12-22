
import 'package:esvilla_app/presentation/views/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[

    GoRoute(path: '/',
    builder: (context, state) =>  const SplashScreen(), ),

    GoRoute(path: '/home',
    builder: (context, state) =>  const HomeScreen(), ),

    GoRoute(path: '/login',
    builder: (context, state) =>  const LoginScreen(), ),

]);

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';

  static final GoRouter router = GoRouter(
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
        builder: (context, state) => const LoginScreen(),
      ),
    ],
    redirect: _redirectLogic,
  );

  static String? _redirectLogic(BuildContext context, GoRouterState state) {
    // Aquí puedes verificar el estado de autenticación
    final isAuthenticated = false; // Cambia según tu lógica
    final loggingIn = state.uri.path == login;

    if (!isAuthenticated && !loggingIn) return login;
    if (isAuthenticated && loggingIn) return home;

    return null; // Sin redirección


  }
}