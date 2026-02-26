// ABOUTME: Tests for municipality name repair (corrupted ? → č, ć, đ).
// ABOUTME: Ensures known corrupted forms map to correct canonical names.

import 'package:flutter_test/flutter_test.dart';
import 'package:rpg/data/municipality_name_repair.dart';

void main() {
  test('repairMunicipalityName repairs ?a?ak to Čačak', () {
    expect(repairMunicipalityName('?a?ak'), 'Čačak');
  });

  test('repairMunicipalityName repairs ?i?evac to Ćićevac', () {
    expect(repairMunicipalityName('?i?evac'), 'Ćićevac');
  });

  test('repairMunicipalityName repairs ?uprija to Ćuprija', () {
    expect(repairMunicipalityName('?uprija'), 'Ćuprija');
  });

  test('repairMunicipalityName repairs In?ija to Inđija', () {
    expect(repairMunicipalityName('In?ija'), 'Inđija');
  });

  test('repairMunicipalityName leaves unknown names unchanged', () {
    expect(repairMunicipalityName('Barajevo'), 'Barajevo');
    expect(repairMunicipalityName('Belgrade'), 'Belgrade');
  });
}
