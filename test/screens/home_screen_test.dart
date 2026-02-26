// ABOUTME: Widget tests for Home screen: dashboard, dropdown, "Pogledaj sve" navigation.
// ABOUTME: Overrides repository and sync; expects summary, dropdown; tap "Pogledaj sve" verifies go_router.

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rpg/app/router.dart';
import 'package:rpg/data/repository.dart';
import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/providers/data_providers.dart';

import '../fake_storage.dart';

void main() {
  testWidgets('shows error and Retry; on Retry sync is called again and dashboard appears', (WidgetTester tester) async {
    final fakeStorage = FakeRpgStorage();
    final repo = RpgRepository(fakeStorage);
    await repo.saveSnapshot(
      const RpgSnapshot(id: '31.12.2025', label: '31.12.2025'),
      [const MunicipalityRow(municipalityName: 'Barajevo', totalRegistered: 100, totalActive: 98)],
    );
    var syncCallCount = 0;
    Future<void> syncOverride(ref) {
      syncCallCount++;
      if (syncCallCount == 1) return Future.error('network');
      return Future.value();
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repositoryProvider.overrideWithValue(repo),
          syncProvider.overrideWith(syncOverride),
        ],
        child: MaterialApp.router(routerConfig: goRouter),
      ),
    );
    await tester.pump();
    for (var i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.textContaining('Greška').evaluate().isNotEmpty) break;
    }
    await tester.pumpAndSettle();

    expect(find.textContaining('Greška'), findsAtLeast(1));
    expect(find.text('Pokušaj ponovo'), findsOneWidget);

    await tester.tap(find.text('Pokušaj ponovo'));
    await tester.pumpAndSettle();

    expect(syncCallCount, 2);
    expect(find.text('Nacionalni zbir'), findsAtLeast(1));
  });

  testWidgets('shows dashboard and dropdown when repo has data', (WidgetTester tester) async {
    final fakeStorage = FakeRpgStorage();
    final repo = RpgRepository(fakeStorage);
    await repo.saveSnapshot(
      const RpgSnapshot(id: '31.12.2025', label: '31.12.2025'),
      [
        const MunicipalityRow(municipalityName: 'Barajevo', totalRegistered: 100, totalActive: 98),
        const MunicipalityRow(municipalityName: 'Cukarica', totalRegistered: 200, totalActive: 195),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repositoryProvider.overrideWithValue(repo),
          syncProvider.overrideWith((ref) => Future.value()),
        ],
        child: MaterialApp.router(routerConfig: goRouter),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nacionalni zbir'), findsAtLeast(1));
    expect(find.textContaining('300'), findsAtLeast(1));
    expect(find.byType(DropdownButtonFormField<String?>), findsOneWidget);
  });

  testWidgets('national total is a hero block with icon and large numbers', (WidgetTester tester) async {
    final fakeStorage = FakeRpgStorage();
    final repo = RpgRepository(fakeStorage);
    await repo.saveSnapshot(
      const RpgSnapshot(id: '31.12.2025', label: '31.12.2025'),
      [
        const MunicipalityRow(municipalityName: 'Barajevo', totalRegistered: 100, totalActive: 98),
        const MunicipalityRow(municipalityName: 'Cukarica', totalRegistered: 200, totalActive: 195),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repositoryProvider.overrideWithValue(repo),
          syncProvider.overrideWith((ref) => Future.value()),
        ],
        child: MaterialApp.router(routerConfig: goRouter),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('hero_national_total')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('hero_national_total')), matching: find.byType(Icon)), findsOneWidget);
    expect(find.textContaining('300'), findsAtLeast(1));
    expect(find.textContaining('293'), findsAtLeast(1));
  });

  testWidgets('dashboard blocks have section icons', (WidgetTester tester) async {
    final fakeStorage = FakeRpgStorage();
    final repo = RpgRepository(fakeStorage);
    await repo.saveSnapshot(
      const RpgSnapshot(id: '31.12.2025', label: '31.12.2025'),
      [
        const MunicipalityRow(municipalityName: 'Barajevo', totalRegistered: 100, totalActive: 98),
        const MunicipalityRow(municipalityName: 'Cukarica', totalRegistered: 200, totalActive: 195),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repositoryProvider.overrideWithValue(repo),
          syncProvider.overrideWith((ref) => Future.value()),
        ],
        child: MaterialApp.router(routerConfig: goRouter),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('top_five_section')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('top_five_section')), matching: find.byType(Icon)), findsOneWidget);
    expect(find.byKey(const Key('municipality_dropdown_section')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('municipality_dropdown_section')), matching: find.byType(Icon)), findsAtLeast(1));
  });

  testWidgets('home shows bar chart for Top 5 opštine when data is present', (WidgetTester tester) async {
    final fakeStorage = FakeRpgStorage();
    final repo = RpgRepository(fakeStorage);
    await repo.saveSnapshot(
      const RpgSnapshot(id: '31.12.2025', label: '31.12.2025'),
      [
        const MunicipalityRow(municipalityName: 'Barajevo', totalRegistered: 100, totalActive: 98),
        const MunicipalityRow(municipalityName: 'Cukarica', totalRegistered: 200, totalActive: 195),
        const MunicipalityRow(municipalityName: 'Zemun', totalRegistered: 150, totalActive: 145),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repositoryProvider.overrideWithValue(repo),
          syncProvider.overrideWith((ref) => Future.value()),
        ],
        child: MaterialApp.router(routerConfig: goRouter),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(BarChart), findsOneWidget);
  });

  testWidgets('tap Pogledaj sve navigates to detail with municipality and snapshot', (WidgetTester tester) async {
    final fakeStorage = FakeRpgStorage();
    final repo = RpgRepository(fakeStorage);
    await repo.saveSnapshot(
      const RpgSnapshot(id: '31.12.2025', label: '31.12.2025'),
      [
        const MunicipalityRow(municipalityName: 'Barajevo', totalRegistered: 100, totalActive: 98),
        const MunicipalityRow(municipalityName: 'Cukarica', totalRegistered: 200, totalActive: 195),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repositoryProvider.overrideWithValue(repo),
          syncProvider.overrideWith((ref) => Future.value()),
        ],
        child: MaterialApp.router(routerConfig: goRouter),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byType(DropdownButtonFormField<String?>));
    await tester.tap(find.byType(DropdownButtonFormField<String?>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Barajevo').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Pogledaj sve'));
    await tester.tap(find.text('Pogledaj sve'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Barajevo'), findsAtLeast(1));
  });
}
