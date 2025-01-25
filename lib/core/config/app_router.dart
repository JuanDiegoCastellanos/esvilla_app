
import 'package:esvilla_app/presentation/providers/auth_controller_provider.dart';
import 'package:esvilla_app/presentation/views/screens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


const String splash = '/';
const String home = '/home';
const String login = '/login';
const String register = '/register';

final goRouterProvider = Provider<GoRouter>((ref){
    final authController = ref.watch(authControllerProvider);
    return GoRouter(
      initialLocation: splash,
      routes: <GoRoute>[
        GoRoute(
          path: splash,
          builder: (context, state) =>  SplashScreen(),
        ),
        GoRoute(
          path: home,
          builder: (context, state) =>  HomeScreen(),
        ),
        GoRoute(
          path: login,
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          path: register,
          builder: (context, state) => RegisterScreen(),
        ),
    ],
    redirect: (context, state){
      final isAuthenticated = authController.token.isNotEmpty;
      final loggingIn = state.uri.path ==login;

      if (!isAuthenticated && !loggingIn) {
          return splash;
        }
        if (isAuthenticated && loggingIn) {
          return home;
        }
        return null;
    }
    );
  }
  );