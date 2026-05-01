import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppThemeMode {
  autumnWarmth,
  rainyReflection,
  winterCalm,
  summerVitality,
}

class ThemeFlavor {
  final String label;
  final String subtitle;
  final Color backgroundTop;
  final Color backgroundBottom;
  final Color orbA;
  final Color orbB;
  final bool frosted;

  const ThemeFlavor({
    required this.label,
    required this.subtitle,
    required this.backgroundTop,
    required this.backgroundBottom,
    required this.orbA,
    required this.orbB,
    required this.frosted,
  });
}

class ThemeService extends ChangeNotifier {
  AppThemeMode _currentTheme = AppThemeMode.autumnWarmth;

  AppThemeMode get currentTheme => _currentTheme;

  ThemeFlavor get flavor {
    switch (_currentTheme) {
      case AppThemeMode.autumnWarmth:
        return const ThemeFlavor(
          label: 'Autumn Warmth',
          subtitle: 'Layered light and earthy reflections',
          backgroundTop: Color(0xFFFCE9D2),
          backgroundBottom: Color(0xFFE8F3F1),
          orbA: Color(0x26FFA500),
          orbB: Color(0x1A14B8A6),
          frosted: true,
        );
      case AppThemeMode.rainyReflection:
        return const ThemeFlavor(
          label: 'Rainy Reflection',
          subtitle: 'Quiet contrast and misty atmosphere',
          backgroundTop: Color(0xFF163428),
          backgroundBottom: Color(0xFF121417),
          orbA: Color(0x3360A5FA),
          orbB: Color(0x2280CBC4),
          frosted: true,
        );
      case AppThemeMode.winterCalm:
        return const ThemeFlavor(
          label: 'Winter Calm',
          subtitle: 'Cool gradients and clean stillness',
          backgroundTop: Color(0xFFEEF2FF),
          backgroundBottom: Color(0xFFC7D2FE),
          orbA: Color(0x339FA8DA),
          orbB: Color(0x33FFFFFF),
          frosted: true,
        );
      case AppThemeMode.summerVitality:
        return const ThemeFlavor(
          label: 'Summer Vitality',
          subtitle: 'Bright hills and playful energy',
          backgroundTop: Color(0xFFE0F2F1),
          backgroundBottom: Color(0xFFB2EBF2),
          orbA: Color(0x33ADCEBD),
          orbB: Color(0x334A6550),
          frosted: true,
        );
    }
  }

  void switchTheme(AppThemeMode theme) {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      switch (_currentTheme) {
        case AppThemeMode.autumnWarmth:
          HapticFeedback.lightImpact();
          break;
        case AppThemeMode.rainyReflection:
          HapticFeedback.mediumImpact();
          break;
        case AppThemeMode.winterCalm:
          HapticFeedback.selectionClick();
          break;
        case AppThemeMode.summerVitality:
          HapticFeedback.heavyImpact();
          break;
      }
      notifyListeners();
    }
  }

  ThemeData getThemeData() {
    switch (_currentTheme) {
      case AppThemeMode.autumnWarmth:
        return _autumnWarmth();
      case AppThemeMode.rainyReflection:
        return _rainyReflection();
      case AppThemeMode.winterCalm:
        return _winterCalm();
      case AppThemeMode.summerVitality:
        return _summerVitality();
    }
  }

  ThemeData _autumnWarmth() {
    const seedColor = Color(0xFF2D4B3E);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme.copyWith(
        primary: const Color(0xFF2D4B3E),
        secondary: const Color(0xFF4A6550),
        surface: const Color(0xFFFFFBF5),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFFBF5),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.8,
          height: 1.05,
          color: Color(0xFF2D2D2D),
          fontFamily: 'serif',
        ),
        headlineSmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          height: 1.35,
          color: Color(0xFF2D2D2D),
          fontFamily: 'serif',
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          height: 1.45,
          color: Color(0xFF3D3D3D),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          letterSpacing: 0.2,
          height: 1.35,
          color: Color(0xFF6B6B6B),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D4B3E),
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF2D4B3E),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFFE8DCC8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFFE8DCC8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFF2D4B3E), width: 2),
        ),
        hintStyle: const TextStyle(color: Color(0xFFC0C0C0)),
      ),
    );
  }

  ThemeData _rainyReflection() {
    const seedColor = Color(0xFF60A5FA);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme.copyWith(
        primary: const Color(0xFF60A5FA),
        secondary: const Color(0xFF99BAA9),
        surface: const Color(0xFF1E2126),
      ),
      scaffoldBackgroundColor: const Color(0xFF0E141B),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          height: 1.05,
          color: Color(0xFFFFFFFF),
        ),
        headlineSmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          height: 1.35,
          color: Color(0xFFFFFFFF),
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          height: 1.45,
          color: Color(0xFFE0E0E0),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          letterSpacing: 0.2,
          height: 1.35,
          color: Color(0xFF9E9E9E),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF60A5FA),
          foregroundColor: const Color(0xFF0E141B),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF60A5FA),
        foregroundColor: const Color(0xFF0E141B),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0x1AFFFFFF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 2),
        ),
        hintStyle: const TextStyle(color: Color(0xFF616161)),
      ),
    );
  }

  ThemeData _winterCalm() {
    const seedColor = Color(0xFF1E293B);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme.copyWith(
        primary: const Color(0xFF1E293B),
        secondary: const Color(0xFF5C6BC0),
        surface: const Color(0xFFEFF3FF),
      ),
      scaffoldBackgroundColor: const Color(0xFFEFF3FF),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          height: 1.05,
          color: Color(0xFF1E293B),
          fontFamily: 'serif',
        ),
        headlineSmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          height: 1.35,
          color: Color(0xFF1E293B),
          fontFamily: 'serif',
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          height: 1.45,
          color: Color(0xFF1E293B),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          letterSpacing: 0.2,
          height: 1.35,
          fontWeight: FontWeight.w500,
          color: Color(0xFF5C6BC0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E293B),
          foregroundColor: Colors.white,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
            side: const BorderSide(color: Color(0xFF1E293B), width: 1.5),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFF5C6BC0), width: 2),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xCCFFFFFF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF1E293B), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF1E293B), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF5C6BC0), width: 2),
        ),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      ),
    );
  }

  ThemeData _summerVitality() {
    const seedColor = Color(0xFF2D4B3E);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme.copyWith(
        primary: const Color(0xFF2D4B3E),
        secondary: const Color(0xFF4A6550),
        surface: const Color(0xFFF4FFFB),
      ),
      scaffoldBackgroundColor: const Color(0xFFF4FFFB),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          height: 1.05,
          color: Color(0xFF2D4B3E),
          fontFamily: 'serif',
        ),
        headlineSmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          height: 1.35,
          color: Color(0xFF2D4B3E),
          fontFamily: 'serif',
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          height: 1.45,
          color: Color(0xFF334155),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          letterSpacing: 0.2,
          height: 1.35,
          color: Color(0xFF64748B),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D4B3E),
          foregroundColor: Colors.white,
          elevation: 6,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF2D4B3E),
        foregroundColor: Colors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xE6FFFFFF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF2D4B3E), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF2D4B3E), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF4A6550), width: 2),
        ),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      ),
    );
  }
}
