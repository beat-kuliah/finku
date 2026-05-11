import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show Ticker;
import 'package:flutter/services.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';

/// Single 5-slot dock item: icon + (when active) label.
///
/// Used by [BottomNavBar]. A committed pill tracks the route; while the finger
/// is down, a preview pill follows the touch so users can scrub across tabs;
/// labels stay on the active route until release.
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

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    super.key,
    required this.items,
    required this.activeIndex,
  });

  final List<BottomNavItemData> items;
  final int activeIndex;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

/// Pill positions + peek flag. Notifies listeners on animation steps without
/// rebuilding the glass bar / backdrop (see [ListenableBuilder] in build).
class _PillMotion extends ChangeNotifier {
  double committedAlignX = 0;
  double committedTargetX = 0;
  double previewAlignX = 0;
  double previewTargetX = 0;
  bool peekActive = false;

  void repaint() => notifyListeners();
}

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {
  /// Exponential chase — higher = snappier, lower = more "water".
  static const _pillChaseK = 19.0;

  /// Blur strength for the dock glass. Keep moderate: σ≈48 is very expensive on GPU.
  static const _dockBlurSigma = 22.0;

  final _pillMotion = _PillMotion();

  Ticker? _pillTicker;
  Duration? _lastPillTick;

  int? _activePointer;
  int _peekIndex = 0;

  @override
  void initState() {
    super.initState();
    _snapPillToRoute();
  }

  @override
  void dispose() {
    _pillTicker?.dispose();
    _pillMotion.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final n = widget.items.length;
    if (n == 0) return;
    if (oldWidget.items.length != n) {
      _snapPillToRoute();
      return;
    }
    if (!_pillMotion.peekActive && widget.activeIndex != oldWidget.activeIndex) {
      _pillMotion.committedTargetX = _alignXForIndex(widget.activeIndex.clamp(0, n - 1), n);
      _startPillTicker();
    }
  }

  double _alignXForIndex(int i, int n) {
    if (n <= 1) return 0;
    return (i / (n - 1)) * 2 - 1;
  }

  /// Maps touch x across the bar to [-1, 1] so the pill can slide continuously.
  double _alignXFromDx(double dx, double width) {
    if (width <= 0) return 0;
    final t = (dx / width).clamp(0.0, 1.0);
    return t * 2 - 1;
  }

  void _snapPillToRoute() {
    final n = widget.items.length;
    if (n == 0) return;
    final x = _alignXForIndex(widget.activeIndex.clamp(0, n - 1), n);
    final p = _pillMotion;
    p.committedTargetX = x;
    p.committedAlignX = x;
    p.previewTargetX = x;
    p.previewAlignX = x;
    p.repaint();
  }

  bool _pillMotionSettled() {
    final p = _pillMotion;
    if ((p.committedTargetX - p.committedAlignX).abs() >= 0.0028) return false;
    if (p.peekActive && (p.previewTargetX - p.previewAlignX).abs() >= 0.0028) {
      return false;
    }
    return true;
  }

  void _startPillTicker() {
    final p = _pillMotion;
    if (_pillMotionSettled()) {
      p.committedAlignX = p.committedTargetX;
      if (p.peekActive) {
        p.previewAlignX = p.previewTargetX;
      }
      return;
    }
    _pillTicker ??= createTicker(_onPillTick);
    _lastPillTick = null;
    if (!_pillTicker!.isActive) _pillTicker!.start();
  }

  void _stopPillTicker() {
    _pillTicker?.stop();
    _lastPillTick = null;
  }

  double _chaseToward(double current, double target, double dt) {
    final d = target - current;
    if (d.abs() < 0.0028) return target;
    final alpha = 1 - math.exp(-_pillChaseK * dt);
    return current + d * alpha;
  }

  void _onPillTick(Duration elapsed) {
    if (!mounted) return;
    final last = _lastPillTick ?? elapsed;
    var dt = (elapsed - last).inMicroseconds / 1e6;
    if (dt <= 0) dt = 1 / 60;
    _lastPillTick = elapsed;

    final p = _pillMotion;
    final nextC = _chaseToward(p.committedAlignX, p.committedTargetX, dt);
    final nextP = p.peekActive
        ? _chaseToward(p.previewAlignX, p.previewTargetX, dt)
        : p.previewAlignX;

    p.committedAlignX = nextC;
    if (p.peekActive) {
      p.previewAlignX = nextP;
    }
    p.repaint();

    final cDone = (p.committedTargetX - nextC).abs() < 0.0028;
    final pDone = !p.peekActive || (p.previewTargetX - nextP).abs() < 0.0028;
    if (cDone && pDone) {
      _stopPillTicker();
      p.committedAlignX = p.committedTargetX;
      if (p.peekActive) {
        p.previewAlignX = p.previewTargetX;
      }
      p.repaint();
    }
  }

  void _setPreviewTarget(double x) {
    _pillMotion.previewTargetX = x.clamp(-1.0, 1.0);
    _startPillTicker();
  }

  int _slotIndex(double dx, double width) {
    final n = widget.items.length;
    if (n <= 1) return 0;
    final slot = width / n;
    return (dx / slot).floor().clamp(0, n - 1);
  }

  void _onPointerDown(PointerDownEvent e, double width) {
    _activePointer = e.pointer;
    final idx = _slotIndex(e.localPosition.dx, width);
    final p = _pillMotion;
    _peekIndex = idx;
    p.peekActive = true;
    p.previewAlignX = p.committedAlignX;
    p.previewTargetX = _alignXFromDx(e.localPosition.dx, width);
    p.repaint();
    _startPillTicker();
  }

  void _onPointerMove(PointerMoveEvent e, double width) {
    if (e.pointer != _activePointer) return;
    if (!_pillMotion.peekActive) return;
    _setPreviewTarget(_alignXFromDx(e.localPosition.dx, width));
    final next = _slotIndex(e.localPosition.dx, width);
    if (next != _peekIndex) {
      HapticFeedback.selectionClick();
      _peekIndex = next;
    }
  }

  void _onPointerUp(PointerUpEvent e) {
    if (e.pointer != _activePointer) return;
    _activePointer = null;
    final p = _pillMotion;
    if (p.peekActive) {
      final n = widget.items.length;
      final idx = _peekIndex.clamp(0, n - 1);
      p.peekActive = false;
      p.previewAlignX = p.committedAlignX;
      p.previewTargetX = p.committedTargetX;
      p.repaint();
      widget.items[idx].onTap();
    }
  }

  void _onPointerCancel(PointerCancelEvent e) {
    if (e.pointer != _activePointer) return;
    _activePointer = null;
    final p = _pillMotion;
    if (p.peekActive) {
      p.peekActive = false;
      p.previewAlignX = p.committedAlignX;
      p.previewTargetX = p.committedTargetX;
      p.repaint();
    }
  }

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
          child: RepaintBoundary(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _dockBlurSigma,
                sigmaY: _dockBlurSigma,
              ),
              child: Container(
                height: barHeight,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  border: hairline,
                  gradient: glassGradient,
                ),
                child: LayoutBuilder(
                  builder: (context, barConstraints) {
                    final barWidth = barConstraints.maxWidth;
                    return Stack(
                      clipBehavior: Clip.antiAlias,
                      children: [
                        Listener(
                          behavior: HitTestBehavior.translucent,
                          onPointerDown: (e) => _onPointerDown(e, barWidth),
                          onPointerMove: (e) => _onPointerMove(e, barWidth),
                          onPointerUp: _onPointerUp,
                          onPointerCancel: _onPointerCancel,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(widget.items.length, (index) {
                              final item = widget.items[index];
                              final n = widget.items.length;
                              final routeSlot = widget.activeIndex.clamp(0, n - 1);
                              final active = index == routeSlot;
                              return Expanded(
                                child: _BottomNavSlot(
                                  key: ValueKey(index),
                                  item: item,
                                  active: active,
                                  color: scheme.onSurface,
                                ),
                              );
                            }),
                          ),
                        ),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: RepaintBoundary(
                              child: ListenableBuilder(
                                listenable: _pillMotion,
                                builder: (context, _) {
                                  final p = _pillMotion;
                                  return LayoutBuilder(
                                    builder: (context, c) {
                                      final n = widget.items.length;
                                      final slotWidth = c.maxWidth / n;
                                      final h = c.maxHeight;
                                      final committedX = p.committedAlignX.clamp(-1.0, 1.0);
                                      final previewX = p.previewAlignX.clamp(-1.0, 1.0);

                                      Widget slotChild(double ax, BoxDecoration deco) {
                                        return Align(
                                          alignment: Alignment(ax, 0),
                                          child: SizedBox(
                                            width: slotWidth,
                                            height: h,
                                            child: Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: DecoratedBox(decoration: deco),
                                            ),
                                          ),
                                        );
                                      }

                                      return Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          slotChild(
                                            committedX,
                                            _navPillDecoration(
                                              isDark: isDark,
                                              fill: pillFill,
                                              border: pillBorder,
                                            ),
                                          ),
                                          if (p.peekActive)
                                            slotChild(
                                              previewX,
                                              _navPreviewPillDecoration(
                                                scheme: scheme,
                                                isDark: isDark,
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

BoxDecoration _navPillDecoration({
  required bool isDark,
  required Color fill,
  required Color border,
  double borderWidth = 0.5,
}) {
  return BoxDecoration(
    color: fill,
    borderRadius: const BorderRadius.all(Radius.circular(24)),
    border: Border.all(color: border, width: borderWidth),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.06),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

/// Touch-track preview pill: follows [ColorScheme.primary] (cyan dark / blue light).
BoxDecoration _navPreviewPillDecoration({
  required ColorScheme scheme,
  required bool isDark,
}) {
  final primary = scheme.primary;
  final gradient = isDark
      ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary.withValues(alpha: 0.11),
            FinkuColors.blue600.withValues(alpha: 0.075),
          ],
        )
      : LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.72),
            primary.withValues(alpha: 0.11),
          ],
        );

  return BoxDecoration(
    gradient: gradient,
    borderRadius: const BorderRadius.all(Radius.circular(24)),
    border: Border.all(
      color: primary.withValues(alpha: isDark ? 0.38 : 0.26),
      width: 0.85,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
      BoxShadow(
        color: primary.withValues(alpha: isDark ? 0.14 : 0.09),
        blurRadius: 20,
        spreadRadius: -10,
        offset: const Offset(0, 6),
      ),
    ],
  );
}

class _BottomNavSlot extends StatelessWidget {
  const _BottomNavSlot({
    super.key,
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

    return Semantics(
      button: true,
      label: item.label,
      onTap: item.onTap,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // Commit is handled by [BottomNavBar]'s [Listener] so preview tracks
          // from pointer down without double-invoking [onTap].
          onTap: () {},
          borderRadius: const BorderRadius.all(Radius.circular(26)),
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeInOutCubic,
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
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeInOutCubic,
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
