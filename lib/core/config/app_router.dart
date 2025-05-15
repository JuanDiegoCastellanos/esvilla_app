import 'package:esvilla_app/core/config/app_logger.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_token_state_notifier.dart';
import 'package:esvilla_app/presentation/providers/user/user_controller_provider.dart';
import 'package:esvilla_app/presentation/views/admin/add_announcements_screen.dart';
import 'package:esvilla_app/presentation/views/admin/add_schedules_screen.dart';
import 'package:esvilla_app/presentation/views/admin/add_sector_screen.dart';
import 'package:esvilla_app/presentation/views/admin/add_user_screen.dart';
import 'package:esvilla_app/presentation/views/admin/edit_announcements_screen.dart';
import 'package:esvilla_app/presentation/views/admin/edit_pqrs_creen.dart';
import 'package:esvilla_app/presentation/views/admin/edit_schedule_screen.dart';
import 'package:esvilla_app/presentation/views/admin/edit_sector_screen.dart';
import 'package:esvilla_app/presentation/views/admin/edit_user_screen.dart';
import 'package:esvilla_app/presentation/views/admin/list_announcements_screen.dart';
import 'package:esvilla_app/presentation/views/admin/list_pqrs_screen.dart';
import 'package:esvilla_app/presentation/views/admin/list_schedules_screen.dart';
import 'package:esvilla_app/presentation/views/admin/list_sectors_screen.dart';
import 'package:esvilla_app/presentation/views/admin/list_users_screen.dart';
import 'package:esvilla_app/presentation/views/screens.dart';
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
  static const String adminListUsers = 'admin-users';
  static const String adminEditUser = 'edit-user';
  static const String adminCreateUser = 'create-user';
  static const String adminListAnnouncements = 'admin-announcements';
  static const String adminEditAnnouncement = 'edit-announcement';
  static const String adminCreateAnnouncement = 'create-announcement';
  static const String adminListPqrs = 'admin-pqrs';
  static const String adminEditPqrs = 'edit-pqrs';
  static const String adminListSchedules = 'admin-schedules';
  static const String adminEditSchedule = 'edit-schedule';
  static const String adminCreateSchedule = 'create-schedule';
  static const String adminListSectors = 'admin-sectors';
  static const String adminEditSector = 'edit-sector';
  static const String adminCreateSector = 'create-sector';
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
    adminEditUser,
    adminCreateUser,
    adminListAnnouncements,
    adminEditAnnouncement,
    adminCreateAnnouncement,
    adminListPqrs,
    adminEditPqrs,
    adminListSchedules,
    adminEditSchedule,
    adminCreateSchedule,
    adminListSectors,
    adminEditSector,
    adminCreateSector
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
  bool _isAdmin = false;
  GoRouterNotifier(this.ref) {
    ref.listen(authControllerProvider, (previous, next) {
      final prevAuth = previous?.isAuthenticated ?? false;
      final prevAdmin = previous?.isAdmin ?? false;
      if (prevAuth != next.isAuthenticated || prevAdmin != next.isAdmin) {
        _isAdmin = next.isAdmin;
        AppLogger.i(
            "Cambio detectado en autenticación: isAuthenticated = ${next.isAuthenticated}");
        notifyListeners(); // Notifica cuando cambia la autenticación
      }
    });

    ref.listen(userControllerProvider, (previous, next) {
      if (next.isLoading) {
        return;
      }
      if (previous != null &&
          !previous.isLoading &&
          !previous.hasError &&
          !next.isLoading &&
          !next.hasError) {
        final prevUserState = previous.value;
        final nextUserState = next.value;

        if (prevUserState?.role != nextUserState?.role) {
          AppLogger.i(
              "Cambio detectado en rol de usuario: role = ${nextUserState?.role}");

          // Actualizamos _isAdmin basado en el nuevo rol
          final isNowAdmin = nextUserState?.role?.toLowerCase() == 'admin';
          if (_isAdmin != isNowAdmin) {
            _isAdmin = isNowAdmin;

            // Actualizar el estado de autenticación para reflejar el nuevo estado de admin
            ref.read(authControllerProvider).copyWith(isAdmin: _isAdmin);

            AppLogger.i("Cambio de isAdmin: $_isAdmin");
            notifyListeners();
          }
        }
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
  //AppLogger.i("Datos : ${ref.read(authControllerProvider).token}");
  return GoRouter(
    refreshListenable: goRouterNotifier, // Aquí usamos ChangeNotifier
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final authState = ref.read(authControllerProvider);
      final isAuthenticated = authState.isAuthenticated;
      final isAdmin = authState.isAdmin;
      final currentLocation = state.matchedLocation;

      if (isAuthenticated) {
        // Periodically check user profile to detect role changes
        ref.read(userControllerProvider.notifier).getMyProfileInfo();
      }

      final isTokenExpired =
          ref.read(authTokenStateNotifierProvider.notifier).isTokenExpired();
      // Si el token expiró aunque el estado diga autenticado
      if (isAuthenticated && isTokenExpired) {
        await ref.read(authControllerProvider.notifier).logout();
        return AppRoutes.login;
      }
      AppLogger.i(
          "Redirección - Autenticado: $isAuthenticated | Ruta actual: $currentLocation | Admin: $isAdmin");
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

      //AppLogger.w('base route: ${getBaseRoute(currentLocation)}');
      //AppLogger.w('full path: ${state.fullPath}');
      //AppLogger.w('state location: ${state.fullPath}');
      //AppLogger.w('state matchedLocation: ${state.matchedLocation}');
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
            GoRoute(
              path: AppRoutes.adminCreateUser,
              name: 'adminCreateUser',
              builder: (context, state) => AddUserScreen(),
            ),
            GoRoute(
              path: AppRoutes.adminListAnnouncements,
              name: 'adminListAnnouncements',
              builder: (context, state) => const ListAnnouncementsScreen(),
            ),
            GoRoute(
              path: AppRoutes.adminEditAnnouncement,
              name: 'adminEditAnnouncement',
              builder: (context, state) => EditAnnouncementScreen(
                  announcement: state.extra),
            ),
            GoRoute(
              path: AppRoutes.adminCreateAnnouncement,
              name: 'adminCreateAnnouncement',
              builder: (context, state) => AddAnnouncementScreen(),
            ),
            GoRoute(
              path: AppRoutes.adminListPqrs,
              name: 'adminListPqrs',
              builder: (context, state) => const ListPqrsScreen(),
            ),
            GoRoute(
              path: AppRoutes.adminEditPqrs,
              name: 'adminEditPqrs',
              builder: (context, state) => EditPqrsScreen(
                  pqrs: state.extra),
            ),
            GoRoute(
              path: AppRoutes.adminListSchedules,
              name: 'adminListSchedules',
              builder: (context, state) => ListSchedulesScreen(),
            ),
            GoRoute(
              path: AppRoutes.adminEditSchedule,
              name: 'adminEditSchedule',
              builder: (context, state) => EditScheduleScreen(
                  schedule: state.extra),
            ),
            GoRoute(
              path: AppRoutes.adminCreateSchedule,
              name: 'adminCreateSchedule',
              builder: (context, state) => AddSchedulesScreen(),
            ),
            GoRoute(
              path: AppRoutes.adminListSectors,
              name: 'adminListSectors',
              builder: (context, state) => ListSectorsScreen(),
            ),
            GoRoute(
              path: AppRoutes.adminEditSector,
              name: 'adminEditSector',
              builder: (context, state) => EditSectorScreen(
                  sector: state.extra),
              ),
            GoRoute(
              path: AppRoutes.adminCreateSector,
              name: 'adminCreateSector',
              builder: (context, state) => AddSectorScreen(),
            ),
            
          ]),
    ],
  );
});
