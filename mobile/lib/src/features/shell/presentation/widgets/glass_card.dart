import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';

/// Frosted/translucent surface used for all FinKu cards and form containers.
///
/// Adapts automatically to dark/light: low-alpha-on-white in dark mode,
/// low-alpha-on-black in light mode (matches web).
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.blurSigma = 18,
    this.fill,
    this.borderColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double blurSigma;
  final Color? fill;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final tokens = FinkuColors.glassTokens(brightness);
    final resolvedFill = fill ?? tokens.fill;
    final resolvedBorder = borderColor ?? tokens.border;

    final content = Container(
      decoration: BoxDecoration(
        color: resolvedFill,
        borderRadius: borderRadius,
        border: Border.all(color: resolvedBorder),
      ),
      padding: padding,
      child: child,
    );

    final clipped = ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: content,
      ),
    );

    if (onTap == null) return clipped;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        children: [
          clipped,
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: borderRadius,
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
