
import 'package:esvilla_app/presentation/providers/auth_controller_provider.dart';
import 'package:esvilla_app/presentation/views/screens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


const String splash = '/';
const String home = '/home';
const String adminHome = '/admin/home';
const String login = '/login';
const String register = '/register';

final goRouterProvider = Provider<GoRouter>((ref){
  final authState = ref.watch(authControllerProvider);
    return GoRouter(
      redirect: (context, state) {
        // Si no está autenticado y no está en login, redirige a login
        final isAuthenticated = authState.isAuthenticated;
        final isOnLogin = state.matchedLocation == login;
        final isOnSplash = state.matchedLocation == splash;
        
        if (!isAuthenticated && !isOnLogin) {
          return login;
        }
        // Si ya está autenticado, redirige a home
        if ((isAuthenticated && (isOnLogin || isOnSplash)) && authState.isAdmin) {
          return adminHome;
        }else if(isAuthenticated && (isOnLogin || isOnSplash) && authState.isAdmin == false){
          return home;
        }
        return null;
      },
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
    );
  }
  );

  