// ABOUTME: SQLite implementation of RpgStorage using Drift (mobile).
// ABOUTME: App provides QueryExecutor via drift_flutter.driftDatabase(); web uses storage_web.

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/data/storage.dart';

part 'local_db.g.dart';

class Snapshots extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get date => text().nullable()();
  IntColumn get fetchedAt => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class Holdings extends Table {
  TextColumn get snapshotId => text()();
  TextColumn get opstinaName => text()();
  IntColumn get registered => integer()();
  IntColumn get active => integer()();
  @override
  Set<Column> get primaryKey => {snapshotId, opstinaName};
}

@DriftDatabase(tables: [Snapshots, Holdings])
class RpgDatabase extends _$RpgDatabase {
  RpgDatabase(super.e);
  @override
  int get schemaVersion => 1;
}

/// SQLite-backed RpgStorage for mobile. Pass executor from driftDatabase(name: 'rpg.db').
class SqliteRpgStorage implements RpgStorage {
  SqliteRpgStorage(this._db);
  final RpgDatabase _db;

  @override
  Future<void> saveSnapshot(RpgSnapshot snapshot, List<OpstinaRow> rows) async {
    await (_db.delete(
      _db.holdings,
    )..where((t) => t.snapshotId.equals(snapshot.id))).go();
    await (_db.delete(
      _db.snapshots,
    )..where((t) => t.id.equals(snapshot.id))).go();
    await _db
        .into(_db.snapshots)
        .insert(
          SnapshotsCompanion.insert(
            id: snapshot.id,
            label: snapshot.label,
            date: Value(null),
            fetchedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
    for (final row in rows) {
      await _db
          .into(_db.holdings)
          .insert(
            HoldingsCompanion.insert(
              snapshotId: snapshot.id,
              opstinaName: row.opstinaName,
              registered: row.totalRegistered,
              active: row.totalActive,
            ),
          );
    }
  }

  @override
  Future<List<RpgSnapshot>> getSnapshotList() async {
    final list = await (_db.select(_db.snapshots)).get();
    return list.map((r) => RpgSnapshot(id: r.id, label: r.label)).toList();
  }

  @override
  Future<NationalTotals?> getNationalTotals(String snapshotId) async {
    final rows = await (_db.select(
      _db.holdings,
    )..where((t) => t.snapshotId.equals(snapshotId))).get();
    if (rows.isEmpty) return null;
    final registered = rows.fold<int>(0, (s, r) => s + r.registered);
    final active = rows.fold<int>(0, (s, r) => s + r.active);
    return NationalTotals(registered: registered, active: active);
  }

  @override
  Future<List<OpstinaRow>> getTopOpstine(String snapshotId, int n) async {
    final rows =
        await (_db.select(_db.holdings)
              ..where((t) => t.snapshotId.equals(snapshotId))
              ..orderBy([(t) => OrderingTerm.desc(t.active)]))
            .get();
    return rows
        .take(n)
        .map(
          (r) => OpstinaRow(
            opstinaName: r.opstinaName,
            totalRegistered: r.registered,
            totalActive: r.active,
          ),
        )
        .toList();
  }

  @override
  Future<OpstinaRow?> getOpstina(String snapshotId, String opstinaName) async {
    final row =
        await (_db.select(_db.holdings)..where(
              (t) =>
                  t.snapshotId.equals(snapshotId) &
                  t.opstinaName.equals(opstinaName),
            ))
            .getSingleOrNull();
    if (row == null) return null;
    return OpstinaRow(
      opstinaName: row.opstinaName,
      totalRegistered: row.registered,
      totalActive: row.active,
    );
  }

  @override
  Future<List<String>> getOpstinaNames(String snapshotId) async {
    final rows =
        await (_db.select(_db.holdings)..where(
              (t) => t.snapshotId.equals(snapshotId),
            ))
            .get();
    final names = rows.map((r) => r.opstinaName).toSet().toList()..sort();
    return names;
  }
}

/// Creates RpgStorage for native (iOS/Android); persistence uses SQLite via path_provider.
RpgStorage createNativeRpgStorage() {
  final executor = driftDatabase(name: 'rpg.db');
  return SqliteRpgStorage(RpgDatabase(executor));
}
