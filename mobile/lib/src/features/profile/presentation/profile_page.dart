import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/l10n/app_locale.dart';
import 'package:finku_mobile/src/core/l10n/l10n_bundle.dart';
import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/l10n/locale_controller.dart';
import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/core/theme/theme_controller.dart';
import 'package:finku_mobile/src/features/auth/presentation/providers/auth_controller.dart';
import 'package:finku_mobile/src/features/profile/presentation/providers/preferences_provider.dart';
import 'package:finku_mobile/src/features/categories/presentation/widgets/categories_profile_entry.dart';
import 'package:finku_mobile/src/features/profile/presentation/widgets/profile_account_sections.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/glass_card.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/gradient_button.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(l10nBundleProvider);
    final l10n = ref.l10n;
    final scheme = Theme.of(context).colorScheme;
    final auth = ref.watch(authControllerProvider).valueOrNull;
    final user = auth?.user;
    final name = user?.name ?? l10n.t('profile', 'guestName');
    final email = user?.email ?? '';
    final initial = (name.trim().isNotEmpty ? name.trim()[0] : '?').toUpperCase();
    final mode = ref.watch(themeControllerProvider);
    final prefs = ref.watch(preferencesProvider);
    final locale = ref.watch(localeControllerProvider);

    return BranchScaffold(
      title: l10n.t('nav', 'profile'),
      subtitle: l10n.t('profile', 'pageSubtitle'),
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
        if (user != null) ...[
          const SizedBox(height: 16),
          GlassCard(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: ProfileUsernameSection(user: user),
          ),
          const SizedBox(height: 16),
          GlassCard(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: ProfilePasswordSection(hasPassword: user.hasPassword),
          ),
          const SizedBox(height: 16),
          GlassCard(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: ProfileOAuthSection(user: user),
          ),
          const SizedBox(height: 16),
          GlassCard(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: ProfileFinanceSection(user: user),
          ),
          const SizedBox(height: 16),
          const CategoriesProfileEntry(),
        ],
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.t('profile', 'language'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.t('profile', 'languageDesc'),
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 14),
              _LanguageOption(
                label: l10n.t('profile', 'languageId'),
                selected: locale == AppLocale.id,
                onSelected: () => _changeLocale(context, ref, AppLocale.id),
              ),
              const SizedBox(height: 8),
              _LanguageOption(
                label: l10n.t('profile', 'languageEn'),
                selected: locale == AppLocale.en,
                onSelected: () => _changeLocale(context, ref, AppLocale.en),
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
                l10n.t('profile', 'deviceDisplay'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.t('profile', 'deviceDisplayDesc'),
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 14),
              _ThemeOption(
                icon: Icons.dark_mode_rounded,
                label: l10n.t('profile', 'themeDark'),
                helper: l10n.t('profile', 'themeDarkHelper'),
                selected: mode == ThemeMode.dark,
                onSelected: () => ref.read(themeControllerProvider.notifier).setMode(ThemeMode.dark),
              ),
              const SizedBox(height: 8),
              _ThemeOption(
                icon: Icons.light_mode_rounded,
                label: l10n.t('profile', 'themeLight'),
                helper: l10n.t('profile', 'themeLightHelper'),
                selected: mode == ThemeMode.light,
                onSelected: () => ref.read(themeControllerProvider.notifier).setMode(ThemeMode.light),
              ),
              const SizedBox(height: 8),
              _ThemeOption(
                icon: Icons.brightness_auto_rounded,
                label: l10n.t('profile', 'themeSystem'),
                helper: l10n.t('profile', 'themeSystemHelper'),
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
                  l10n.t('profile', 'serverPrefs'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.t('profile', 'serverPrefsDesc'),
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.t('profile', 'serverTheme', args: {'theme': p.theme}),
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.t('profile', 'budgetWarning')),
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
                  title: Text(l10n.t('profile', 'reminder')),
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
                  title: Text(l10n.t('profile', 'weeklyReport')),
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
                l10n.t('profile', 'dangerZone'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: scheme.error,
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.t('profile', 'dangerDesc'),
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
                label: Text(l10n.t('profile', 'resetData')),
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
                l10n.t('profile', 'accountSection'),
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
                child: Text(l10n.t('nav', 'logout')),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _changeLocale(
    BuildContext context,
    WidgetRef ref,
    AppLocale next,
  ) async {
    final current = ref.read(localeControllerProvider);
    if (current == next) return;

    await ref.read(localeControllerProvider.notifier).setLocale(next);
    if (!context.mounted) return;

    final bundle = await L10nBundle.load(next);
    if (!context.mounted) return;

    final label = bundle.t('profile', next == AppLocale.id ? 'languageId' : 'languageEn');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          bundle.t('profile', 'languageChanged', args: {'language': label}),
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.t('profile', 'resetDialogTitle')),
        content: Text(l10n.t('profile', 'resetDialogBody')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.t('common', 'cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.t('profile', 'resetAction')),
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
          SnackBar(content: Text(context.l10n.t('profile', 'resetSuccess'))),
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

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
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
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
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
