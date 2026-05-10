import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';

/// Single 5-slot dock item: icon + (when active) label.
///
/// Used by [BottomNavBar]. The active "pill" background is rendered in the
/// parent so it can animate across slots via [AnimatedAlign].
class BottomNavItemData {
  const BottomNavItemData({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.items,
    required this.activeIndex,
  });

  final List<BottomNavItemData> items;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    const radius = 36.0;
    const barHeight = 78.0;

    final pillFill = isDark
        ? Colors.white.withValues(alpha: 0.11)
        : Colors.white.withValues(alpha: 0.78);
    final pillBorder = isDark
        ? Colors.white.withValues(alpha: 0.18)
        : Colors.white.withValues(alpha: 0.9);

    final glassGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
              Colors.white.withValues(alpha: 0.14),
              Colors.white.withValues(alpha: 0.06),
              Colors.white.withValues(alpha: 0.03),
            ]
          : [
              Colors.white.withValues(alpha: 0.62),
              Colors.white.withValues(alpha: 0.38),
              Colors.white.withValues(alpha: 0.30),
            ],
      stops: const [0.0, 0.45, 1.0],
    );

    final hairline = Border.all(
      width: 0.5,
      color: isDark
          ? Colors.white.withValues(alpha: 0.24)
          : Colors.white.withValues(alpha: 0.72),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.42 : 0.14),
              blurRadius: 36,
              offset: const Offset(0, 16),
              spreadRadius: -10,
            ),
            BoxShadow(
              color: FinkuColors.cyan500.withValues(alpha: isDark ? 0.07 : 0.05),
              blurRadius: 24,
              offset: const Offset(0, 10),
              spreadRadius: -12,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
            child: Container(
              height: barHeight,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                border: hairline,
                gradient: glassGradient,
              ),
              child: Stack(
                clipBehavior: Clip.antiAlias,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(items.length, (index) {
                      final item = items[index];
                      final clamped = activeIndex.clamp(0, items.length - 1);
                      final active = index == clamped;
                      return Expanded(
                        child: _BottomNavSlot(
                          item: item,
                          active: active,
                          color: scheme.onSurface,
                        ),
                      );
                    }),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: LayoutBuilder(
                        builder: (context, c) {
                          final slotWidth = c.maxWidth / items.length;
                          final clamped = activeIndex.clamp(0, items.length - 1);
                          final indicatorAlignX = items.length == 1
                              ? 0.0
                              : (clamped / (items.length - 1)) * 2 - 1;
                          final h = c.maxHeight;

                          return AnimatedAlign(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeOutCubic,
                            alignment: Alignment(indicatorAlignX, 0),
                            child: SizedBox(
                              width: slotWidth,
                              height: h,
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 240),
                                  decoration: BoxDecoration(
                                    color: pillFill,
                                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                                    border: Border.all(color: pillBorder, width: 0.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.06),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavSlot extends StatelessWidget {
  const _BottomNavSlot({
    required this.item,
    required this.active,
    required this.color,
  });

  final BottomNavItemData item;
  final bool active;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final muted = color.withValues(alpha: 0.62);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: const BorderRadius.all(Radius.circular(26)),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.symmetric(vertical: active ? 8 : 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 22,
                color: active ? color : muted,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: active
                    ? Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: color,
                            letterSpacing: 0.1,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Convenience: returns the FinKu accent color used to "highlight" the active
/// item label / icon. Kept top-level so it can be reused by the More sheet.
Color finkuActiveAccent(BuildContext context) {
  return Theme.of(context).colorScheme.onSurface;
}

/// Re-exported so callers don't need a separate import for the brand gradient.
LinearGradient get finkuBrandGradient => FinkuColors.gradientNeon;
