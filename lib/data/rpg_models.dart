// ABOUTME: Domain models for RPG data: snapshot metadata and per-municipality totals.
// ABOUTME: Used by parser, storage, and UI; no platform types.

/// One snapshot (e.g. 31.12.2025): identifier and display label.
class RpgSnapshot {
  const RpgSnapshot({required this.id, required this.label});
  final String id;
  final String label;
}

/// Aggregated totals for one municipality in a snapshot (registered and active holdings).
class MunicipalityRow {
  const MunicipalityRow({
    required this.municipalityName,
    required this.totalRegistered,
    required this.totalActive,
  });
  final String municipalityName;
  final int totalRegistered;
  final int totalActive;
}

/// National totals for one snapshot (sum of all municipalities).
class NationalTotals {
  const NationalTotals({required this.registered, required this.active});
  final int registered;
  final int active;
}
