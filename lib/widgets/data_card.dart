// ABOUTME: Reusable card for data blocks (summary, totals, quick view).
// ABOUTME: Consistent padding and optional title/subtitle per DESIGN.md §6.

import 'package:flutter/material.dart';

/// Card with 16px padding and optional title/subtitle for consistent data blocks.
class DataCard extends StatelessWidget {
  const DataCard({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
  });

  final String? title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) Text(title!, style: theme.textTheme.titleMedium),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle!, style: theme.textTheme.bodySmall),
            ],
            if (title != null || subtitle != null) const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
