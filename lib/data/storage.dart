// ABOUTME: Platform-agnostic storage interface for RPG snapshot and opština data.
// ABOUTME: Implemented by SQLite (mobile) and IndexedDB (web); no platform types here.

import 'package:rpg/data/rpg_models.dart';

/// Saves and reads snapshot metadata and per-opština rows; no platform-specific types.
abstract class RpgStorage {
  Future<void> saveSnapshot(RpgSnapshot snapshot, List<OpstinaRow> rows);
  Future<List<RpgSnapshot>> getSnapshotList();
  Future<NationalTotals?> getNationalTotals(String snapshotId);
  Future<List<OpstinaRow>> getTopOpstine(String snapshotId, int n);
  Future<OpstinaRow?> getOpstina(String snapshotId, String opstinaName);
}
