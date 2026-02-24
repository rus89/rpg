// ABOUTME: Tests for RpgRepository using fake in-memory storage (no SQLite).
// ABOUTME: Saves one snapshot with 2–3 rows; asserts getSnapshotList, getNationalTotals, getTopOpstine, getOpstina.

import 'package:flutter_test/flutter_test.dart';
import 'package:rpg/data/repository.dart';
import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/data/storage.dart';

void main() {
  late FakeRpgStorage fakeStorage;
  late RpgRepository repository;

  setUp(() {
    fakeStorage = FakeRpgStorage();
    repository = RpgRepository(fakeStorage);
  });

  test('getSnapshotList returns saved snapshot', () async {
    final snapshot = const RpgSnapshot(id: '31.12.2025', label: '31.12.2025');
    final rows = [
      const OpstinaRow(opstinaName: 'Barajevo', totalRegistered: 100, totalActive: 98),
      const OpstinaRow(opstinaName: 'Cukarica', totalRegistered: 200, totalActive: 195),
      const OpstinaRow(opstinaName: 'Grocka', totalRegistered: 150, totalActive: 145),
    ];
    await repository.saveSnapshot(snapshot, rows);

    final list = await repository.getSnapshotList();
    expect(list.length, 1);
    expect(list.first.id, '31.12.2025');
    expect(list.first.label, '31.12.2025');
  });

  test('getNationalTotals returns sum of all opštine for snapshot', () async {
    final snapshot = const RpgSnapshot(id: '31.12.2025', label: '31.12.2025');
    final rows = [
      const OpstinaRow(opstinaName: 'Barajevo', totalRegistered: 100, totalActive: 98),
      const OpstinaRow(opstinaName: 'Cukarica', totalRegistered: 200, totalActive: 195),
    ];
    await repository.saveSnapshot(snapshot, rows);

    final totals = await repository.getNationalTotals('31.12.2025');
    expect(totals, isNotNull);
    expect(totals!.registered, 300);
    expect(totals.active, 293);
  });

  test('getTopOpstine returns top n by active count descending', () async {
    final snapshot = const RpgSnapshot(id: '31.12.2025', label: '31.12.2025');
    final rows = [
      const OpstinaRow(opstinaName: 'Barajevo', totalRegistered: 100, totalActive: 98),
      const OpstinaRow(opstinaName: 'Cukarica', totalRegistered: 200, totalActive: 195),
      const OpstinaRow(opstinaName: 'Grocka', totalRegistered: 150, totalActive: 145),
    ];
    await repository.saveSnapshot(snapshot, rows);

    final top = await repository.getTopOpstine('31.12.2025', 2);
    expect(top.length, 2);
    expect(top[0].opstinaName, 'Cukarica');
    expect(top[0].totalActive, 195);
    expect(top[1].opstinaName, 'Grocka');
    expect(top[1].totalActive, 145);
  });

  test('getOpstina returns row for given snapshot and name', () async {
    final snapshot = const RpgSnapshot(id: '31.12.2025', label: '31.12.2025');
    final rows = [
      const OpstinaRow(opstinaName: 'Barajevo', totalRegistered: 100, totalActive: 98),
      const OpstinaRow(opstinaName: 'Cukarica', totalRegistered: 200, totalActive: 195),
    ];
    await repository.saveSnapshot(snapshot, rows);

    final row = await repository.getOpstina('31.12.2025', 'Cukarica');
    expect(row, isNotNull);
    expect(row!.opstinaName, 'Cukarica');
    expect(row.totalRegistered, 200);
    expect(row.totalActive, 195);
  });

  test('getOpstina returns null for unknown opština', () async {
    final snapshot = const RpgSnapshot(id: '31.12.2025', label: '31.12.2025');
    await repository.saveSnapshot(snapshot, [
      const OpstinaRow(opstinaName: 'Barajevo', totalRegistered: 100, totalActive: 98),
    ]);

    final row = await repository.getOpstina('31.12.2025', 'Unknown');
    expect(row, isNull);
  });
}

/// In-memory implementation of RpgStorage for tests.
class FakeRpgStorage implements RpgStorage {
  final Map<String, RpgSnapshot> _snapshots = {};
  final Map<String, List<OpstinaRow>> _rows = {};

  @override
  Future<void> saveSnapshot(RpgSnapshot snapshot, List<OpstinaRow> rows) async {
    _snapshots[snapshot.id] = snapshot;
    _rows[snapshot.id] = List.from(rows);
  }

  @override
  Future<List<RpgSnapshot>> getSnapshotList() async {
    return _snapshots.values.toList();
  }

  @override
  Future<NationalTotals?> getNationalTotals(String snapshotId) async {
    final rows = _rows[snapshotId];
    if (rows == null || rows.isEmpty) return null;
    final registered = rows.fold<int>(0, (s, r) => s + r.totalRegistered);
    final active = rows.fold<int>(0, (s, r) => s + r.totalActive);
    return NationalTotals(registered: registered, active: active);
  }

  @override
  Future<List<OpstinaRow>> getTopOpstine(String snapshotId, int n) async {
    final rows = _rows[snapshotId];
    if (rows == null) return [];
    final sorted = List<OpstinaRow>.from(rows)
      ..sort((a, b) => b.totalActive.compareTo(a.totalActive));
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
