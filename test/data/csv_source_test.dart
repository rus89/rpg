// ABOUTME: Tests for CSV URL discovery and fetch from data.gov.rs RPG dataset.
// ABOUTME: Ensures at least one snapshot URL is returned, fetch returns CSV content, and Serbian letters decode correctly.

import 'package:enough_convert/windows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rpg/data/csv_source.dart';

void main() {
  late RpgCsvSource source;

  setUp(() {
    source = RpgCsvSource();
  });

  test('decodeCsvBody decodes Windows-1250 Serbian letters (č, ć, ž, š, đ)', () {
    const serbian = 'Čukarica'; // Č = 0xC8 in Windows-1250
    final bytes = const Windows1250Codec().encode(serbian);
    expect(decodeCsvBody(bytes), serbian);
  });

  test('decodeCsvBody decodes UTF-8 when valid', () {
    const text = 'Čukarica';
    final bytes = [0xC4, 0x8C, 0x75, 0x6B, 0x61, 0x72, 0x69, 0x63, 0x61]; // UTF-8 for Čukarica
    expect(decodeCsvBody(bytes), text);
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
