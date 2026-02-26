// ABOUTME: Municipality detail screen: totals, "as of" snapshot label, snapshot switcher, back button.
// ABOUTME: Reads name and snapshotId from route; uses municipalityDetailProvider and snapshotListProvider.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/providers/data_providers.dart';
import 'package:rpg/widgets/data_card.dart';

class MunicipalityDetailScreen extends ConsumerWidget {
  const MunicipalityDetailScreen({super.key, this.name, this.snapshotId});

  final String? name;
  final String? snapshotId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (name == null || name!.isEmpty || snapshotId == null || snapshotId!.isEmpty) {
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
        body: Center(child: Text('Opština nije izabrana.', style: Theme.of(context).textTheme.bodyLarge)),
      );
    }

    final detailAsync = ref.watch(municipalityDetailProvider((snapshotId: snapshotId!, municipalityName: name!)));
    final snapshotListAsync = ref.watch(snapshotListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(name!),
      ),
      body: snapshotListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Greška: $e', style: Theme.of(context).textTheme.bodyMedium)),
        data: (snapshots) {
          final label = _labelFor(snapshots, snapshotId!);
          return detailAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Greška: $e', style: Theme.of(context).textTheme.bodyMedium)),
            data: (row) {
              if (row == null) {
                return Center(child: Text('Nema podataka za opštinu $name.', style: Theme.of(context).textTheme.bodyLarge));
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
                        municipalityName: name!,
                      ),
                      const SizedBox(height: 16),
                    ],
                    DataCard(
                      subtitle: label != null ? 'Od: $label' : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Registrovano: ${row.totalRegistered}', style: Theme.of(context).textTheme.bodyLarge),
                          Text('Aktivno: ${row.totalActive}', style: Theme.of(context).textTheme.bodyLarge),
                        ],
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
    required this.municipalityName,
  });

  final List<RpgSnapshot> snapshots;
  final String currentId;
  final String municipalityName;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: currentId,
      decoration: const InputDecoration(labelText: 'Snimak'),
      items: snapshots.map((s) => DropdownMenuItem(value: s.id, child: Text(s.label))).toList(),
      onChanged: (id) {
        if (id != null) {
          context.go('/municipality?name=${Uri.encodeComponent(municipalityName)}&snapshotId=${Uri.encodeComponent(id)}');
        }
      },
    );
  }
}
