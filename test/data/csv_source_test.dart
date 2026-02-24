// ABOUTME: Tests for CSV URL discovery and fetch from data.gov.rs RPG dataset.
// ABOUTME: Ensures at least one snapshot URL is returned and fetch returns CSV content.

import 'package:flutter_test/flutter_test.dart';
import 'package:rpg/data/csv_source.dart';

void main() {
  late RpgCsvSource source;

  setUp(() {
    source = RpgCsvSource();
  });

  test('snapshotUrls returns at least one URL', () async {
    final snapshots = await source.snapshotUrls();
    expect(snapshots, isNotEmpty);
    expect(snapshots.first.url, isNotEmpty);
    expect(snapshots.first.label, isNotEmpty);
  });

  test('fetchCsv returns non-empty CSV body for first URL', () async {
    final snapshots = await source.snapshotUrls();
    expect(snapshots, isNotEmpty);
    final body = await source.fetchCsv(snapshots.first.url);
    expect(body, contains(';'));
    expect(body.length, greaterThan(100));
  });
}
