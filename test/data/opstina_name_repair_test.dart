// ABOUTME: Tests for opština name repair (corrupted ? → č, ć, đ).
// ABOUTME: Ensures known corrupted forms map to correct canonical names.

import 'package:flutter_test/flutter_test.dart';
import 'package:rpg/data/opstina_name_repair.dart';

void main() {
  test('repairOpstinaName repairs ?a?ak to Čačak', () {
    expect(repairOpstinaName('?a?ak'), 'Čačak');
  });

  test('repairOpstinaName repairs ?i?evac to Ćićevac', () {
    expect(repairOpstinaName('?i?evac'), 'Ćićevac');
  });

  test('repairOpstinaName repairs ?uprija to Ćuprija', () {
    expect(repairOpstinaName('?uprija'), 'Ćuprija');
  });

  test('repairOpstinaName repairs In?ija to Inđija', () {
    expect(repairOpstinaName('In?ija'), 'Inđija');
  });

  test('repairOpstinaName leaves unknown names unchanged', () {
    expect(repairOpstinaName('Barajevo'), 'Barajevo');
    expect(repairOpstinaName('Belgrade'), 'Belgrade');
  });
}
