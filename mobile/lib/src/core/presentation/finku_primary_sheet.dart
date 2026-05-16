import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';

/// Bottom sheet layout: drag handle, title row, body, optional sticky footer.
///
/// Set [scrollBody] to false when the body contains its own scrollables
/// (e.g. [TabBarView] with [Expanded]).
class FinkuPrimarySheet extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  FinkuPrimarySheet({
    super.key,
    required this.title,
    this.subtitle,
    this.body,
    this.child,
    this.footer,
    double? heightFactor,
    double? maxHeightFraction,
    this.onClose,
    this.scrollBody = true,
  }) : heightFactor = maxHeightFraction ?? heightFactor ?? 0.92;

  final String title;
  final String? subtitle;
  final Widget? body;
  final Widget? child;
  final Widget? footer;
  final double heightFactor;
  final VoidCallback? onClose;
  final bool scrollBody;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mq = MediaQuery.of(context);
    final content = body ?? child;
    assert(content != null, 'FinkuPrimarySheet requires body or child');

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxParent = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : mq.size.height;
        final sheetH = math.min(maxParent, mq.size.height * heightFactor);

        return RepaintBoundary(
          child: SizedBox(
            height: sheetH,
            child: Material(
              color: scheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: scheme.onSurface.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: scheme.onSurface,
                                ),
                              ),
                              if (subtitle != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  subtitle!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: scheme.onSurface.withValues(
                                      alpha: 0.65,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed:
                              onClose ?? () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.close_rounded),
                          tooltip: context.l10n.t('common', 'close'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: scrollBody
                        ? SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                            child: content!,
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                            child: content!,
                          ),
                  ),
                  if (footer != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      child: footer!,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
