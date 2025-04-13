import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_provider.dart';
import 'package:esvilla_app/presentation/views/admin/edit_user_screen.dart';
import 'package:esvilla_app/presentation/views/admin/list_users_screen.dart';
import 'package:esvilla_app/presentation/views/schedule_screen.dart/schedule_screen.dart';
import 'package:esvilla_app/presentation/views/screens.dart';
import 'package:esvilla_app/presentation/widgets/home/user/trash_recollection_schedule.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String admin = '/admin';
  static const String login = '/login';
  static const String register = '/register';
  static const String schedule = '/schedule';
  static const String adminListUsers= 'admin-users';
  static const String adminEditUser = 'edit-user';

  // Lista de rutas públicas que no requieren autenticación
  static final publicRoutes = <String>{
    splash,
    login,
    register,
  };

  // Lista de rutas administrativas
  static final adminRoutes = <String>{
    admin,
    adminListUsers,
    adminEditUser
  };

  // Lista de rutas que requieren autenticación
  static final authenticatedRoutes = <String>{
    home,
    schedule,
  };
}

/* String getBaseRoute(String path) {
        return path.split('/').take(2).join('/');
} */
String getBaseRoute(String path) {
  final segments = path.split('/');
  return segments.length > 1 ? '/${segments[1]}' : path;
}

class GoRouterNotifier extends ChangeNotifier {
  final Ref ref;
  GoRouterNotifier(this.ref) {
    ref.listen(authControllerProvider, (previous, next) {
      if (previous?.isAuthenticated != next.isAuthenticated) {
        AppLogger.i(
            "Cambio detectado en autenticación: isAuthenticated = ${next.isAuthenticated}");
        notifyListeners(); // Notifica cuando cambia la autenticación
      }
    });
  }
}

final goRouterNotifierProvider = Provider<GoRouterNotifier>((ref) {
  return GoRouterNotifier(ref);
});
//-----------------------------------------------------
final goRouterProvider = Provider<GoRouter>((ref) {
  final goRouterNotifier = ref.watch(goRouterNotifierProvider);
  ref.read(authControllerProvider.notifier).checkAuthentication();
  return GoRouter(
    refreshListenable: goRouterNotifier, // Aquí usamos ChangeNotifier
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isAuthenticated = authState.isAuthenticated;
      final isAdmin = authState.isAdmin;
      final currentLocation = state.matchedLocation;

      AppLogger.i("Redirección - Autenticado: $isAuthenticated | Ruta actual: $currentLocation | Admin: $isAdmin");
      // 1. Si el usuario NO está autenticado
      if (!isAuthenticated) {
        // Permitir acceso a rutas públicas
        if (AppRoutes.publicRoutes.contains(currentLocation)) {
          return null;
        }
        // Redirigir a login para otras rutas
        return AppRoutes.login;
      }

      // 2. Si el usuario ESTÁ autenticado
      // Evitar acceso a rutas públicas cuando está autenticado
      if (AppRoutes.publicRoutes.contains(currentLocation)) {
        return isAdmin ? AppRoutes.admin : AppRoutes.home;
      }

      AppLogger.w('base route: ${getBaseRoute(currentLocation)}');
      AppLogger.w('full path: ${state.fullPath}');
      AppLogger.w('state location: ${state.fullPath}');
      AppLogger.w('state matchedLocation: ${state.matchedLocation}');
      // 3. Verificar permisos de administrador
      if (AppRoutes.adminRoutes.contains(getBaseRoute(currentLocation))) {
        if (!isAdmin) {
          return AppRoutes.home; // Redirigir a home si no es admin
        }
      }

      // 4. Permitir acceso a rutas autenticadas
/*       AppLogger.i("el tal getBaseRoute: ${getBaseRoute(currentLocation)}");
      AppLogger.i("el tal currentLocation: $currentLocation");
      AppLogger.i("MatchedPATH : ${state.fullPath} y pertence a AppRoutes?? veamos: ${AppRoutes.authenticatedRoutes.contains(state.fullPath)}"); */

      if (AppRoutes.authenticatedRoutes
              .contains(getBaseRoute(currentLocation)) ||
          AppRoutes.authenticatedRoutes.contains(state.fullPath)) {
        return null; // Permitir acceso
      }

      return null; // esto segun chatgpt
      // 5. Por defecto, redirigir a la home page correspondiente
      //return isAdmin ? AppRoutes.admin : AppRoutes.home;
    },
    routes: <GoRoute>[
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.admin,
        name: 'admin',
        builder: (context, state) => const AdminHome(),
        routes: <GoRoute>[
          GoRoute(
            path: AppRoutes.adminListUsers,
            name: 'adminListUsers',
            builder: (context, state) => const ListUsersScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminEditUser,
            name: 'adminEditUser',
            builder: (context, state) => EditUserScreen(user: state.extra),
          ),
        ]
      ),
      GoRoute(
        path: AppRoutes.schedule,
        name: 'schedule',
        builder: (context, state) => ScheduleScreen(
          daySchedule: state.extra as DaySchedule,
        ),
      ),
    ],
  );
});
