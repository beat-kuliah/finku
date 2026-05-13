import 'package:flutter/material.dart';

/// Brand palette + raw color tokens used by FinKu, mirroring the web design system.
///
/// Use these for non-semantic accents (gradients, glows, brand surfaces).
/// For ordinary text/surfaces prefer `Theme.of(context).colorScheme.*`.
class FinkuColors {
  const FinkuColors._();

  static const cyan500 = Color(0xFF00F0FF);
  static const blue600 = Color(0xFF2563EB);
  static const blue800 = Color(0xFF1D4ED8);

  static const ink900 = Color(0xFF0B1220);
  static const ink800 = Color(0xFF111C33);
  static const ink700 = Color(0xFF273C5F);
  static const ink600 = Color(0xFF334B73);

  static const lightBg = Color(0xFFF8FBFF);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightText = Color(0xFF0F172A);
  static const lightMuted = Color(0xFF475569);

  static const danger = Color(0xFFEF4444);
  static const success = Color(0xFF10B981);

  /// Primary brand gradient (cyan -> blue -> deep blue) used on FAB, CTA, logo.
  static const gradientNeon = LinearGradient(
    colors: [cyan500, blue600, blue800],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Soft glow shadows used behind gradient surfaces (FAB, CTA).
  static List<BoxShadow> neonGlow({double opacity = 0.45, double blur = 28}) {
    return [
      BoxShadow(
        color: cyan500.withValues(alpha: opacity * 0.55),
        blurRadius: blur,
        spreadRadius: -4,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: blue600.withValues(alpha: opacity),
        blurRadius: blur * 1.4,
        spreadRadius: -8,
        offset: const Offset(0, 14),
      ),
    ];
  }

  /// Glass surface tokens: returns (fill, border) for the given brightness.
  static ({Color fill, Color border}) glassTokens(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return (
        fill: Colors.white.withValues(alpha: 0.05),
        border: Colors.white.withValues(alpha: 0.10),
      );
    }
    return (
      fill: Colors.black.withValues(alpha: 0.04),
      border: Colors.black.withValues(alpha: 0.08),
    );
  }
}
