// ABOUTME: Tests for Riverpod data providers using overridden repository.
// ABOUTME: Fake repository with data; expect snapshotListProvider yields list.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rpg/data/repository.dart';
import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/data/storage.dart';
import 'package:rpg/providers/data_providers.dart';

void main() {
  test('snapshotListProvider returns list after fake repo has data', () async {
    final fakeStorage = FakeRpgStorage();
    final repo = RpgRepository(fakeStorage);
    await repo.saveSnapshot(
      const RpgSnapshot(id: '31.12.2025', label: '31.12.2025'),
      [
        const OpstinaRow(opstinaName: 'Barajevo', totalRegistered: 100, totalActive: 98),
      ],
    );

    final container = ProviderContainer(
      overrides: [
        repositoryProvider.overrideWithValue(repo),
        syncProvider.overrideWith((ref) => Future.value()),
      ],
    );
    addTearDown(container.dispose);

    final list = await container.read(snapshotListProvider.future);
    expect(list.length, 1);
    expect(list.first.id, '31.12.2025');
    expect(list.first.label, '31.12.2025');
  });

  test('nationalTotalsProvider returns totals for snapshot', () async {
    final fakeStorage = FakeRpgStorage();
    final repo = RpgRepository(fakeStorage);
    await repo.saveSnapshot(
      const RpgSnapshot(id: '31.12.2025', label: '31.12.2025'),
      [
        const OpstinaRow(opstinaName: 'Barajevo', totalRegistered: 100, totalActive: 98),
        const OpstinaRow(opstinaName: 'Cukarica', totalRegistered: 200, totalActive: 195),
      ],
    );

    final container = ProviderContainer(
      overrides: [
        repositoryProvider.overrideWithValue(repo),
        syncProvider.overrideWith((ref) => Future.value()),
      ],
    );
    addTearDown(container.dispose);

    final totals = await container.read(nationalTotalsProvider('31.12.2025').future);
    expect(totals, isNotNull);
    expect(totals!.registered, 300);
    expect(totals.active, 293);
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
}
