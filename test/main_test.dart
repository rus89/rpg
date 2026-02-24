// ABOUTME: Smoke test that the app runs and shows a MaterialApp.
// ABOUTME: Used to verify bootstrap and that the app widget tree is built.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rpg/main.dart';

void main() {
  testWidgets('app runs and shows MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
