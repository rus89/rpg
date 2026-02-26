// ABOUTME: Tests for sync pipeline (fetch → parse → save) using fake CSV source.
// ABOUTME: Asserts repository contains snapshot and rows after sync with fixed CSV.

import 'package:flutter_test/flutter_test.dart';
import 'package:rpg/data/csv_source.dart';
import 'package:rpg/data/repository.dart';
import 'package:rpg/data/sync.dart';

import '../fake_storage.dart';

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

    final barajevo = await repository.getMunicipality('31.12.2025', 'Barajevo');
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
