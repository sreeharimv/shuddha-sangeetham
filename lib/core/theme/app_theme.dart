import 'package:flutter/material.dart';

/// Shuddha Sangeetham design tokens.
///
/// Primary: Deep Teal — classical, grounded, Carnatic music feel.
/// Accent:  Warm Gold — concert-hall warmth.
abstract final class AppColors {
  // Brand
  static const teal900 = Color(0xFF00463D);
  static const teal700 = Color(0xFF00695C);
  static const teal500 = Color(0xFF00897B);
  static const teal100 = Color(0xFFB2DFDB);

  static const gold = Color(0xFFF9A825);
  static const goldDark = Color(0xFFF57F17);

  // Neutral — light
  static const surface = Color(0xFFFAFAFA);
  static const surfaceVariant = Color(0xFFF0F4F3);
  static const onSurface = Color(0xFF1A1A1A);

  // Neutral — dark
  static const darkSurface = Color(0xFF121212);
  static const darkSurfaceVariant = Color(0xFF1E2A29);
  static const darkOnSurface = Color(0xFFE8F5E9);
}

abstract final class AppTextStyles {
  /// Lyrics body — generous size and line height for concert-hall readability.
  static const lyricsStyle = TextStyle(
    fontSize: 17,
    height: 1.7,
    letterSpacing: 0.2,
  );

  /// Section label within a krithi detail page (e.g. "Pallavi").
  static const sectionLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
  );
}

abstract final class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.teal700,
      brightness: Brightness.light,
      surface: AppColors.surface,
    ).copyWith(
      secondary: AppColors.gold,
      onSecondary: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.teal900,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.teal900,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.teal700,
        unselectedItemColor: Colors.grey,
        backgroundColor: AppColors.surface,
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.teal100,
        labelStyle: TextStyle(color: AppColors.teal900, fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFDDE8E7)),
        ),
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.teal500,
      brightness: Brightness.dark,
      surface: AppColors.darkSurface,
    ).copyWith(
      secondary: AppColors.gold,
      onSecondary: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkSurface,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkOnSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.darkOnSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.teal500,
        unselectedItemColor: Colors.grey,
        backgroundColor: Color(0xFF1A1A1A),
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        labelStyle: TextStyle(color: AppColors.teal100, fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF2C3E3D)),
        ),
        color: AppColors.darkSurfaceVariant,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
