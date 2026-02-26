// ABOUTME: Tests for RpgRepository using fake in-memory storage (no SQLite).
// ABOUTME: Saves one snapshot with 2–3 rows; asserts getSnapshotList, getNationalTotals, getTopMunicipalities, getMunicipality.

import 'package:flutter_test/flutter_test.dart';
import 'package:rpg/data/repository.dart';
import 'package:rpg/data/rpg_models.dart';

import '../fake_storage.dart';

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
      const MunicipalityRow(municipalityName: 'Barajevo', totalRegistered: 100, totalActive: 98),
      const MunicipalityRow(municipalityName: 'Cukarica', totalRegistered: 200, totalActive: 195),
      const MunicipalityRow(municipalityName: 'Grocka', totalRegistered: 150, totalActive: 145),
    ];
    await repository.saveSnapshot(snapshot, rows);

    final list = await repository.getSnapshotList();
    expect(list.length, 1);
    expect(list.first.id, '31.12.2025');
    expect(list.first.label, '31.12.2025');
  });

  test('getNationalTotals returns sum of all municipalities for snapshot', () async {
    final snapshot = const RpgSnapshot(id: '31.12.2025', label: '31.12.2025');
    final rows = [
      const MunicipalityRow(municipalityName: 'Barajevo', totalRegistered: 100, totalActive: 98),
      const MunicipalityRow(municipalityName: 'Cukarica', totalRegistered: 200, totalActive: 195),
    ];
    await repository.saveSnapshot(snapshot, rows);

    final totals = await repository.getNationalTotals('31.12.2025');
    expect(totals, isNotNull);
    expect(totals!.registered, 300);
    expect(totals.active, 293);
  });

  test('getTopMunicipalities returns top n by active count descending', () async {
    final snapshot = const RpgSnapshot(id: '31.12.2025', label: '31.12.2025');
    final rows = [
      const MunicipalityRow(municipalityName: 'Barajevo', totalRegistered: 100, totalActive: 98),
      const MunicipalityRow(municipalityName: 'Cukarica', totalRegistered: 200, totalActive: 195),
      const MunicipalityRow(municipalityName: 'Grocka', totalRegistered: 150, totalActive: 145),
    ];
    await repository.saveSnapshot(snapshot, rows);

    final top = await repository.getTopMunicipalities('31.12.2025', 2);
    expect(top.length, 2);
    expect(top[0].municipalityName, 'Cukarica');
    expect(top[0].totalActive, 195);
    expect(top[1].municipalityName, 'Grocka');
    expect(top[1].totalActive, 145);
  });

  test('getMunicipality returns row for given snapshot and name', () async {
    final snapshot = const RpgSnapshot(id: '31.12.2025', label: '31.12.2025');
    final rows = [
      const MunicipalityRow(municipalityName: 'Barajevo', totalRegistered: 100, totalActive: 98),
      const MunicipalityRow(municipalityName: 'Cukarica', totalRegistered: 200, totalActive: 195),
    ];
    await repository.saveSnapshot(snapshot, rows);

    final row = await repository.getMunicipality('31.12.2025', 'Cukarica');
    expect(row, isNotNull);
    expect(row!.municipalityName, 'Cukarica');
    expect(row.totalRegistered, 200);
    expect(row.totalActive, 195);
  });

  test('getMunicipality returns null for unknown municipality', () async {
    final snapshot = const RpgSnapshot(id: '31.12.2025', label: '31.12.2025');
    await repository.saveSnapshot(snapshot, [
      const MunicipalityRow(municipalityName: 'Barajevo', totalRegistered: 100, totalActive: 98),
    ]);

    final row = await repository.getMunicipality('31.12.2025', 'Unknown');
    expect(row, isNull);
  });
}
