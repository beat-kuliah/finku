import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography for FinKu.
///
/// Body/label text uses Inter; display + headline use Plus Jakarta Sans
/// (mirrors the web `font-display` / `font-sans` split).
class AppTextTheme {
  const AppTextTheme._();

  static TextTheme build({required Color onSurface, required Color onSurfaceMuted}) {
    final base = GoogleFonts.interTextTheme(
      ThemeData(brightness: _detectBrightness(onSurface)).textTheme,
    ).apply(bodyColor: onSurface, displayColor: onSurface);

    TextStyle display(double size, FontWeight weight, {double? height, double? letter}) {
      return GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        color: onSurface,
        height: height,
        letterSpacing: letter,
      );
    }

    return base.copyWith(
      displayLarge: display(57, FontWeight.w800, height: 1.05, letter: -1.2),
      displayMedium: display(45, FontWeight.w800, height: 1.08, letter: -0.8),
      displaySmall: display(36, FontWeight.w700, height: 1.1, letter: -0.6),
      headlineLarge: display(32, FontWeight.w700, height: 1.15, letter: -0.4),
      headlineMedium: display(28, FontWeight.w700, height: 1.2, letter: -0.3),
      headlineSmall: display(24, FontWeight.w700, height: 1.25, letter: -0.2),
      titleLarge: display(20, FontWeight.w700, height: 1.3),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: onSurface,
        letterSpacing: -0.1,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onSurface,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onSurface,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: onSurfaceMuted,
        height: 1.45,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: onSurface,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: onSurface,
        letterSpacing: 0.1,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: onSurfaceMuted,
        letterSpacing: 0.4,
      ),
    );
  }

  static Brightness _detectBrightness(Color onSurface) {
    final luminance = onSurface.computeLuminance();
    return luminance > 0.5 ? Brightness.dark : Brightness.light;
  }
}
