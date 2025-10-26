// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:esvilla_app/main.dart';
import 'package:esvilla_app/core/config/app_router.dart';

void main() {
  testWidgets('La app construye con ProviderScope y un router de prueba',
      (WidgetTester tester) async {
    final testRouter = GoRouter(
      routes: [
        GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: Text('home'))),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          goRouterProvider.overrideWithValue(testRouter),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('home'), findsOneWidget);
  });
}
