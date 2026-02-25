// ABOUTME: Integration test: happy path Home → select opština → "Pogledaj sve" → Detail.
// ABOUTME: Uses overridden repository and sync so the test is deterministic (no network).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rpg/app/router.dart';
import 'package:rpg/app/theme.dart';
import 'package:rpg/data/repository.dart';
import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/data/storage.dart';
import 'package:rpg/providers/data_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home → dropdown → select opština → Pogledaj sve → Detail', (WidgetTester tester) async {
    final fakeStorage = _FakeRpgStorage();
    final repo = RpgRepository(fakeStorage);
    await repo.saveSnapshot(
      const RpgSnapshot(id: '31.12.2025', label: '31.12.2025'),
      [
        const OpstinaRow(opstinaName: 'Barajevo', totalRegistered: 100, totalActive: 98),
        const OpstinaRow(opstinaName: 'Cukarica', totalRegistered: 200, totalActive: 195),
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

class _FakeRpgStorage implements RpgStorage {
  final Map<String, RpgSnapshot> _snapshots = {};
  final Map<String, List<OpstinaRow>> _rows = {};

  @override
  Future<void> saveSnapshot(RpgSnapshot snapshot, List<OpstinaRow> rows) async {
    _snapshots[snapshot.id] = snapshot;
    _rows[snapshot.id] = List.from(rows);
  }

  @override
  Future<List<RpgSnapshot>> getSnapshotList() async => _snapshots.values.toList();

  @override
  Future<NationalTotals?> getNationalTotals(String snapshotId) async {
    final rows = _rows[snapshotId];
    if (rows == null || rows.isEmpty) return null;
    return NationalTotals(
      registered: rows.fold<int>(0, (s, r) => s + r.totalRegistered),
      active: rows.fold<int>(0, (s, r) => s + r.totalActive),
    );
  }

  @override
  Future<List<OpstinaRow>> getTopOpstine(String snapshotId, int n) async {
    final rows = _rows[snapshotId];
    if (rows == null) return [];
    final sorted = List<OpstinaRow>.from(rows)..sort((a, b) => b.totalActive.compareTo(a.totalActive));
    return sorted.take(n).toList();
  }

  @override
  Future<OpstinaRow?> getOpstina(String snapshotId, String opstinaName) async {
    final rows = _rows[snapshotId];
    if (rows == null) return null;
    try {
      return rows.firstWhere((r) => r.opstinaName == opstinaName);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<String>> getOpstinaNames(String snapshotId) async {
    final rows = _rows[snapshotId];
    if (rows == null) return [];
    return rows.map((r) => r.opstinaName).toSet().toList()..sort();
  }
}
