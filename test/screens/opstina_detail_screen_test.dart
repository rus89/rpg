// ABOUTME: Widget tests for Opština detail screen: totals, snapshot label, overridden provider.
// ABOUTME: Overrides repository and sync; expects totals, "as of" label, back button.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rpg/data/repository.dart';
import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/data/storage.dart';
import 'package:rpg/providers/data_providers.dart';
import 'package:rpg/screens/opstina_detail_screen.dart';

void main() {
  testWidgets('shows totals and snapshot label when repo has data', (WidgetTester tester) async {
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
        child: MaterialApp(
          home: OpstinaDetailScreen(name: 'Barajevo', snapshotId: '31.12.2025'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Barajevo'), findsAtLeast(1));
    expect(find.textContaining('100'), findsAtLeast(1));
    expect(find.textContaining('98'), findsAtLeast(1));
    expect(find.textContaining('31.12.2025'), findsAtLeast(1));
  });

  testWidgets('shows back button', (WidgetTester tester) async {
    final fakeStorage = FakeRpgStorage();
    final repo = RpgRepository(fakeStorage);
    await repo.saveSnapshot(
      const RpgSnapshot(id: '31.12.2025', label: '31.12.2025'),
      [const OpstinaRow(opstinaName: 'Cukarica', totalRegistered: 200, totalActive: 195)],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repositoryProvider.overrideWithValue(repo),
          syncProvider.overrideWith((ref) => Future.value()),
        ],
        child: MaterialApp(
          home: OpstinaDetailScreen(name: 'Cukarica', snapshotId: '31.12.2025'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(BackButton), findsOneWidget);
  });
}

class FakeRpgStorage implements RpgStorage {
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
