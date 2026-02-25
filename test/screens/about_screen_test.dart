// ABOUTME: Widget tests for About screen: attribution, disclaimer text, dataset link.
// ABOUTME: Expects disclaimer substring and Link widget (or tap and verify URL).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/link.dart';

import 'package:rpg/screens/about_screen.dart';

void main() {
  testWidgets('shows disclaimer text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AboutScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('nije povezan'), findsAtLeast(1));
  });

  testWidgets('shows dataset link', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AboutScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Link), findsAtLeast(1));
  });
}
