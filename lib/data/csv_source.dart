// ABOUTME: Discovers RPG CSV snapshot URLs from data.gov.rs and fetches CSV content.
// ABOUTME: v1 uses hardcoded permalink URLs; fetch decodes as UTF-8 with Windows-1250 then Latin-2 fallback for Serbian.

import 'dart:convert';

import 'package:enough_convert/latin.dart';
import 'package:enough_convert/windows.dart';
import 'package:http/http.dart' as http;

/// Decodes CSV response bytes. Tries UTF-8 first; on failure uses Windows-1250 (Central European / Serbian), then Latin-2.
String decodeCsvBody(List<int> bytes) {
  try {
    return utf8.decode(bytes);
  } on FormatException {
    try {
      return const Windows1250Codec(allowInvalid: true).decode(bytes);
    } on FormatException {
      return const Latin2Codec().decode(bytes);
    }
  }
}

/// A single CSV snapshot: label (e.g. date) and direct download URL.
class CsvSnapshot {
  const CsvSnapshot({required this.label, required this.url});
  final String label;
  final String url;
}

/// Abstraction for snapshot URL discovery and CSV fetch (real or fake for tests).
abstract class CsvSource {
  Future<List<CsvSnapshot>> snapshotUrls();
  Future<String> fetchCsv(String url);
}

/// Returns list of snapshot labels and CSV URLs; fetches CSV body by URL.
class RpgCsvSource implements CsvSource {
  /// Permalink URLs from data.gov.rs; server redirects to the CSV file.
  /// Dataset: https://data.gov.rs/sr/datasets/rpg-broj-svikh-registrovanikh-poljoprivrednikh-gazdinstava-aktivna-gazdinstva/
  @override
  Future<List<CsvSnapshot>> snapshotUrls() async {
    return [
      const CsvSnapshot(
        label: '31.12.2025',
        url:
            'https://data.gov.rs/sr/datasets/r/4e7d303e-5a36-41ad-b865-31add6be4ae2',
      ),
      const CsvSnapshot(
        label: '07.07.2025',
        url:
            'https://data.gov.rs/sr/datasets/r/74f95010-ba82-4596-8d6a-0600dfab719c',
      ),
      const CsvSnapshot(
        label: '31.12.2024',
        url:
            'https://data.gov.rs/sr/datasets/r/0aabec32-ceff-4707-881b-883830cb67b5',
      ),
    ];
  }

  @override
  Future<String> fetchCsv(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: $url');
    }
    return decodeCsvBody(response.bodyBytes);
  }
}
