// ABOUTME: Parses RPG CSV (semicolon-delimited) into snapshot label and opština rows.
// ABOUTME: Aggregates by opština (NazivOpstineL); repairs names where dataset has ? for č, ć, đ.

import 'package:rpg/data/opstina_name_repair.dart';
import 'package:rpg/data/rpg_models.dart';

/// Result of parsing one CSV: snapshot label and aggregated rows per opština.
class ParsedRpgCsv {
  const ParsedRpgCsv({required this.snapshotLabel, required this.rows});
  final String snapshotLabel;
  final List<OpstinaRow> rows;
}

/// Parses semicolon-delimited CSV; aggregates by NazivOpstineL into OpstinaRow.
ParsedRpgCsv parseRpgCsv(String csv, {required String snapshotLabel}) {
  const delimiter = ';';
  final lines = csv
      .split(RegExp(r'\r?\n'))
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();
  if (lines.isEmpty) return ParsedRpgCsv(snapshotLabel: snapshotLabel, rows: []);
  final header = lines[0].split(delimiter).map((c) => c.trim()).toList();
  final nameIdx = header.indexOf('NazivOpstineL');
  final registeredIdx = header.indexOf('broj gazdinstava');
  final activeIdx = header.indexOf('AktivnaGazdinstva');
  if (nameIdx < 0 || registeredIdx < 0 || activeIdx < 0) {
    return ParsedRpgCsv(snapshotLabel: snapshotLabel, rows: []);
  }
  final byOpstina = <String, ({int registered, int active})>{};
  for (var i = 1; i < lines.length; i++) {
    final cols = lines[i].split(delimiter);
    if (cols.length <= nameIdx || cols.length <= registeredIdx || cols.length <= activeIdx) continue;
    final rawName = cols[nameIdx].trim();
    final name = repairOpstinaName(rawName);
    final registered = int.tryParse(cols[registeredIdx].trim()) ?? 0;
    final active = int.tryParse(cols[activeIdx].trim()) ?? 0;
    final prev = byOpstina[name];
    if (prev == null) {
      byOpstina[name] = (registered: registered, active: active);
    } else {
      byOpstina[name] = (registered: prev.registered + registered, active: prev.active + active);
    }
  }
  final rows = byOpstina.entries
      .map((e) => OpstinaRow(
            opstinaName: e.key,
            totalRegistered: e.value.registered,
            totalActive: e.value.active,
          ))
      .toList();
  return ParsedRpgCsv(snapshotLabel: snapshotLabel, rows: rows);
}
