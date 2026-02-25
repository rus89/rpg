// ABOUTME: Entry point for the RPG Flutter app (mobile and web).
// ABOUTME: ProviderScope + MaterialApp.router with GoRouter (Home, Map, Detail, About).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rpg/app/router.dart';
import 'package:rpg/app/storage_bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initRpgStorage();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RPG',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: goRouter,
    );
  }
}
