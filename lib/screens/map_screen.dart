// ABOUTME: Map screen: tappable list of opštine; tap → Detail with name + snapshotId.
// ABOUTME: Geography: list of names from RPG data (no GeoJSON/coordinates in v1); for visual map add flutter_map + opština boundaries/coordinates later.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rpg/providers/data_providers.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotListAsync = ref.watch(snapshotListProvider);
    final snapshotId = _effectiveSnapshotId(ref);
    final namesAsync = snapshotId != null ? ref.watch(opstinaNamesProvider(snapshotId)) : const AsyncValue.data(<String>[]);

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: snapshotListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Greška: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(syncProvider),
                child: const Text('Pokušaj ponovo'),
              ),
            ],
          ),
        ),
        data: (snapshots) {
          if (snapshots.isEmpty) {
            return const Center(child: Text('Nema dostupnih snimaka.'));
          }
          return namesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Greška: $e')),
            data: (names) {
              if (names.isEmpty) {
                return const Center(child: Text('Nema opština za izabrani snimak.'));
              }
              return ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  final name = names[index];
                  return ListTile(
                    title: Text(name),
                    onTap: () => context.go(
                      '/opstina?name=${Uri.encodeComponent(name)}&snapshotId=${Uri.encodeComponent(snapshotId!)}',
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  static String? _effectiveSnapshotId(WidgetRef ref) {
    final selected = ref.watch(selectedSnapshotIdProvider);
    if (selected != null) return selected;
    final list = ref.watch(snapshotListProvider).valueOrNull;
    if (list == null || list.isEmpty) return null;
    return list.first.id;
  }
}
