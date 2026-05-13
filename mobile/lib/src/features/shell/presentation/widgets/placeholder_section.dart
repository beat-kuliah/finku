import 'package:flutter/material.dart';

import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/glass_card.dart';

/// Reusable "Coming soon" section used by every placeholder branch page.
class PlaceholderSection extends StatelessWidget {
  const PlaceholderSection({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.bullets = const <String>[],
  });

  final IconData icon;
  final String title;
  final String description;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GlassCard(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: FinkuColors.gradientNeon,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: FinkuColors.neonGlow(opacity: 0.3, blur: 18),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: scheme.onSurface.withValues(alpha: 0.72),
              height: 1.5,
            ),
          ),
          if (bullets.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...bullets.map((b) => Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 7, right: 10),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: FinkuColors.gradientNeon,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          b,
                          style: TextStyle(
                            fontSize: 13,
                            color: scheme.onSurface.withValues(alpha: 0.78),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}

/// Standard padded container used by every shell page.
class BranchScaffold extends StatelessWidget {
  const BranchScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.wrapInScrollView = true,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  /// When false, children manage their own scroll (e.g. [RefreshIndicator] + [ListView]).
  final bool wrapInScrollView;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface.withValues(alpha: 0.55),
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 20),
        ...children,
      ],
    );

    final padded = Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: body,
    );

    if (!wrapInScrollView) {
      return padded;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: body,
    );
  }
}
