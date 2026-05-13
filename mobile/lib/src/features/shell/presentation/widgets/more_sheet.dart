import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/theme/theme_controller.dart';
import 'package:finku_mobile/src/features/auth/presentation/providers/auth_controller.dart';
import 'package:finku_mobile/src/features/shell/presentation/app_shell.dart';

/// Bottom sheet revealed by the "More" slot of the dock.
///
/// Hosts secondary destinations (Stats / Goals / Profile), a theme toggle,
/// and a Logout action.
class MoreSheet extends ConsumerWidget {
  const MoreSheet({super.key, required this.onNavigate});

  final void Function(ShellBranch branch) onNavigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mode = ref.watch(themeControllerProvider);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 18, top: 4),
              child: Text(
                'Lainnya',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                  fontSize: 18,
                ),
              ),
            ),
            _SheetTile(
              icon: Icons.pie_chart_rounded,
              label: 'Statistik',
              onTap: () => onNavigate(ShellBranch.stats),
            ),
            const SizedBox(height: 8),
            _SheetTile(
              icon: Icons.flag_rounded,
              label: 'Target',
              onTap: () => onNavigate(ShellBranch.goals),
            ),
            const SizedBox(height: 8),
            _SheetTile(
              icon: Icons.person_rounded,
              label: 'Profil',
              onTap: () => onNavigate(ShellBranch.profile),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: scheme.surfaceContainer,
                borderRadius: const BorderRadius.all(Radius.circular(18)),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: scheme.onSurface,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Mode gelap',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  Switch(
                    value: mode == ThemeMode.dark,
                    onChanged: (next) {
                      ref
                          .read(themeControllerProvider.notifier)
                          .setMode(next ? ThemeMode.dark : ThemeMode.light);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SheetTile(
              icon: Icons.logout_rounded,
              label: 'Keluar',
              danger: true,
              onTap: () async {
                Navigator.of(context).pop();
                await ref.read(authControllerProvider.notifier).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetTile extends StatelessWidget {
  const _SheetTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = danger ? scheme.error : scheme.onSurface;
    return Material(
      color: scheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: fg, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: fg.withValues(alpha: 0.5), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
