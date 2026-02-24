// ABOUTME: Repository that delegates to RpgStorage; used by sync and Riverpod.
// ABOUTME: Storage implementation (SQLite vs web) is injected by the app.

import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/data/storage.dart';

/// Exposes storage API for sync and UI; forwards all calls to injected [RpgStorage].
class RpgRepository {
  RpgRepository(this._storage);
  final RpgStorage _storage;

  Future<void> saveSnapshot(RpgSnapshot snapshot, List<OpstinaRow> rows) =>
      _storage.saveSnapshot(snapshot, rows);

  Future<List<RpgSnapshot>> getSnapshotList() => _storage.getSnapshotList();

  Future<NationalTotals?> getNationalTotals(String snapshotId) =>
      _storage.getNationalTotals(snapshotId);

  Future<List<OpstinaRow>> getTopOpstine(String snapshotId, int n) =>
      _storage.getTopOpstine(snapshotId, n);

  Future<OpstinaRow?> getOpstina(String snapshotId, String opstinaName) =>
      _storage.getOpstina(snapshotId, opstinaName);
}
