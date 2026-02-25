// ABOUTME: Tests for GoRouter: initial route is Home, navigating to /about shows About.
// ABOUTME: Uses route config and navigation to verify shell and routes.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:rpg/app/router.dart';

void main() {
  testWidgets('initial route is Home', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: goRouter,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsAtLeast(1));
  });

  testWidgets('navigating to /about shows About', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: goRouter,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold).first);
    context.go('/about');
    await tester.pumpAndSettle();

    expect(find.text('About'), findsAtLeast(1));
  });
}
