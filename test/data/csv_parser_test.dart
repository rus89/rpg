// ABOUTME: Tests for parsing RPG CSV into domain models (semicolon, aggregate by opština).
// ABOUTME: Uses inline sample CSV matching data.gov.rs column structure.

import 'package:flutter_test/flutter_test.dart';
import 'package:rpg/data/csv_parser.dart';
import 'package:rpg/data/rpg_models.dart';

void main() {
  const sampleCsv = '''
Regija;NazivRegije;SifraOpstine;NazivOpstineL;OrgOblik;NazivOrgOblik;broj gazdinstava;AktivnaGazdinstva
1;GRAD BEOGRAD;10;Barajevo;1;Porodicno;100;98
1;GRAD BEOGRAD;10;Barajevo;2;Preduzece;5;5
1;GRAD BEOGRAD;11;Cukarica;1;Porodicno;200;195
''';

  test('parse returns two opštine when one has two org-form rows', () {
    final result = parseRpgCsv(sampleCsv, snapshotLabel: '31.12.2025');
    expect(result.rows.length, 2);
  });

  test('parse aggregates Barajevo registered and active from two rows', () {
    final result = parseRpgCsv(sampleCsv, snapshotLabel: '31.12.2025');
    final barajevo = result.rows.where((r) => r.opstinaName == 'Barajevo').single;
    expect(barajevo.totalRegistered, 105);
    expect(barajevo.totalActive, 103);
  });

  test('parse returns snapshot label', () {
    final result = parseRpgCsv(sampleCsv, snapshotLabel: '31.12.2025');
    expect(result.snapshotLabel, '31.12.2025');
  });

  test('parse Cukarica single row', () {
    final result = parseRpgCsv(sampleCsv, snapshotLabel: '31.12.2025');
    final cukarica = result.rows.where((r) => r.opstinaName == 'Cukarica').single;
    expect(cukarica.totalRegistered, 200);
    expect(cukarica.totalActive, 195);
  });
}
