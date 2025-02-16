import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/presentation/providers/auth_controller_provider.dart';
import 'package:esvilla_app/presentation/views/screens.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GoRouterNotifier extends ChangeNotifier {
  final Ref ref;
  GoRouterNotifier(this.ref) {
    ref.listen(authControllerProvider, (previous, next) {
      if (previous?.isAuthenticated != next.isAuthenticated) {
        AppLogger.i("Cambio detectado en autenticación: isAuthenticated = ${next.isAuthenticated}");
        notifyListeners(); // Notifica cuando cambia la autenticación
      }
    });
  }
}

final goRouterNotifierProvider = Provider<GoRouterNotifier>((ref) {
  return GoRouterNotifier(ref);
});
//-----------------------------------------------------
const String splash = '/';
const String home = '/home';
const String adminHome = '/admin/home';
const String login = '/login';
const String register = '/register';

final goRouterProvider = Provider<GoRouter>((ref) {
  final goRouterNotifier = ref.watch(goRouterNotifierProvider);

  return GoRouter(
    refreshListenable: goRouterNotifier, // Aquí usamos ChangeNotifier
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      // Si no está autenticado y no está en login, redirige a login
      final isAuthenticated = authState.isAuthenticated;
      final currentLocation = state.matchedLocation;
      final isAdmin = authState.isAdmin;
      AppLogger.i(
          "Redirección - Autenticado: $isAuthenticated | Ruta actual: $currentLocation | Admin: $isAdmin");

      // Usuario NO autenticado
      if (!isAuthenticated) {
        if (currentLocation == login) return login;
        if (currentLocation == splash) return splash;
        if (currentLocation == register) return register;
        return splash;
      }
      if (isAuthenticated) {
        if (currentLocation == login || currentLocation == splash) {
          return isAdmin ? adminHome : home;
        }
        if (currentLocation.startsWith('/admin') && !isAdmin) {
          return home;
        }
      }
      // Verificar acceso a rutas admin

      return null;
    },
    routes: <GoRoute>[
      GoRoute(
        path: splash,
        name: splash,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: home,
        name: home,
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: login,
        name: login,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: register,
        name: register,
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: adminHome,
        name: adminHome,
        builder: (context, state) => const AdminHome(),
      ),
    ],
  );
});
