// ABOUTME: Home screen: national summary, top 5 municipalities, municipality dropdown, quick view, "Pogledaj sve".
// ABOUTME: Uses snapshotListProvider, nationalTotalsProvider, topMunicipalitiesProvider, municipalityNamesProvider; responsive layout.

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/providers/data_providers.dart';
import 'package:rpg/widgets/data_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _selectedMunicipalityName;

  @override
  Widget build(BuildContext context) {
    final snapshotListAsync = ref.watch(snapshotListProvider);
    final snapshotId = _effectiveSnapshotId(ref);
    final totalsAsync = snapshotId != null
        ? ref.watch(nationalTotalsProvider(snapshotId))
        : const AsyncValue.data(null);
    final topAsync = snapshotId != null
        ? ref.watch(topMunicipalitiesProvider((snapshotId: snapshotId, n: 5)))
        : const AsyncValue.data(<MunicipalityRow>[]);
    final namesAsync = snapshotId != null
        ? ref.watch(municipalityNamesProvider(snapshotId))
        : const AsyncValue.data(<String>[]);

    return Scaffold(
      appBar: AppBar(title: const Text('Pregled')),
      body: snapshotListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
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
                        _TopMunicipalities(topAsync: topAsync),
                        const SizedBox(height: 24),
                        _MunicipalityDropdown(
                          namesAsync: namesAsync,
                          selectedName: _selectedMunicipalityName,
                          onChanged: (name) =>
                              setState(() => _selectedMunicipalityName = name),
                        ),
                        if (_selectedMunicipalityName != null) ...[
                          const SizedBox(height: 16),
                          _QuickView(
                            snapshotId: snapshotId!,
                            municipalityName: _selectedMunicipalityName!,
                            onPogledajSve: () {
                              context.push(
                                '/municipality?name=${Uri.encodeComponent(_selectedMunicipalityName!)}&snapshotId=${Uri.encodeComponent(snapshotId)}',
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
    final theme = Theme.of(context);
    return DataCard(
      key: const Key('hero_national_total'),
      title: 'Nacionalni zbir',
      subtitle: snapshotLabel != null ? 'Od: $snapshotLabel' : null,
      leading: Icon(Icons.agriculture, color: theme.colorScheme.primary, size: 32),
      child: totalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Greška: $e', style: theme.textTheme.bodyMedium),
        data: (totals) {
          if (totals == null) return const SizedBox.shrink();
          final displayStyle = theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('Registrovano ', style: theme.textTheme.bodyLarge),
                  Text('${totals.registered}', style: displayStyle),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('Aktivno ', style: theme.textTheme.bodyLarge),
                  Text('${totals.active}', style: displayStyle),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TopMunicipalities extends StatelessWidget {
  const _TopMunicipalities({required this.topAsync});

  final AsyncValue<List<MunicipalityRow>> topAsync;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return topAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Greška: $e', style: theme.textTheme.bodyMedium),
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();
        final maxActive = list.map((r) => r.totalActive).reduce((a, b) => a > b ? a : b);
        final maxY = (maxActive * 1.15).clamp(1.0, double.infinity);
        final barGroups = list.asMap().entries.map((e) {
          final i = e.key;
          final r = e.value;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: r.totalActive.toDouble(),
                color: theme.colorScheme.primary,
                width: 20,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
            showingTooltipIndicators: [],
          );
        }).toList();
        return DataCard(
          key: const Key('top_five_section'),
          title: 'Top 5 opština po aktivnim',
          leading: Icon(Icons.leaderboard, color: theme.colorScheme.primary, size: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 180,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxY,
                    minY: 0,
                    barGroups: barGroups,
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i >= 0 && i < list.length) {
                              final name = list[i].municipalityName;
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  name.length > 10 ? '${name.substring(0, 8)}.' : name,
                                  style: theme.textTheme.labelSmall,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          reservedSize: 28,
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                  ),
                  duration: const Duration(milliseconds: 150),
                ),
              ),
              const SizedBox(height: 12),
              ...list.map(
                (r) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('${r.municipalityName}: ${r.totalActive} aktivno', style: theme.textTheme.bodyMedium),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MunicipalityDropdown extends StatelessWidget {
  const _MunicipalityDropdown({
    required this.namesAsync,
    required this.selectedName,
    required this.onChanged,
  });

  final AsyncValue<List<String>> namesAsync;
  final String? selectedName;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return namesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
      data: (names) {
        if (names.isEmpty) return const SizedBox.shrink();
        return DataCard(
          key: const Key('municipality_dropdown_section'),
          title: 'Izaberi opštinu',
          leading: Icon(Icons.location_city, color: theme.colorScheme.primary, size: 28),
          child: DropdownButtonFormField<String?>(
            initialValue: selectedName,
            decoration: const InputDecoration(labelText: 'Opština'),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('— Izaberi opštinu —'),
              ),
              ...names.map(
                (n) => DropdownMenuItem<String?>(value: n, child: Text(n)),
              ),
            ],
            onChanged: onChanged,
          ),
        );
      },
    );
  }
}

class _QuickView extends ConsumerWidget {
  const _QuickView({
    required this.snapshotId,
    required this.municipalityName,
    required this.onPogledajSve,
  });

  final String snapshotId;
  final String municipalityName;
  final VoidCallback onPogledajSve;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(
      municipalityDetailProvider((snapshotId: snapshotId, municipalityName: municipalityName)),
    );
    final theme = Theme.of(context).textTheme;
    return detailAsync.when(
      loading: () => DataCard(child: const Center(child: CircularProgressIndicator())),
      error: (e, _) => DataCard(child: Text('Greška: $e', style: theme.bodyMedium)),
      data: (row) {
        if (row == null) return const SizedBox.shrink();
        return DataCard(
          title: municipalityName,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Registrovano: ${row.totalRegistered}', style: theme.bodyLarge),
              Text('Aktivno: ${row.totalActive}', style: theme.bodyLarge),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onPogledajSve,
                child: const Text('Pogledaj sve'),
              ),
            ],
          ),
        );
      },
    );
  }
}
