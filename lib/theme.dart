import 'package:flutter/material.dart';

class AppColors {
  static const Color ink = Color(0xFF0F0E0C);
  static const Color surface = Color(0xFF171511);
  static const Color accent = Color(0xFFC8A35A);
  static const Color accentMuted = Color(0xFF9B8353);
  static const Color sand = Color(0xFFF6F1E8);
  static const Color sandMuted = Color(0xFFD7D0C4);
  static const Color success = Color(0xFF5BAA8C);
}

class AppTheme {
  static ThemeData dark() {
    final base = ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Sora',
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accentMuted,
        surface: AppColors.surface,
        background: AppColors.ink,
        onPrimary: AppColors.ink,
        onSurface: AppColors.sand,
        onBackground: AppColors.sand,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.ink,
      cardColor: const Color(0xFF1C1A16),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.accent.withOpacity(0.15),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: base.textTheme.displayLarge?.copyWith(
          fontFamily: 'PlayfairDisplay',
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontFamily: 'PlayfairDisplay',
          fontWeight: FontWeight.w600,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontFamily: 'PlayfairDisplay',
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1F1C17),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
