import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show Ticker;
import 'package:flutter/services.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';

/// Single 5-slot dock item: icon + label (labels always visible).
///
/// Used by [BottomNavBar]. Touching the dock scales it up slightly; while
/// pressed, the dew pill eases toward the finger with stretch + liquid shading.
/// On release the selection snaps with no glide from the previous route.
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

/// Pill positions + peek flag. [ListenableBuilder] repaints the dew pill without
/// rebuilding the whole bar.
class _PillMotion extends ChangeNotifier {
  double committedAlignX = 0;
  double committedTargetX = 0;
  double previewAlignX = 0;
  double previewTargetX = 0;
  bool peekActive = false;

  void repaint() => notifyListeners();
}

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {
  /// Blur strength for the dock glass. Keep moderate: σ≈48 is very expensive on GPU.
  static const _dockBlurSigma = 22.0;

  /// Preview pill chase while holding — lower = slower, more “water / dew”.
  static const _previewDewK = 11.0;

  static const _alignEpsilon = 0.0028;

  final _pillMotion = _PillMotion();

  Ticker? _pillTicker;
  Duration? _lastPillTick;

  int? _activePointer;
  int _peekIndex = 0;

  /// After pointer-up, keep highlight on the chosen slot until [widget.activeIndex] matches.
  int? _pendingReleaseHighlight;

  /// Whole dock scales up slightly while the bar is pressed.
  bool _dockPressed = false;

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
      final x = _alignXForIndex(widget.activeIndex.clamp(0, n - 1), n);
      final p = _pillMotion;
      p.committedTargetX = x;
      p.committedAlignX = x;
      p.previewTargetX = x;
      p.previewAlignX = x;
      p.repaint();
    }
    if (_pendingReleaseHighlight != null) {
      if (widget.activeIndex == _pendingReleaseHighlight) {
        _pendingReleaseHighlight = null;
      } else if (widget.activeIndex != oldWidget.activeIndex &&
          widget.activeIndex != _pendingReleaseHighlight) {
        _pendingReleaseHighlight = null;
      }
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
    _stopPillTicker();
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

  void _stopPillTicker() {
    _pillTicker?.stop();
    _lastPillTick = null;
  }

  double _chaseToward(double current, double target, double dt) {
    final d = target - current;
    if (d.abs() < _alignEpsilon) return target;
    final alpha = 1 - math.exp(-_previewDewK * dt);
    return current + d * alpha;
  }

  bool _previewChaseSettled() {
    final p = _pillMotion;
    return (p.previewTargetX - p.previewAlignX).abs() < _alignEpsilon;
  }

  void _startPreviewChaseTicker() {
    final p = _pillMotion;
    if (!p.peekActive) return;
    if (_previewChaseSettled()) {
      p.previewAlignX = p.previewTargetX;
      return;
    }
    _pillTicker ??= createTicker(_onPreviewChaseTick);
    _lastPillTick = null;
    if (!_pillTicker!.isActive) _pillTicker!.start();
  }

  void _onPreviewChaseTick(Duration elapsed) {
    if (!mounted) return;
    final p = _pillMotion;
    if (!p.peekActive) {
      _stopPillTicker();
      return;
    }
    final last = _lastPillTick ?? elapsed;
    var dt = (elapsed - last).inMicroseconds / 1e6;
    if (dt <= 0) dt = 1 / 60;
    _lastPillTick = elapsed;

    final next = _chaseToward(p.previewAlignX, p.previewTargetX, dt);
    p.previewAlignX = next;
    p.repaint();

    if ((p.previewTargetX - next).abs() < _alignEpsilon) {
      p.previewAlignX = p.previewTargetX;
      _stopPillTicker();
      p.repaint();
    }
  }

  /// Finger target only; [previewAlignX] eases toward it while [peekActive].
  void _setPreviewTargetTowardTouch(double x) {
    final p = _pillMotion;
    p.previewTargetX = x.clamp(-1.0, 1.0);
    _startPreviewChaseTicker();
    p.repaint();
  }

  int _slotIndexFromAlignX(double ax, int n) {
    if (n <= 1) return 0;
    final t = ((ax.clamp(-1.0, 1.0) + 1) * 0.5).clamp(0.0, 1.0);
    return (t * n).floor().clamp(0, n - 1);
  }

  int _slotIndex(double dx, double width) {
    final n = widget.items.length;
    if (n <= 1) return 0;
    final slot = width / n;
    return (dx / slot).floor().clamp(0, n - 1);
  }

  void _onPointerDown(PointerDownEvent e, double width) {
    setState(() => _dockPressed = true);
    _activePointer = e.pointer;
    final idx = _slotIndex(e.localPosition.dx, width);
    final p = _pillMotion;
    _peekIndex = idx;
    p.peekActive = true;
    // Start the dew slide from the committed pill, not an instant jump.
    p.previewAlignX = p.committedAlignX;
    _setPreviewTargetTowardTouch(_alignXFromDx(e.localPosition.dx, width));
  }

  void _onPointerMove(PointerMoveEvent e, double width) {
    if (e.pointer != _activePointer) return;
    if (!_pillMotion.peekActive) return;
    _setPreviewTargetTowardTouch(_alignXFromDx(e.localPosition.dx, width));
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
      _stopPillTicker();
      final n = widget.items.length;
      final idx = _peekIndex.clamp(0, n - 1);
      final x = _alignXForIndex(idx, n);
      p.peekActive = false;
      p.committedTargetX = x;
      p.committedAlignX = x;
      p.previewTargetX = x;
      p.previewAlignX = x;
      p.repaint();
      if (idx != widget.activeIndex.clamp(0, n - 1)) {
        _pendingReleaseHighlight = idx;
      } else {
        _pendingReleaseHighlight = null;
      }
      widget.items[idx].onTap();
    }
    setState(() => _dockPressed = false);
  }

  void _onPointerCancel(PointerCancelEvent e) {
    if (e.pointer != _activePointer) return;
    _activePointer = null;
    setState(() => _dockPressed = false);
    final p = _pillMotion;
    if (p.peekActive) {
      _stopPillTicker();
      _snapPillToRoute();
      p.peekActive = false;
      p.repaint();
      _pendingReleaseHighlight = null;
    }
  }

  int _highlightSlot(int n) {
    final route = widget.activeIndex.clamp(0, n - 1);
    if (_pillMotion.peekActive) {
      return _slotIndexFromAlignX(_pillMotion.previewAlignX, n);
    }
    return _pendingReleaseHighlight ?? route;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    const radius = 36.0;
    const barHeight = 86.0;
    const dockPressedScale = 1.045;

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
      // Horizontal inset only; bottom lift comes from [AppShell] SafeArea.minimum.
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedScale(
        scale: _dockPressed ? dockPressedScale : 1.0,
        alignment: Alignment.bottomCenter,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
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
                        // Dew pill: viscous chase + liquid stretch / shading.
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
                                      final ax = (p.peekActive ? p.previewAlignX : p.committedAlignX)
                                          .clamp(-1.0, 1.0);
                                      final lag = p.peekActive
                                          ? (p.previewTargetX - p.previewAlignX).abs()
                                          : 0.0;
                                      final motion = (lag * 3.8).clamp(0.0, 1.0);
                                      final sx = 1.0 + motion * 0.14;
                                      final sy = 1.0 - motion * 0.08;

                                      return Align(
                                        alignment: Alignment(ax, 0),
                                        child: SizedBox(
                                          width: slotWidth,
                                          height: h,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Transform(
                                              alignment: Alignment.center,
                                              transform: Matrix4.diagonal3Values(sx, sy, 1.0),
                                              child: DecoratedBox(
                                                decoration: _navDewPillDecoration(
                                                  scheme: scheme,
                                                  isDark: isDark,
                                                  peeking: p.peekActive,
                                                  motionLag: motion,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        ListenableBuilder(
                          listenable: _pillMotion,
                          builder: (context, _) {
                            return Listener(
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
                                  final highlight = _highlightSlot(n);
                                  final active = index == highlight;
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
                            );
                          },
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
      ),
    );
  }
}

/// Frosted dew chip; [motionLag] (0–1) boosts liquid highlights while chasing the finger.
BoxDecoration _navDewPillDecoration({
  required ColorScheme scheme,
  required bool isDark,
  required bool peeking,
  double motionLag = 0,
}) {
  final lag = motionLag.clamp(0.0, 1.0);
  final primary = scheme.primary;
  final mist = isDark
      ? Colors.white.withValues(alpha: peeking ? 0.10 + lag * 0.02 : 0.085)
      : Colors.white.withValues(alpha: peeking ? 0.88 + lag * 0.04 : 0.82);
  final hazeBottom = isDark
      ? Colors.white.withValues(alpha: 0.02 + lag * 0.03)
      : primary.withValues(alpha: 0.07 + lag * 0.05);

  return BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(24)),
    gradient: LinearGradient(
      begin: Alignment(-0.35 + lag * 0.2, -1),
      end: Alignment(0.4 - lag * 0.15, 1.1),
      colors: [
        Color.lerp(
              mist,
              isDark ? Colors.white.withValues(alpha: 0.22) : Colors.white,
              lag * 0.35,
            ) ??
            mist,
        isDark
            ? Colors.white.withValues(alpha: 0.045 + lag * 0.04)
            : Colors.white.withValues(alpha: 0.55 + lag * 0.12),
        hazeBottom,
      ],
      stops: [0.0, 0.45 + lag * 0.08, 1.0],
    ),
    border: Border.all(
      color: isDark
          ? Colors.white.withValues(alpha: peeking ? 0.22 + lag * 0.08 : 0.16 + lag * 0.05)
          : Colors.white.withValues(alpha: peeking ? 0.95 : 0.88),
      width: 0.5 + lag * 0.35,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.05),
        blurRadius: 14 + lag * 8,
        offset: Offset(0, 5 + lag * 3),
      ),
      BoxShadow(
        color: Colors.white.withValues(alpha: isDark ? 0.06 + lag * 0.08 : 0.45 + lag * 0.12),
        blurRadius: 10 + lag * 14,
        spreadRadius: -6 - lag * 4,
        offset: Offset(0, -2 - lag * 2),
      ),
      BoxShadow(
        color: primary.withValues(alpha: isDark ? (peeking ? 0.12 : 0.08) + lag * 0.14 : 0.06 + lag * 0.12),
        blurRadius: 18 + lag * 22,
        spreadRadius: -12 - lag * 6,
        offset: Offset(0, 8 + lag * 4),
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
          // Commit is handled by [BottomNavBar]'s [Listener] so drag does not
          // double-invoke [onTap].
          onTap: () {},
          borderRadius: const BorderRadius.all(Radius.circular(26)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  size: 22,
                  color: active ? color : muted,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                      color: active ? color : muted,
                      letterSpacing: 0.1,
                    ),
                  ),
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
