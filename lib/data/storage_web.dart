// ABOUTME: Web implementation of RpgStorage using IndexedDB via drift_flutter.
// ABOUTME: Same schema as SQLite (snapshots + holdings); driftDatabase() uses web backend.

import 'package:drift_flutter/drift_flutter.dart';
import 'package:rpg/data/local_db.dart';
import 'package:rpg/data/storage.dart';

/// Creates RpgStorage for web; persistence uses IndexedDB/WASM (sqlite3.wasm + drift_worker.js in web/).
/// Resolves worker and wasm URIs from [Uri.base] so they load correctly regardless of document URL.
RpgStorage createWebRpgStorage() {
  final base = Uri.base;
  final executor = driftDatabase(
    name: 'rpg.db',
    web: DriftWebOptions(
      sqlite3Wasm: base.resolve('sqlite3.wasm'),
      driftWorker: base.resolve('drift_worker.js'),
    ),
  );
  return SqliteRpgStorage(RpgDatabase(executor));
}
