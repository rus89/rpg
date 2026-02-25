// ABOUTME: Entry point for the RPG Flutter app (mobile and web).
// ABOUTME: Runs a MaterialApp placeholder until routing and screens are added.

import 'package:flutter/material.dart';

import 'package:rpg/app/storage_bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initRpgStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RPG',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Scaffold(
        body: Center(child: Text('RPG')),
      ),
    );
  }
}
