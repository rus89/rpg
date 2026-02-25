// ABOUTME: Placeholder screens for router (Scaffold + AppBar + text) when route does not map to a main screen.
// ABOUTME: Shell uses these for fallback; main routes use Home, Map, Detail, About.

import 'package:flutter/material.dart';

class PlaceholderHomeScreen extends StatelessWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home')),
    );
  }
}

class PlaceholderMapScreen extends StatelessWidget {
  const PlaceholderMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: const Center(child: Text('Map')),
    );
  }
}

class PlaceholderAboutScreen extends StatelessWidget {
  const PlaceholderAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('About')),
    );
  }
}

class PlaceholderDetailScreen extends StatelessWidget {
  const PlaceholderDetailScreen({super.key, this.name, this.snapshotId});

  final String? name;
  final String? snapshotId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opština')),
      body: Center(
        child: Text('Opština detail${name != null ? ': $name' : ''}${snapshotId != null ? ' ($snapshotId)' : ''}'),
      ),
    );
  }
}
