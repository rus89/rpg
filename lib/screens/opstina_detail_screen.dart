// ABOUTME: Opština detail screen: totals, "as of" snapshot label, snapshot switcher, back button.
// ABOUTME: Reads name and snapshotId from route; uses opstinaDetailProvider and snapshotListProvider.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/providers/data_providers.dart';

class OpstinaDetailScreen extends ConsumerWidget {
  const OpstinaDetailScreen({super.key, this.name, this.snapshotId});

  final String? name;
  final String? snapshotId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (name == null || name!.isEmpty || snapshotId == null || snapshotId!.isEmpty) {
      return Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('Opština nije izabrana.')),
      );
    }

    final detailAsync = ref.watch(opstinaDetailProvider((snapshotId: snapshotId!, opstinaName: name!)));
    final snapshotListAsync = ref.watch(snapshotListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(name!),
      ),
      body: snapshotListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Greška: $e')),
        data: (snapshots) {
          final label = _labelFor(snapshots, snapshotId!);
          return detailAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Greška: $e')),
            data: (row) {
              if (row == null) {
                return Center(child: Text('Nema podataka za opštinu $name.'));
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (snapshots.length > 1) ...[
                      _SnapshotSwitcher(
                        snapshots: snapshots,
                        currentId: snapshotId!,
                        opstinaName: name!,
                      ),
                      const SizedBox(height: 16),
                    ],
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (label != null) ...[
                              Text('Od: $label', style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 8),
                            ],
                            Text('Registrovano: ${row.totalRegistered}', style: Theme.of(context).textTheme.bodyLarge),
                            Text('Aktivno: ${row.totalActive}', style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  static String? _labelFor(List<RpgSnapshot> snapshots, String id) {
    try {
      return snapshots.firstWhere((s) => s.id == id).label;
    } catch (_) {
      return null;
    }
  }
}

class _SnapshotSwitcher extends StatelessWidget {
  const _SnapshotSwitcher({
    required this.snapshots,
    required this.currentId,
    required this.opstinaName,
  });

  final List<RpgSnapshot> snapshots;
  final String currentId;
  final String opstinaName;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: currentId,
      decoration: const InputDecoration(labelText: 'Snimak'),
      items: snapshots.map((s) => DropdownMenuItem(value: s.id, child: Text(s.label))).toList(),
      onChanged: (id) {
        if (id != null) {
          context.go('/opstina?name=${Uri.encodeComponent(opstinaName)}&snapshotId=${Uri.encodeComponent(id)}');
        }
      },
    );
  }
}
