// ABOUTME: Riverpod providers for RPG data; sync on app start, AsyncValue for loading/error.
// ABOUTME: Repository and sync are overridable for tests.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpg/app/storage_bootstrap.dart';
import 'package:rpg/data/csv_source.dart';
import 'package:rpg/data/repository.dart';
import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/data/sync.dart';

final repositoryProvider = Provider<RpgRepository>((ref) {
  return RpgRepository(rpgStorage);
});

final csvSourceProvider = Provider<CsvSource>((ref) => RpgCsvSource());

/// Runs sync once when first read; providers that depend on data watch this first.
final syncProvider = FutureProvider.autoDispose<void>((ref) async {
  await syncFromRemote(ref.read(csvSourceProvider), ref.read(repositoryProvider));
});

final snapshotListProvider = FutureProvider.autoDispose<List<RpgSnapshot>>((ref) async {
  await ref.watch(syncProvider.future);
  return ref.read(repositoryProvider).getSnapshotList();
});

final selectedSnapshotIdProvider = StateProvider<String?>((ref) => null);

final nationalTotalsProvider = FutureProvider.autoDispose.family<NationalTotals?, String>(
  (ref, snapshotId) async {
    await ref.watch(syncProvider.future);
    return ref.read(repositoryProvider).getNationalTotals(snapshotId);
  },
);

final topOpstineProvider = FutureProvider.autoDispose.family<List<OpstinaRow>, ({String snapshotId, int n})>(
  (ref, params) async {
    await ref.watch(syncProvider.future);
    return ref.read(repositoryProvider).getTopOpstine(params.snapshotId, params.n);
  },
);

final opstinaDetailProvider = FutureProvider.autoDispose.family<OpstinaRow?, ({String snapshotId, String opstinaName})>(
  (ref, params) async {
    await ref.watch(syncProvider.future);
    return ref.read(repositoryProvider).getOpstina(params.snapshotId, params.opstinaName);
  },
);

/// List of opština names for the selected snapshot (for dropdown).
final opstinaNamesProvider = FutureProvider.autoDispose.family<List<String>, String>(
  (ref, snapshotId) async {
    await ref.watch(syncProvider.future);
    return ref.read(repositoryProvider).getOpstinaNames(snapshotId);
  },
);
