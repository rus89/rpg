// ABOUTME: Home screen: national summary, top 5 opštine, opština dropdown, quick view, "Pogledaj sve".
// ABOUTME: Uses snapshotListProvider, nationalTotalsProvider, topOpstineProvider, opstinaNamesProvider; responsive layout.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/providers/data_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _selectedOpstinaName;

  @override
  Widget build(BuildContext context) {
    final snapshotListAsync = ref.watch(snapshotListProvider);
    final snapshotId = _effectiveSnapshotId(ref);
    final totalsAsync = snapshotId != null
        ? ref.watch(nationalTotalsProvider(snapshotId))
        : const AsyncValue.data(null);
    final topAsync = snapshotId != null
        ? ref.watch(topOpstineProvider((snapshotId: snapshotId, n: 5)))
        : const AsyncValue.data(<OpstinaRow>[]);
    final namesAsync = snapshotId != null
        ? ref.watch(opstinaNamesProvider(snapshotId))
        : const AsyncValue.data(<String>[]);

    return Scaffold(
      appBar: AppBar(title: const Text('Pregled')),
      body: snapshotListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Nema dostupnih snimaka.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(syncProvider),
                    child: const Text('Pokušaj ponovo'),
                  ),
                ],
              ),
            );
          }
          final snapshotLabel = snapshotId != null
              ? _labelFor(snapshots, snapshotId)
              : null;
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return SingleChildScrollView(
                padding: EdgeInsets.all(isWide ? 24 : 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWide ? 800 : double.infinity,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _NationalSummary(
                          totalsAsync: totalsAsync,
                          snapshotLabel: snapshotLabel,
                        ),
                        const SizedBox(height: 24),
                        _TopOpstine(topAsync: topAsync),
                        const SizedBox(height: 24),
                        _OpstinaDropdown(
                          namesAsync: namesAsync,
                          selectedName: _selectedOpstinaName,
                          onChanged: (name) =>
                              setState(() => _selectedOpstinaName = name),
                        ),
                        if (_selectedOpstinaName != null) ...[
                          const SizedBox(height: 16),
                          _QuickView(
                            snapshotId: snapshotId!,
                            opstinaName: _selectedOpstinaName!,
                            onPogledajSve: () {
                              context.go(
                                '/opstina?name=${Uri.encodeComponent(_selectedOpstinaName!)}&snapshotId=${Uri.encodeComponent(snapshotId)}',
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String? _effectiveSnapshotId(WidgetRef ref) {
    final selected = ref.watch(selectedSnapshotIdProvider);
    if (selected != null) return selected;
    final list = ref.watch(snapshotListProvider).valueOrNull;
    if (list == null || list.isEmpty) return null;
    return list.first.id;
  }

  static String? _labelFor(List<RpgSnapshot> snapshots, String id) {
    try {
      return snapshots.firstWhere((s) => s.id == id).label;
    } catch (_) {
      return null;
    }
  }
}

class _NationalSummary extends StatelessWidget {
  const _NationalSummary({
    required this.totalsAsync,
    required this.snapshotLabel,
  });

  final AsyncValue<NationalTotals?> totalsAsync;
  final String? snapshotLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: totalsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Greška: $e'),
          data: (totals) {
            if (totals == null) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nacionalni zbir',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (snapshotLabel != null)
                  Text(
                    'Od: $snapshotLabel',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const SizedBox(height: 8),
                Text(
                  'Registrovano: ${totals.registered}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Aktivno: ${totals.active}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopOpstine extends StatelessWidget {
  const _TopOpstine({required this.topAsync});

  final AsyncValue<List<OpstinaRow>> topAsync;

  @override
  Widget build(BuildContext context) {
    return topAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Greška: $e'),
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top 5 opština po aktivnim',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...list.map(
                  (r) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('${r.opstinaName}: ${r.totalActive} aktivno'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OpstinaDropdown extends StatelessWidget {
  const _OpstinaDropdown({
    required this.namesAsync,
    required this.selectedName,
    required this.onChanged,
  });

  final AsyncValue<List<String>> namesAsync;
  final String? selectedName;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return namesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
      data: (names) {
        if (names.isEmpty) return const SizedBox.shrink();
        return DropdownButtonFormField<String>(
          initialValue: selectedName,
          decoration: const InputDecoration(labelText: 'Opština'),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('— Izaberi opštinu —'),
            ),
            ...names.map(
              (n) => DropdownMenuItem<String>(value: n, child: Text(n)),
            ),
          ],
          onChanged: onChanged,
        );
      },
    );
  }
}

class _QuickView extends ConsumerWidget {
  const _QuickView({
    required this.snapshotId,
    required this.opstinaName,
    required this.onPogledajSve,
  });

  final String snapshotId;
  final String opstinaName;
  final VoidCallback onPogledajSve;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(
      opstinaDetailProvider((snapshotId: snapshotId, opstinaName: opstinaName)),
    );
    return detailAsync.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Greška: $e'),
        ),
      ),
      data: (row) {
        if (row == null) return const SizedBox.shrink();
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  opstinaName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text('Registrovano: ${row.totalRegistered}'),
                Text('Aktivno: ${row.totalActive}'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: onPogledajSve,
                  child: const Text('Pogledaj sve'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
