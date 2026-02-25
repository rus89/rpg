// ABOUTME: Tests for sync pipeline (fetch → parse → save) using fake CSV source.
// ABOUTME: Asserts repository contains snapshot and rows after sync with fixed CSV.

import 'package:flutter_test/flutter_test.dart';
import 'package:rpg/data/csv_source.dart';
import 'package:rpg/data/repository.dart';
import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/data/storage.dart';
import 'package:rpg/data/sync.dart';

void main() {
  late FakeCsvSource fakeSource;
  late RpgRepository repository;

  setUp(() {
    fakeSource = FakeCsvSource();
    repository = RpgRepository(FakeRpgStorage());
  });

  test('after sync with mocked CSV content repository contains snapshot and rows', () async {
    await syncFromRemote(fakeSource, repository);

    final list = await repository.getSnapshotList();
    expect(list.length, 1);
    expect(list.first.label, '31.12.2025');

    final totals = await repository.getNationalTotals('31.12.2025');
    expect(totals, isNotNull);
    expect(totals!.registered, 305);
    expect(totals.active, 298);

    final barajevo = await repository.getOpstina('31.12.2025', 'Barajevo');
    expect(barajevo, isNotNull);
    expect(barajevo!.totalRegistered, 105);
    expect(barajevo.totalActive, 103);
  });
}

/// Fake CSV source returning one snapshot and fixed CSV body for testing sync.
class FakeCsvSource implements CsvSource {
  static const _csv = '''
Regija;NazivRegije;SifraOpstine;NazivOpstineL;OrgOblik;NazivOrgOblik;broj gazdinstava;AktivnaGazdinstva
1;GRAD BEOGRAD;10;Barajevo;1;Porodicno;100;98
1;GRAD BEOGRAD;10;Barajevo;2;Preduzece;5;5
1;GRAD BEOGRAD;11;Cukarica;1;Porodicno;200;195
''';

  @override
  Future<List<CsvSnapshot>> snapshotUrls() async => [
        const CsvSnapshot(label: '31.12.2025', url: 'http://fake/1'),
      ];

  @override
  Future<String> fetchCsv(String url) async => _csv;
}

/// In-memory storage for sync tests (same as repository_test).
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
