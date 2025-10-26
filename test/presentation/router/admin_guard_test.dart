import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/presentation/providers/auth/auth_controller_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('No admin redirige de /admin a /home', (tester) async {
    // Crear el container
    final container = ProviderContainer();

    // Forzamos estado autenticado pero no admin ANTES de crear el router
    container.read(authControllerProvider.notifier).state =
        container.read(authControllerProvider).copyWith(
              isAuthenticated: true,
              isAdmin: false,
            );

    // Leer el router después de configurar el estado
    final router = container.read(goRouterProvider);

    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    // Esperar a que el árbol de widgets se construya completamente
    await tester.pumpAndSettle();

    // Navegar primero a /home para establecer una ruta válida
    router.go('/home');
    await tester.pumpAndSettle();

    // Ahora intentar navegar a /admin
    router.go('/admin');
    await tester.pumpAndSettle();

    // Verificar que la URL actual no es /admin (debe haber sido redirigido)
    final routerState = router.routerDelegate.currentConfiguration;

    if (routerState.matches.isNotEmpty) {
      final currentLocation = routerState.matches.last.matchedLocation;
      expect(currentLocation, isNot('/admin'),
          reason: 'Un usuario no admin no debería poder acceder a /admin');
      expect(currentLocation, '/home', reason: 'Debería redirigir a /home');
    } else {
      // Si no hay matches, verificamos que la URI actual sea home
      final currentUri = router.routerDelegate.currentConfiguration.uri;
      expect(currentUri.path, isNot('/admin'),
          reason: 'El path no debería ser /admin');
    }
  });
}
