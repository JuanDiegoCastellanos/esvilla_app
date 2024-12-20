
import 'package:esvilla_app/presentation/screens/screens.dart';
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