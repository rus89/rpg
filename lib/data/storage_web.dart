// ABOUTME: Web implementation of RpgStorage using IndexedDB via drift_flutter.
// ABOUTME: Same schema as SQLite (snapshots + holdings); driftDatabase() uses web backend.

import 'package:drift_flutter/drift_flutter.dart';
import 'package:rpg/data/local_db.dart';
import 'package:rpg/data/storage.dart';

/// Creates RpgStorage for web; persistence uses IndexedDB under the hood.
RpgStorage createWebRpgStorage() {
  final executor = driftDatabase(name: 'rpg.db');
  return SqliteRpgStorage(RpgDatabase(executor));
}
