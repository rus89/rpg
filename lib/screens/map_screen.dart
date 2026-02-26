// ABOUTME: Map screen: tappable list of municipalities; tap → Detail with name + snapshotId.
// ABOUTME: Geography: list of names from RPG data (no GeoJSON/coordinates in v1); for visual map add flutter_map + boundaries/coordinates later.

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
    final namesAsync = snapshotId != null ? ref.watch(municipalityNamesProvider(snapshotId)) : const AsyncValue.data(<String>[]);

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: snapshotListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Greška: $e', style: Theme.of(context).textTheme.bodyLarge),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Nema dostupnih snimaka.', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(syncProvider),
                    child: const Text('Pokušaj ponovo'),
                  ),
                ],
              ),
            );
          }
          return namesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Greška: $e', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(syncProvider),
                    child: const Text('Pokušaj ponovo'),
                  ),
                ],
              ),
            ),
            data: (names) {
              if (names.isEmpty) {
                return Center(child: Text('Nema opština za izabrani snimak.', style: Theme.of(context).textTheme.bodyLarge));
              }
              return ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  final name = names[index];
                  return ListTile(
                    title: Text(name),
                    onTap: () => context.push(
                      '/municipality?name=${Uri.encodeComponent(name)}&snapshotId=${Uri.encodeComponent(snapshotId!)}',
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
