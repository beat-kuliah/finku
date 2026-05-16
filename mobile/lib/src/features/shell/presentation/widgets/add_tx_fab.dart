import 'package:flutter/material.dart';
import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';

/// Pulsing gradient FAB used to open the Add Transaction sheet.
class AddTxFab extends StatefulWidget {
  const AddTxFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<AddTxFab> createState() => _AddTxFabState();
}

class _AddTxFabState extends State<AddTxFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_ctrl.value);
        final glowOpacity = 0.35 + 0.25 * t;
        final scale = 1.0 + 0.04 * t;

        return Transform.scale(
          scale: scale,
          child: Semantics(
            label: context.l10n.t('nav', 'addTransaction'),
            button: true,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: FinkuColors.gradientNeon,
                boxShadow: FinkuColors.neonGlow(opacity: glowOpacity, blur: 30),
              ),
              child: child,
            ),
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onPressed,
          customBorder: const CircleBorder(),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.06),
          child: const Center(
            child: Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}
