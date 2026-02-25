// ABOUTME: GoRouter config: Home, Map, Detail (/opstina?name=&snapshotId=), About; shell with bottom nav.
// ABOUTME: Placeholder screens until Task 8+; same Detail screen from Home and Map.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rpg/screens/home_screen.dart';
import 'package:rpg/screens/map_screen.dart';
import 'package:rpg/screens/opstina_detail_screen.dart';
import 'package:rpg/screens/placeholder_screens.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => Scaffold(
        body: navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
          ],
        ),
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/map',
              builder: (context, state) => const MapScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/about',
              builder: (context, state) => const PlaceholderAboutScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/opstina',
      builder: (context, state) => OpstinaDetailScreen(
        name: state.uri.queryParameters['name'],
        snapshotId: state.uri.queryParameters['snapshotId'],
      ),
    ),
  ],
);
