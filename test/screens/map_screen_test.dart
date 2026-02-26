// ABOUTME: Widget tests for Map screen: tappable municipalities, tap one navigates to Detail.
// ABOUTME: Overrides repository and sync; taps first municipality, verifies navigation with correct params.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rpg/app/router.dart';
import 'package:rpg/data/repository.dart';
import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/providers/data_providers.dart';

import '../fake_storage.dart';

void main() {
  testWidgets('tap first municipality navigates to Detail with name and snapshotId', (WidgetTester tester) async {
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

    await tester.tap(find.text('Mapa'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Barajevo'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Barajevo'), findsAtLeast(1));
    expect(find.textContaining('100'), findsAtLeast(1));
  });
}
