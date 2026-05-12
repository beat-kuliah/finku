import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';

/// Single 5-slot dock item: icon + (when active) label.
///
/// Used by [BottomNavBar]. One dew-like pill follows the finger while pressed;
/// the highlighted slot (icon + label) tracks the finger. On release the
/// selection snaps with no glide animation from the previous tab.
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

class _BottomNavBarState extends State<BottomNavBar> {
  /// Blur strength for the dock glass. Keep moderate: σ≈48 is very expensive on GPU.
  static const _dockBlurSigma = 22.0;

  final _pillMotion = _PillMotion();

  int? _activePointer;
  int _peekIndex = 0;

  /// After pointer-up, keep highlight on the chosen slot until [widget.activeIndex] matches.
  int? _pendingReleaseHighlight;

  @override
  void initState() {
    super.initState();
    _snapPillToRoute();
  }

  @override
  void dispose() {
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

  void _setPreviewToTouch(double x) {
    final cx = x.clamp(-1.0, 1.0);
    final p = _pillMotion;
    p.previewTargetX = cx;
    p.previewAlignX = cx;
    p.repaint();
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
    _setPreviewToTouch(_alignXFromDx(e.localPosition.dx, width));
    setState(() {});
  }

  void _onPointerMove(PointerMoveEvent e, double width) {
    if (e.pointer != _activePointer) return;
    if (!_pillMotion.peekActive) return;
    _setPreviewToTouch(_alignXFromDx(e.localPosition.dx, width));
    final next = _slotIndex(e.localPosition.dx, width);
    if (next != _peekIndex) {
      HapticFeedback.selectionClick();
      _peekIndex = next;
      setState(() {});
    }
  }

  void _onPointerUp(PointerUpEvent e) {
    if (e.pointer != _activePointer) return;
    _activePointer = null;
    final p = _pillMotion;
    if (p.peekActive) {
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
      setState(() {});
    }
  }

  void _onPointerCancel(PointerCancelEvent e) {
    if (e.pointer != _activePointer) return;
    _activePointer = null;
    final p = _pillMotion;
    if (p.peekActive) {
      _snapPillToRoute();
      p.peekActive = false;
      p.repaint();
      _pendingReleaseHighlight = null;
      setState(() {});
    }
  }

  int _highlightSlot(int n) {
    final route = widget.activeIndex.clamp(0, n - 1);
    if (_pillMotion.peekActive) return _peekIndex.clamp(0, n - 1);
    return _pendingReleaseHighlight ?? route;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    const radius = 36.0;
    const barHeight = 78.0;

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
                        // Single “dew” surface: same layer users read as the active tab,
                        // not a second preview stack on top of the route pill.
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

                                      return Align(
                                        alignment: Alignment(ax, 0),
                                        child: SizedBox(
                                          width: slotWidth,
                                          height: h,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: DecoratedBox(
                                              decoration: _navDewPillDecoration(
                                                scheme: scheme,
                                                isDark: isDark,
                                                peeking: p.peekActive,
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

/// One sliding “active” chip: frosted dew / soft haze on glass (no second preview layer).
BoxDecoration _navDewPillDecoration({
  required ColorScheme scheme,
  required bool isDark,
  required bool peeking,
}) {
  final primary = scheme.primary;
  final mist = isDark
      ? Colors.white.withValues(alpha: peeking ? 0.10 : 0.085)
      : Colors.white.withValues(alpha: peeking ? 0.88 : 0.82);
  final hazeBottom = isDark
      ? Colors.white.withValues(alpha: 0.02)
      : primary.withValues(alpha: isDark ? 0.04 : 0.07);

  return BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(24)),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        mist,
        isDark ? Colors.white.withValues(alpha: 0.045) : Colors.white.withValues(alpha: 0.55),
        hazeBottom,
      ],
      stops: const [0.0, 0.52, 1.0],
    ),
    border: Border.all(
      color: isDark
          ? Colors.white.withValues(alpha: peeking ? 0.22 : 0.16)
          : Colors.white.withValues(alpha: peeking ? 0.95 : 0.88),
      width: 0.5,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.05),
        blurRadius: 14,
        offset: const Offset(0, 5),
      ),
      BoxShadow(
        color: Colors.white.withValues(alpha: isDark ? 0.06 : 0.45),
        blurRadius: 10,
        spreadRadius: -6,
        offset: const Offset(0, -2),
      ),
      BoxShadow(
        color: primary.withValues(alpha: isDark ? (peeking ? 0.12 : 0.08) : 0.06),
        blurRadius: 18,
        spreadRadius: -12,
        offset: const Offset(0, 8),
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
          child: Padding(
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
                if (active)
                  Padding(
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
