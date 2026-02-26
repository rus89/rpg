// ABOUTME: Tests for GoRouter: initial route is Home, navigating to /about shows About.
// ABOUTME: Uses route config and navigation to verify shell and routes.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:rpg/app/router.dart';
import 'package:rpg/data/repository.dart';
import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/providers/data_providers.dart';

import '../fake_storage.dart';

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

    expect(find.text('Pregled'), findsAtLeast(1));
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

    expect(find.text('O aplikaciji'), findsAtLeast(1));
  });

  testWidgets('bottom nav shows Serbian labels Pregled, Mapa, O aplikaciji', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: goRouter,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pregled'), findsAtLeast(1));
    expect(find.text('Mapa'), findsAtLeast(1));
    expect(find.text('O aplikaciji'), findsAtLeast(1));
  });

  testWidgets('pushing to detail then tapping Back returns to previous screen', (WidgetTester tester) async {
    final fakeStorage = FakeRpgStorage();
    final repo = RpgRepository(fakeStorage);
    await repo.saveSnapshot(
      const RpgSnapshot(id: '31.12.2025', label: '31.12.2025'),
      [const OpstinaRow(opstinaName: 'Barajevo', totalRegistered: 100, totalActive: 98)],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repositoryProvider.overrideWithValue(repo),
          syncProvider.overrideWith((ref) => Future.value()),
        ],
        child: MaterialApp.router(
          routerConfig: goRouter,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold).first);
    await context.push('/opstina?name=Barajevo&snapshotId=31.12.2025');
    await tester.pumpAndSettle();

    expect(find.byType(BackButton), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Pregled'), findsAtLeast(1));
  });
}
