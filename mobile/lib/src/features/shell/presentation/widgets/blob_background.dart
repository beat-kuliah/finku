import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';

/// Three soft, blurred radial blobs sitting behind every shell/auth screen.
///
/// Opacity is dialed down in light mode to mirror the web's `.dark`/light overrides.
class BlobBackground extends StatelessWidget {
  const BlobBackground({super.key, this.intensity = 1.0});

  final double intensity;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final opacityScale = (isDark ? 0.30 : 0.18) * intensity;

    return IgnorePointer(
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            _Blob(
              top: -120,
              left: -90,
              size: 360,
              color: FinkuColors.cyan500.withValues(alpha: opacityScale * 0.9),
            ),
            _Blob(
              top: 200,
              right: -120,
              size: 420,
              color: FinkuColors.blue600.withValues(alpha: opacityScale),
            ),
            _Blob(
              bottom: -150,
              left: 60,
              size: 380,
              color: FinkuColors.blue800.withValues(alpha: opacityScale * 0.85),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: const SizedBox.expand(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.color,
  });

  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
