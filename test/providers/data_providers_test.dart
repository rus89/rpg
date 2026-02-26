// ABOUTME: Tests for Riverpod data providers using overridden repository.
// ABOUTME: Fake repository with data; expect snapshotListProvider yields list.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rpg/data/repository.dart';
import 'package:rpg/data/rpg_models.dart';
import 'package:rpg/providers/data_providers.dart';

import '../fake_storage.dart';

void main() {
  test('snapshotListProvider returns list after fake repo has data', () async {
    final fakeStorage = FakeRpgStorage();
    final repo = RpgRepository(fakeStorage);
    await repo.saveSnapshot(
      const RpgSnapshot(id: '31.12.2025', label: '31.12.2025'),
      [
        const MunicipalityRow(municipalityName: 'Barajevo', totalRegistered: 100, totalActive: 98),
      ],
    );

    final container = ProviderContainer(
      overrides: [
        repositoryProvider.overrideWithValue(repo),
        syncProvider.overrideWith((ref) => Future.value()),
      ],
    );
    addTearDown(container.dispose);

    final list = await container.read(snapshotListProvider.future);
    expect(list.length, 1);
    expect(list.first.id, '31.12.2025');
    expect(list.first.label, '31.12.2025');
  });

  test('nationalTotalsProvider returns totals for snapshot', () async {
    final fakeStorage = FakeRpgStorage();
    final repo = RpgRepository(fakeStorage);
    await repo.saveSnapshot(
      const RpgSnapshot(id: '31.12.2025', label: '31.12.2025'),
      [
        const MunicipalityRow(municipalityName: 'Barajevo', totalRegistered: 100, totalActive: 98),
        const MunicipalityRow(municipalityName: 'Cukarica', totalRegistered: 200, totalActive: 195),
      ],
    );

    final container = ProviderContainer(
      overrides: [
        repositoryProvider.overrideWithValue(repo),
        syncProvider.overrideWith((ref) => Future.value()),
      ],
    );
    addTearDown(container.dispose);

    final totals = await container.read(nationalTotalsProvider('31.12.2025').future);
    expect(totals, isNotNull);
    expect(totals!.registered, 300);
    expect(totals.active, 293);
  });
}
