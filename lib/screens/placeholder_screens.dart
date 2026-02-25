// ABOUTME: Placeholder screens for router (Scaffold + AppBar + text) until real screens.
// ABOUTME: Replaced by Home, Map, Detail, About in later tasks.

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
