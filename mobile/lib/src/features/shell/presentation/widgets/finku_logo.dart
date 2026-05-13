import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';

enum FinkuLogoSize { sm, md, lg, xl }

/// FinKu wordmark: gradient "F" badge + "Fin" wordmark + gradient "Ku".
class FinkuLogo extends StatelessWidget {
  const FinkuLogo({
    super.key,
    this.size = FinkuLogoSize.md,
    this.showWordmark = true,
  });

  final FinkuLogoSize size;
  final bool showWordmark;

  ({double box, double badgeFont, double wordFont, double radius, double gap}) get _metrics {
    return switch (size) {
      FinkuLogoSize.sm => (box: 32, badgeFont: 16, wordFont: 18, radius: 12, gap: 8),
      FinkuLogoSize.md => (box: 40, badgeFont: 20, wordFont: 22, radius: 14, gap: 10),
      FinkuLogoSize.lg => (box: 56, badgeFont: 26, wordFont: 30, radius: 18, gap: 12),
      FinkuLogoSize.xl => (box: 88, badgeFont: 44, wordFont: 44, radius: 26, gap: 16),
    };
  }

  @override
  Widget build(BuildContext context) {
    final m = _metrics;
    final color = Theme.of(context).colorScheme.onSurface;

    final badge = Container(
      width: m.box,
      height: m.box,
      decoration: BoxDecoration(
        gradient: FinkuColors.gradientNeon,
        borderRadius: BorderRadius.circular(m.radius),
        boxShadow: FinkuColors.neonGlow(opacity: 0.4, blur: 22),
      ),
      alignment: Alignment.center,
      child: Text(
        'F',
        style: GoogleFonts.plusJakartaSans(
          fontSize: m.badgeFont,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1.0,
        ),
      ),
    );

    if (!showWordmark) return badge;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        badge,
        SizedBox(width: m.gap),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Fin',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: m.wordFont,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: -0.4,
                  height: 1.0,
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: ShaderMask(
                  shaderCallback: (rect) => FinkuColors.gradientNeon.createShader(rect),
                  child: Text(
                    'Ku',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: m.wordFont,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.4,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
