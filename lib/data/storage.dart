// ABOUTME: Platform-agnostic storage interface for RPG snapshot and municipality data.
// ABOUTME: Implemented by SQLite (mobile) and IndexedDB (web); no platform types here.

import 'package:rpg/data/rpg_models.dart';

/// Saves and reads snapshot metadata and per-municipality rows; no platform-specific types.
abstract class RpgStorage {
  Future<void> saveSnapshot(RpgSnapshot snapshot, List<MunicipalityRow> rows);
  Future<List<RpgSnapshot>> getSnapshotList();
  Future<NationalTotals?> getNationalTotals(String snapshotId);
  Future<List<MunicipalityRow>> getTopMunicipalities(String snapshotId, int n);
  Future<MunicipalityRow?> getMunicipality(String snapshotId, String municipalityName);
  Future<List<String>> getMunicipalityNames(String snapshotId);
}
