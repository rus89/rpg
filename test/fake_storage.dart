// ABOUTME: In-memory RpgStorage implementation for tests (no SQLite or IndexedDB).
// ABOUTME: Used by router and opstina detail screen tests.

import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/data/storage.dart';

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
