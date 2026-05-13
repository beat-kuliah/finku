import 'package:flutter/material.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';

/// Primary CTA: cyan → blue gradient with neon glow shadow.
///
/// Falls back to a non-glowing pressed/disabled appearance.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.loading = false,
    this.expand = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final bool loading;
  final bool expand;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || loading;

    final gradient = disabled
        ? LinearGradient(
            colors: [
              FinkuColors.blue800.withValues(alpha: 0.55),
              FinkuColors.blue600.withValues(alpha: 0.55),
            ],
          )
        : FinkuColors.gradientNeon;

    final shadows = disabled ? const <BoxShadow>[] : FinkuColors.neonGlow();

    final content = Padding(
      padding: padding,
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loading)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          else if (icon != null) ...[
            IconTheme.merge(
              data: const IconThemeData(color: Colors.white, size: 20),
              child: icon!,
            ),
            const SizedBox(width: 10),
          ],
          if (!loading)
            DefaultTextStyle.merge(
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
              ),
              child: child,
            ),
        ],
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: shadows,
        gradient: gradient,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onPressed,
          borderRadius: borderRadius,
          splashColor: Colors.white.withValues(alpha: 0.18),
          highlightColor: Colors.white.withValues(alpha: 0.06),
          child: content,
        ),
      ),
    );
  }
}
