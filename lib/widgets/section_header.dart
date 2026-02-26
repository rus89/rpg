// ABOUTME: Section title with consistent spacing below (8px) for screen sections.
// ABOUTME: Used on Home, About, and other screens per DESIGN.md §6.

import 'package:flutter/material.dart';

/// Section heading with 8px space below for layout consistency.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
