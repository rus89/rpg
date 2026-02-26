// ABOUTME: App-wide Material 3 theme: light (and dark) ColorScheme, TextTheme, component themes.
// ABOUTME: Professional, readable "data app" look; spacing 8/16/24; no default Flutter look.

import 'package:flutter/material.dart';

/// Vibrant medium green for primary accent (M3 dashboard-style); not dark green.
const Color _primaryGreen = Color(0xFF43A047);

/// Light theme for the RPG app (M3 type scale, custom colors, consistent components).
ThemeData get appTheme {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _primaryGreen,
    brightness: Brightness.light,
    primary: _primaryGreen,
    onPrimary: Colors.white,
    secondary: const Color(0xFF00695C),
    onSecondary: Colors.white,
    surface: const Color(0xFFFAFAFA),
    onSurface: const Color(0xFF1C1B1F),
    surfaceContainerHighest: const Color(0xFFE8E8E8),
    error: const Color(0xFFBA1A1A),
    onError: Colors.white,
  );

  final textTheme = TextTheme(
    displayLarge: _textStyle(57, 0, 0.25, FontWeight.w400),
    displayMedium: _textStyle(45, 0, 0, FontWeight.w400),
    displaySmall: _textStyle(36, 0, 0, FontWeight.w400),
    headlineLarge: _textStyle(32, 0, 0, FontWeight.w400),
    headlineMedium: _textStyle(28, 0, 0, FontWeight.w400),
    headlineSmall: _textStyle(24, 0, 0, FontWeight.w400),
    titleLarge: _textStyle(22, 0, 0, FontWeight.w500),
    titleMedium: _textStyle(16, 0.15, 0, FontWeight.w500),
    titleSmall: _textStyle(14, 0.1, 0, FontWeight.w500),
    bodyLarge: _textStyle(16, 0.5, 0.25, FontWeight.w400),
    bodyMedium: _textStyle(14, 0.25, 0.15, FontWeight.w400),
    bodySmall: _textStyle(12, 0.4, 0.25, FontWeight.w400),
    labelLarge: _textStyle(14, 0.1, 0.5, FontWeight.w500),
    labelMedium: _textStyle(12, 0.5, 0.5, FontWeight.w500),
    labelSmall: _textStyle(11, 0.5, 0.5, FontWeight.w500),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

TextStyle _textStyle(double size, double letterSpacing, double height, FontWeight weight) {
  return TextStyle(
    fontSize: size,
    letterSpacing: letterSpacing,
    height: height == 0 ? null : (1 + height),
    fontWeight: weight,
  );
}

/// Dark theme (optional); same structure, dark ColorScheme.
ThemeData get appDarkTheme {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF4CAF50),
    brightness: Brightness.dark,
    primary: const Color(0xFF81C784),
    onPrimary: const Color(0xFF003910),
    secondary: const Color(0xFF4DB6AC),
    onSecondary: const Color(0xFF00382E),
    surface: const Color(0xFF1C1B1F),
    onSurface: const Color(0xFFE6E1E5),
    surfaceContainerHighest: const Color(0xFF2D2D2D),
    error: const Color(0xFFFFB4AB),
    onError: const Color(0xFF690005),
  );

  final textTheme = TextTheme(
    displayLarge: _textStyle(57, 0, 0.25, FontWeight.w400),
    displayMedium: _textStyle(45, 0, 0, FontWeight.w400),
    displaySmall: _textStyle(36, 0, 0, FontWeight.w400),
    headlineLarge: _textStyle(32, 0, 0, FontWeight.w400),
    headlineMedium: _textStyle(28, 0, 0, FontWeight.w400),
    headlineSmall: _textStyle(24, 0, 0, FontWeight.w400),
    titleLarge: _textStyle(22, 0, 0, FontWeight.w500),
    titleMedium: _textStyle(16, 0.15, 0, FontWeight.w500),
    titleSmall: _textStyle(14, 0.1, 0, FontWeight.w500),
    bodyLarge: _textStyle(16, 0.5, 0.25, FontWeight.w400),
    bodyMedium: _textStyle(14, 0.25, 0.15, FontWeight.w400),
    bodySmall: _textStyle(12, 0.4, 0.25, FontWeight.w400),
    labelLarge: _textStyle(14, 0.1, 0.5, FontWeight.w500),
    labelMedium: _textStyle(12, 0.5, 0.5, FontWeight.w500),
    labelSmall: _textStyle(11, 0.5, 0.5, FontWeight.w500),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
