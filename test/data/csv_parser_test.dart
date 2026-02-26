// ABOUTME: Tests for parsing RPG CSV into domain models (semicolon, aggregate by municipality).
// ABOUTME: Uses inline sample CSV matching data.gov.rs column structure.

import 'package:flutter_test/flutter_test.dart';
import 'package:rpg/data/csv_parser.dart';

void main() {
  const sampleCsv = '''
Regija;NazivRegije;SifraOpstine;NazivOpstineL;OrgOblik;NazivOrgOblik;broj gazdinstava;AktivnaGazdinstva
1;GRAD BEOGRAD;10;Barajevo;1;Porodicno;100;98
1;GRAD BEOGRAD;10;Barajevo;2;Preduzece;5;5
1;GRAD BEOGRAD;11;Cukarica;1;Porodicno;200;195
''';

  test('parse returns two municipalities when one has two org-form rows', () {
    final result = parseRpgCsv(sampleCsv, snapshotLabel: '31.12.2025');
    expect(result.rows.length, 2);
  });

  test('parse aggregates Barajevo registered and active from two rows', () {
    final result = parseRpgCsv(sampleCsv, snapshotLabel: '31.12.2025');
    final barajevo = result.rows.where((r) => r.municipalityName == 'Barajevo').single;
    expect(barajevo.totalRegistered, 105);
    expect(barajevo.totalActive, 103);
  });

  test('parse returns snapshot label', () {
    final result = parseRpgCsv(sampleCsv, snapshotLabel: '31.12.2025');
    expect(result.snapshotLabel, '31.12.2025');
  });

  test('parse Cukarica single row', () {
    final result = parseRpgCsv(sampleCsv, snapshotLabel: '31.12.2025');
    final cukarica = result.rows.where((r) => r.municipalityName == 'Cukarica').single;
    expect(cukarica.totalRegistered, 200);
    expect(cukarica.totalActive, 195);
  });

  test('parse repairs corrupted names (? for č, ć, đ) from dataset', () {
    final lines = sampleCsv
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    final twoLineCsv = '${lines[0]}\n${lines[1]}';
    final resultBarajevo = parseRpgCsv(twoLineCsv, snapshotLabel: '31.12.2025');
    expect(resultBarajevo.rows.length, 1);
    expect(resultBarajevo.rows.single.municipalityName, 'Barajevo');

    final header = lines[0];
    final dataRow = '1;SUMADIJA;1;?a?ak;1;Porodicno;500;480';
    final result = parseRpgCsv('$header\n$dataRow', snapshotLabel: '31.12.2025');
    expect(result.rows.length, 1);
    expect(result.rows.single.municipalityName, 'Čačak');
    expect(result.rows.single.totalRegistered, 500);
    expect(result.rows.single.totalActive, 480);
  });
}
