// ABOUTME: Tests that app theme uses vibrant medium green primary and light default.
// ABOUTME: Ensures DESIGN.md §6 theme requirements are met.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rpg/app/theme.dart';

void main() {
  test('appTheme uses vibrant medium green as primary', () {
    final theme = appTheme;
    expect(theme.colorScheme.brightness, Brightness.light);
    expect(theme.colorScheme.primary, const Color(0xFF43A047));
  });

  test('appTheme cards are white with rounded corners', () {
    final theme = appTheme;
    expect(theme.cardTheme.color, Colors.white);
    expect(theme.cardTheme.shape, isA<RoundedRectangleBorder>());
    final shape = theme.cardTheme.shape as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(12));
  });
}
