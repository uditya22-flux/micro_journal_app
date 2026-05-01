import 'package:flutter/material.dart';

class AppTheme {
	static ThemeData light() {
		const seedColor = Color(0xFF243B53);

		final colorScheme = ColorScheme.fromSeed(
			seedColor: seedColor,
			brightness: Brightness.light,
		);

		return ThemeData(
			useMaterial3: true,
			colorScheme: colorScheme,
			scaffoldBackgroundColor: const Color(0xFFF7F5F0),
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
				),
				headlineSmall: TextStyle(
					fontSize: 22,
					fontWeight: FontWeight.w500,
					height: 1.35,
				),
				bodyLarge: TextStyle(
					fontSize: 17,
					height: 1.45,
				),
				bodyMedium: TextStyle(
					fontSize: 15,
					height: 1.45,
				),
				bodySmall: TextStyle(
					fontSize: 12,
					letterSpacing: 0.2,
					height: 1.35,
				),
			).apply(
				bodyColor: colorScheme.onSurface,
				displayColor: colorScheme.onSurface,
			),
			dividerTheme: DividerThemeData(
				color: colorScheme.outlineVariant.withOpacity(0.7),
				space: 1,
				thickness: 1,
			),
			cardTheme: CardThemeData(
				color: Colors.white.withOpacity(0.7),
				elevation: 0,
				shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(16),
					side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.6)),
				),
			),
			elevatedButtonTheme: ElevatedButtonThemeData(
				style: ElevatedButton.styleFrom(
					backgroundColor: colorScheme.primary,
					foregroundColor: colorScheme.onPrimary,
					elevation: 0,
					padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(14),
					),
					textStyle: const TextStyle(
						fontSize: 15,
						fontWeight: FontWeight.w600,
					),
				),
			),
			textButtonTheme: TextButtonThemeData(
				style: TextButton.styleFrom(
					foregroundColor: colorScheme.primary,
					textStyle: const TextStyle(
						fontSize: 15,
						fontWeight: FontWeight.w600,
					),
				),
			),
			inputDecorationTheme: InputDecorationTheme(
				filled: true,
				fillColor: Colors.white.withOpacity(0.55),
				contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
				border: OutlineInputBorder(
					borderRadius: BorderRadius.circular(16),
					borderSide: BorderSide(color: colorScheme.outlineVariant),
				),
				enabledBorder: OutlineInputBorder(
					borderRadius: BorderRadius.circular(16),
					borderSide: BorderSide(color: colorScheme.outlineVariant),
				),
				focusedBorder: OutlineInputBorder(
					borderRadius: BorderRadius.circular(16),
					borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
				),
			),
		);
	}

	static ThemeData dark() {
		const seedColor = Color(0xFF8FB3D9);

		final colorScheme = ColorScheme.fromSeed(
			seedColor: seedColor,
			brightness: Brightness.dark,
		);

		return ThemeData(
			useMaterial3: true,
			colorScheme: colorScheme,
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
				),
				headlineSmall: TextStyle(
					fontSize: 22,
					fontWeight: FontWeight.w500,
					height: 1.35,
				),
				bodyLarge: TextStyle(
					fontSize: 17,
					height: 1.45,
				),
				bodyMedium: TextStyle(
					fontSize: 15,
					height: 1.45,
				),
				bodySmall: TextStyle(
					fontSize: 12,
					letterSpacing: 0.2,
					height: 1.35,
				),
			).apply(
				bodyColor: colorScheme.onSurface,
				displayColor: colorScheme.onSurface,
			),
			dividerTheme: DividerThemeData(
				color: colorScheme.outlineVariant.withOpacity(0.7),
				space: 1,
				thickness: 1,
			),
			elevatedButtonTheme: ElevatedButtonThemeData(
				style: ElevatedButton.styleFrom(
					backgroundColor: colorScheme.primary,
					foregroundColor: colorScheme.onPrimary,
					elevation: 0,
					padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(14),
					),
					textStyle: const TextStyle(
						fontSize: 15,
						fontWeight: FontWeight.w600,
					),
				),
			),
			textButtonTheme: TextButtonThemeData(
				style: TextButton.styleFrom(
					foregroundColor: colorScheme.primary,
					textStyle: const TextStyle(
						fontSize: 15,
						fontWeight: FontWeight.w600,
					),
				),
			),
			inputDecorationTheme: InputDecorationTheme(
				filled: true,
				fillColor: const Color(0xFF17212B),
				contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
				border: OutlineInputBorder(
					borderRadius: BorderRadius.circular(16),
					borderSide: BorderSide(color: colorScheme.outlineVariant),
				),
				enabledBorder: OutlineInputBorder(
					borderRadius: BorderRadius.circular(16),
					borderSide: BorderSide(color: colorScheme.outlineVariant),
				),
				focusedBorder: OutlineInputBorder(
					borderRadius: BorderRadius.circular(16),
					borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
				),
			),
		);
	}
}
