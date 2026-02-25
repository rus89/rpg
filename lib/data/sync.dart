// ABOUTME: Syncs RPG data from remote: fetch CSV per snapshot, parse, save via repository.
// ABOUTME: Called on app start or refresh; snapshot identity is label from source.

import 'package:rpg/data/csv_parser.dart';
import 'package:rpg/data/csv_source.dart';
import 'package:rpg/data/repository.dart';
import 'package:rpg/data/rpg_models.dart';

/// Fetches each snapshot URL from [source], parses CSV, saves to [repository].
Future<void> syncFromRemote(CsvSource source, RpgRepository repository) async {
  final snapshots = await source.snapshotUrls();
  for (final s in snapshots) {
    final body = await source.fetchCsv(s.url);
    final parsed = parseRpgCsv(body, snapshotLabel: s.label);
    final snapshot = RpgSnapshot(id: parsed.snapshotLabel, label: parsed.snapshotLabel);
    await repository.saveSnapshot(snapshot, parsed.rows);
  }
}
