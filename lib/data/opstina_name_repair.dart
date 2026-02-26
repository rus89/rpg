// ABOUTME: Repairs opština names where data.gov.rs CSV has ? instead of č, ć, đ.
// ABOUTME: Map from corrupted form (e.g. ?a?ak) to correct name (e.g. Čačak).

/// Canonical opština names that contain č, ć, or đ (dataset often has ? in their place).
const List<String> _opstineWithCedilla = [
  'Čačak',
  'Ćićevac',
  'Ćuprija',
  'Inđija',
  'Lučani',
  'Pčinja',
];

/// Builds map: corrupted name (č,ć,đ → ?) → correct name.
Map<String, String> _buildRepairMap() {
  final map = <String, String>{};
  for (final correct in _opstineWithCedilla) {
    final key = _toCorruptedForm(correct);
    if (key != correct) map[key] = correct;
  }
  return map;
}

String _toCorruptedForm(String s) {
  return s
      .replaceAll('č', '?')
      .replaceAll('ć', '?')
      .replaceAll('đ', '?')
      .replaceAll('Č', '?')
      .replaceAll('Ć', '?')
      .replaceAll('Đ', '?');
}

final _repairMap = _buildRepairMap();

/// Returns the correct opština name if the raw name is a known corrupted form; otherwise returns [raw] unchanged.
String repairOpstinaName(String raw) {
  final trimmed = raw.trim();
  return _repairMap[trimmed] ?? trimmed;
}
