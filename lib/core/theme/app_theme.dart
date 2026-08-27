import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color _ivory = Color(0xFFF8F5EE);
  static const Color _surface = Color(0xFFFFFDF8);
  static const Color _forest = Color(0xFF183D32);
  static const Color _sage = Color(0xFF708A78);
  static const Color _sand = Color(0xFFD8C8A8);
  static const Color _ink = Color(0xFF20231F);
  static const Color _muted = Color(0xFF666A63);

  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: _forest,
      onPrimary: Colors.white,
      secondary: _sage,
      onSecondary: Colors.white,
      error: Color(0xFFB3261E),
      onError: Colors.white,
      surface: _surface,
      onSurface: _ink,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: _ivory,
      dividerColor: _sand.withValues(alpha: 0.55),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 36,
          height: 1.1,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.7,
          color: _ink,
        ),
        headlineMedium: TextStyle(
          fontSize: 27,
          height: 1.15,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.35,
          color: _ink,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          height: 1.25,
          fontWeight: FontWeight.w600,
          color: _ink,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          height: 1.55,
          fontWeight: FontWeight.w400,
          color: _ink,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          height: 1.5,
          fontWeight: FontWeight.w400,
          color: _muted,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          height: 1.2,
          fontWeight: FontWeight.w600,
          color: _ink,
        ),
      ),
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _sand.withValues(alpha: 0.42)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: _surface,
        indicatorColor: _sage.withValues(alpha: 0.16),
        elevation: 0,
        labelTextStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: _surface,
        indicatorColor: _sage.withValues(alpha: 0.16),
        selectedIconTheme: const IconThemeData(color: _forest),
        selectedLabelTextStyle: const TextStyle(
          color: _forest,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _sand.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _sand.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _forest, width: 1.4),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final base = light();
    const darkSurface = Color(0xFF151B18);
    const darkBackground = Color(0xFF101411);
    const darkText = Color(0xFFF2EFE7);

    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.dark,
        primary: const Color(0xFFAFC9B8),
        onPrimary: const Color(0xFF102119),
        secondary: const Color(0xFF9FB09F),
        onSecondary: const Color(0xFF152018),
        surface: darkSurface,
        onSurface: darkText,
      ),
      cardTheme: base.cardTheme.copyWith(
        color: darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF2D3731)),
        ),
      ),
    );
  }
}
