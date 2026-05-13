import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/core/theme/theme_controller.dart';
import 'package:finku_mobile/src/features/auth/presentation/providers/auth_controller.dart';
import 'package:finku_mobile/src/features/profile/presentation/providers/preferences_provider.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/glass_card.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/gradient_button.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final auth = ref.watch(authControllerProvider).valueOrNull;
    final user = auth?.user;
    final name = user?.name ?? 'Sahabat FinKu';
    final email = user?.email ?? '';
    final initial = (name.trim().isNotEmpty ? name.trim()[0] : '?').toUpperCase();
    final mode = ref.watch(themeControllerProvider);
    final prefs = ref.watch(preferencesProvider);

    return BranchScaffold(
      title: 'Profil',
      subtitle: 'Akun & preferensi',
      children: [
        GlassCard(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: FinkuColors.gradientNeon,
                  boxShadow: FinkuColors.neonGlow(opacity: 0.4, blur: 22),
                ),
                alignment: Alignment.center,
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 13,
                        color: scheme.onSurface.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tampilan perangkat',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tema FinKu di perangkat ini (terpisah dari preferensi server).',
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 14),
              _ThemeOption(
                icon: Icons.dark_mode_rounded,
                label: 'Mode gelap',
                helper: 'Default — neon vibes.',
                selected: mode == ThemeMode.dark,
                onSelected: () => ref.read(themeControllerProvider.notifier).setMode(ThemeMode.dark),
              ),
              const SizedBox(height: 8),
              _ThemeOption(
                icon: Icons.light_mode_rounded,
                label: 'Mode terang',
                helper: 'Lebih kalem siang hari.',
                selected: mode == ThemeMode.light,
                onSelected: () => ref.read(themeControllerProvider.notifier).setMode(ThemeMode.light),
              ),
              const SizedBox(height: 8),
              _ThemeOption(
                icon: Icons.brightness_auto_rounded,
                label: 'Ikuti sistem',
                helper: 'Otomatis sesuai pengaturan perangkat.',
                selected: mode == ThemeMode.system,
                onSelected: () => ref.read(themeControllerProvider.notifier).setMode(ThemeMode.system),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        prefs.when(
          data: (p) => GlassCard(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preferensi server',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Notifikasi & tema tersimpan di akun (sinkron dengan web).',
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tema server: ${p.theme}',
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Peringatan budget'),
                  value: p.notifyBudgetWarning,
                  onChanged: (v) async {
                    try {
                      await ref.read(preferencesApiProvider).patch({'notifyBudgetWarning': v});
                      ref.invalidate(preferencesProvider);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(mapDioToApiError(e).message)),
                        );
                      }
                    }
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Pengingat'),
                  value: p.notifyReminder,
                  onChanged: (v) async {
                    try {
                      await ref.read(preferencesApiProvider).patch({'notifyReminder': v});
                      ref.invalidate(preferencesProvider);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(mapDioToApiError(e).message)),
                        );
                      }
                    }
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Laporan mingguan'),
                  value: p.notifyWeeklyReport,
                  onChanged: (v) async {
                    try {
                      await ref.read(preferencesApiProvider).patch({'notifyWeeklyReport': v});
                      ref.invalidate(preferencesProvider);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(mapDioToApiError(e).message)),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, stack) => const SizedBox.shrink(),
        ),
        if (prefs.maybeWhen(data: (_) => true, orElse: () => false)) const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Zona bahaya',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: scheme.error,
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Hapus semua data finansial (transaksi, dompet, kategori, dll.) seperti di web.',
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurface.withValues(alpha: 0.65),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _confirmReset(context, ref),
                icon: const Icon(Icons.delete_forever_outlined),
                label: const Text('Reset data finansial'),
                style: OutlinedButton.styleFrom(foregroundColor: scheme.error),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Akun',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(height: 12),
              GradientButton(
                onPressed: () => ref.read(authControllerProvider.notifier).logout(),
                icon: const Icon(Icons.logout_rounded),
                child: const Text('Keluar'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset data finansial?'),
        content: const Text(
          'Semua transaksi, dompet, kategori, budget, dan target akan dihapus. Tindakan ini tidak bisa dibatalkan.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(accountApiProvider).resetFinancialData();
      ref.read(dataRevisionProvider.notifier).state++;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data finansial direset.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapDioToApiError(e).message)),
        );
      }
    }
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.helper,
    required this.selected,
    required this.onSelected,
  });

  final IconData icon;
  final String label;
  final String helper;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = FinkuColors.glassTokens(Theme.of(context).brightness);
    final borderColor = selected ? scheme.primary : tokens.border;

    return Material(
      color: tokens.fill,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: borderColor, width: selected ? 1.4 : 1.0),
      ),
      child: InkWell(
        onTap: onSelected,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: selected ? FinkuColors.gradientNeon : null,
                  color: selected ? null : tokens.fill,
                  border: selected ? null : Border.all(color: tokens.border),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: selected ? Colors.white : scheme.onSurface,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      helper,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: scheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle_rounded, color: scheme.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
