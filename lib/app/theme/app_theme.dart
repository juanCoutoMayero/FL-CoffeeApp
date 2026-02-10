import 'package:flutter/material.dart';

/// Provides centralized theme configuration for the Coffee App.
///
/// This class contains static methods to generate light and dark theme data,
/// ensuring consistent theming across the application.
class AppTheme {
  /// Returns the light theme configuration.
  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.brown,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
    );
  }

  /// Returns the dark theme configuration.
  static ThemeData dark() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.brown,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
    );
  }
}
