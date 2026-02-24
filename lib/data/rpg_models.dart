// ABOUTME: Domain models for RPG data: snapshot metadata and per-opština totals.
// ABOUTME: Used by parser, storage, and UI; no platform types.

/// One snapshot (e.g. 31.12.2025): identifier and display label.
class RpgSnapshot {
  const RpgSnapshot({required this.id, required this.label});
  final String id;
  final String label;
}

/// Aggregated totals for one opština in a snapshot (registered and active holdings).
class OpstinaRow {
  const OpstinaRow({
    required this.opstinaName,
    required this.totalRegistered,
    required this.totalActive,
  });
  final String opstinaName;
  final int totalRegistered;
  final int totalActive;
}
