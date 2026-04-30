import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fosha_colors.dart';

abstract final class FoshaTheme {
  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: FoshaColors.primaryPink,
      brightness: Brightness.dark,
      surface: FoshaColors.surface,
      error: FoshaColors.error,
    ).copyWith(
      primary: FoshaColors.primaryPink,
      secondary: FoshaColors.highlightOrange,
      surface: FoshaColors.surface,
      onSurface: FoshaColors.onDark,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: FoshaColors.backgroundPurple,
      appBarTheme: const AppBarTheme(
        backgroundColor: FoshaColors.backgroundPurple,
        foregroundColor: FoshaColors.onDark,
        centerTitle: true,
      ),
    );

    // Arabic-first typography. Keep Poppins as fallback for latin/numbers.
    final textTheme = GoogleFonts.cairoTextTheme(base.textTheme).apply(
      bodyColor: FoshaColors.onDark,
      displayColor: FoshaColors.onDark,
    );

    return base.copyWith(
      textTheme: textTheme.copyWith(
        bodyLarge: textTheme.bodyLarge?.copyWith(
          fontFamilyFallback: const ['Cairo', 'Poppins'],
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          fontFamilyFallback: const ['Cairo', 'Poppins'],
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          fontFamilyFallback: const ['Cairo', 'Poppins'],
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: FoshaColors.primaryPink,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.cairo(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FoshaColors.primaryPink,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.cairo(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FoshaColors.surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: FoshaColors.onDarkMuted),
      ),
    );
  }
}

