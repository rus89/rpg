// ABOUTME: Integration test: happy path Home → select municipality → "Pogledaj sve" → Detail.
// ABOUTME: Uses overridden repository and sync so the test is deterministic (no network).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rpg/app/router.dart';
import 'package:rpg/app/theme.dart';
import 'package:rpg/data/repository.dart';
import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/providers/data_providers.dart';

import '../test/fake_storage.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home → dropdown → select municipality → Pogledaj sve → Detail', (WidgetTester tester) async {
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
        child: MaterialApp.router(
          theme: appTheme,
          darkTheme: appDarkTheme,
          routerConfig: goRouter,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nacionalni zbir'), findsAtLeast(1));
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Barajevo').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Pogledaj sve'));
    await tester.tap(find.text('Pogledaj sve'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Barajevo'), findsAtLeast(1));
    expect(find.byType(BackButton), findsOneWidget);
  });
}
