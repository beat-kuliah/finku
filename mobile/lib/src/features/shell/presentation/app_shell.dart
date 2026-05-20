import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:finku_mobile/src/core/l10n/l10n_bundle.dart';
import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/features/auth/domain/auth_state.dart';
import 'package:finku_mobile/src/features/auth/presentation/providers/auth_controller.dart';
import 'package:finku_mobile/src/features/auth/presentation/widgets/set_username_modal.dart';
import 'package:finku_mobile/src/features/shell/presentation/shell_branch.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/add_transaction_sheet.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/add_tx_fab.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/blob_background.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/bottom_nav_bar.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/finku_logo.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/more_sheet.dart';

import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';

/// Slots that live INSIDE the bottom dock.
const _dockBranches = <ShellBranch>[
  ShellBranch.dashboard,
  ShellBranch.transactions,
  ShellBranch.wallets,
  ShellBranch.budget,
];

/// Slots reachable only via the "More" sheet on mobile.
const _moreBranches = <ShellBranch>[
  ShellBranch.stats,
  ShellBranch.goals,
  ShellBranch.profile,
];

/// Tablet breakpoint.
const double _kRailBreakpoint = 720;

/// Keep in sync with [BottomNavBar] horizontal padding + `barHeight`.
const double _kDockHorizontalMargin = 20;
/// Minimum lift above the home indicator; applied via [SafeArea.minimum] only (not stacked).
const double _kDockBottomInset = 10;
const double _kDockBarHeight = 86;
/// Space between dock top and FAB bottom (visual breathing room).
const double _kFabGapAboveDock = 18;
/// Keep in sync with [AddTxFab] width/height.
const double _kAddFabSize = 60;

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  bool _usernameGateShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowUsernameGate());
  }

  void _maybeShowUsernameGate() {
    if (_usernameGateShown || !mounted) return;
    final auth = ref.read(authControllerProvider).valueOrNull;
    if (auth?.usernameRequired == true) {
      _usernameGateShown = true;
      showSetUsernameModal(context, blocking: true);
    }
  }

  ShellBranch? _cachedDockItemsBranch;
  String? _cachedDockLocaleCode;
  List<BottomNavItemData>? _cachedDockItems;

  void _go(ShellBranch branch) {
    final shell = widget.navigationShell;
    shell.goBranch(
      branch.index,
      initialLocation: branch.index == shell.currentIndex,
    );
  }

  void _openMoreSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return MoreSheet(
          onNavigate: (branch) {
            Navigator.of(context).pop();
            _go(branch);
          },
        );
      },
    );
  }

  void _openAddTxSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      builder: (context) => const AddTransactionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthState>>(authControllerProvider, (prev, next) {
      final required = next.valueOrNull?.usernameRequired ?? false;
      if (required && !_usernameGateShown && mounted) {
        _usernameGateShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) showSetUsernameModal(context, blocking: true);
        });
      }
      if (!required) _usernameGateShown = false;
    });

    final l10n = ref.l10n;
    final activeBranch = ShellBranch.fromIndex(widget.navigationShell.currentIndex);
    final width = MediaQuery.sizeOf(context).width;
    final useRail = width >= _kRailBreakpoint;

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          const Positioned.fill(child: BlobBackground()),
          Positioned.fill(
            child: useRail
                ? _RailLayout(
                    activeBranch: activeBranch,
                    onSelect: _go,
                    child: _ShellBody(
                      activeBranch: activeBranch,
                      child: widget.navigationShell,
                    ),
                  )
                : _ShellBody(
                    activeBranch: activeBranch,
                    child: widget.navigationShell,
                  ),
          ),
          if (!useRail)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                left: false,
                right: false,
                minimum: const EdgeInsets.only(bottom: _kDockBottomInset),
                child: BottomNavBar(
                  activeIndex: _activeDockIndex(activeBranch),
                  items: _dockItemsFor(activeBranch, l10n),
                ),
              ),
            ),
          if (!useRail)
            Positioned(
              right: _kDockHorizontalMargin,
              bottom: _kDockBarHeight + _kFabGapAboveDock,
              child: SafeArea(
                top: false,
                left: false,
                right: false,
                minimum: const EdgeInsets.only(bottom: _kDockBottomInset),
                child: AddTxFab(onPressed: _openAddTxSheet),
              ),
            ),
          if (useRail)
            Positioned(
              right: 28,
              bottom: 28,
              child: AddTxFab(onPressed: _openAddTxSheet),
            ),
        ],
      ),
    );
  }

  int _activeDockIndex(ShellBranch active) {
    final dockIndex = _dockBranches.indexOf(active);
    if (dockIndex >= 0) return dockIndex;
    return _dockBranches.length;
  }

  List<BottomNavItemData> _dockItemsFor(ShellBranch active, L10nBundle l10n) {
    final localeCode = l10n.locale.languageCode;
    if (_cachedDockItems != null &&
        _cachedDockItemsBranch == active &&
        _cachedDockLocaleCode == localeCode) {
      return _cachedDockItems!;
    }
    _cachedDockItemsBranch = active;
    _cachedDockLocaleCode = localeCode;
    _cachedDockItems = _buildDockItems(active, l10n);
    return _cachedDockItems!;
  }

  List<BottomNavItemData> _buildDockItems(ShellBranch active, L10nBundle l10n) {
    final moreIsActive = _moreBranches.contains(active);
    final moreLabel =
        moreIsActive ? active.navLabel(l10n) : l10n.t('nav', 'more');

    return [
      BottomNavItemData(
        icon: Icons.dashboard_rounded,
        label: ShellBranch.dashboard.navLabel(l10n),
        onTap: () => _go(ShellBranch.dashboard),
      ),
      BottomNavItemData(
        icon: Icons.receipt_long_rounded,
        label: ShellBranch.transactions.navLabel(l10n),
        onTap: () => _go(ShellBranch.transactions),
      ),
      BottomNavItemData(
        icon: Icons.account_balance_wallet_rounded,
        label: ShellBranch.wallets.navLabel(l10n),
        onTap: () => _go(ShellBranch.wallets),
      ),
      BottomNavItemData(
        icon: Icons.savings_rounded,
        label: ShellBranch.budget.navLabel(l10n),
        onTap: () => _go(ShellBranch.budget),
      ),
      BottomNavItemData(
        icon: Icons.more_horiz_rounded,
        label: moreLabel,
        semanticsLabel: moreIsActive
            ? l10n.t('nav', 'moreAriaActive', args: {'label': moreLabel})
            : l10n.t('nav', 'moreAria'),
        onTap: _openMoreSheet,
      ),
    ];
  }
}

class _ShellBody extends ConsumerWidget {
  const _ShellBody({required this.activeBranch, required this.child});

  final ShellBranch activeBranch;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final isTablet = width >= _kRailBreakpoint;
    // Clear dock + FAB: extra inset beyond `MediaQuery.padding.bottom`.
    final bottomPad = isTablet
        ? 24.0
        : _kDockBarHeight + _kFabGapAboveDock + _kAddFabSize + 8;

    return Column(
      children: [
        _ShellHeader(activeBranch: activeBranch, isTablet: isTablet),
        Expanded(
          child: MediaQuery(
            data: media.copyWith(
              padding: media.padding.copyWith(bottom: media.padding.bottom + bottomPad),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

class _ShellHeader extends ConsumerWidget {
  const _ShellHeader({required this.activeBranch, required this.isTablet});

  final ShellBranch activeBranch;
  final bool isTablet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.l10n;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = ref.watch(authControllerProvider).valueOrNull;
    final user = auth?.user;
    final initial = ((user?.name ?? user?.email ?? '?').trim().isNotEmpty
            ? (user?.name ?? user?.email ?? '?').trim()[0]
            : '?')
        .toUpperCase();

    final headerBg = isDark
        ? FinkuColors.ink900.withValues(alpha: 0.55)
        : Colors.white.withValues(alpha: 0.55);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.06);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: headerBg,
            border: Border(bottom: BorderSide(color: borderColor)),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    if (isTablet)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              activeBranch.navSubheader(l10n),
                              style: TextStyle(
                                fontSize: 12,
                                color: scheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              activeBranch.navLabel(l10n),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      const Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FinkuLogo(size: FinkuLogoSize.md),
                        ),
                      ),
                    _IconChip(
                      icon: Icons.notifications_outlined,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.t('nav', 'notificationsToast')),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: FinkuColors.gradientNeon,
                        boxShadow: FinkuColors.neonGlow(opacity: 0.3, blur: 16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initial,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconChip extends StatelessWidget {
  const _IconChip({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final tokens = FinkuColors.glassTokens(brightness);
    return Material(
      color: tokens.fill,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        side: BorderSide(color: tokens.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }
}

class _RailLayout extends ConsumerWidget {
  const _RailLayout({
    required this.activeBranch,
    required this.onSelect,
    required this.child,
  });

  final ShellBranch activeBranch;
  final void Function(ShellBranch) onSelect;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.l10n;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final railBg = isDark
        ? FinkuColors.ink900.withValues(alpha: 0.55)
        : Colors.white.withValues(alpha: 0.55);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.06);

    final destinations =
        ShellBranch.values.map((b) => _destinationFor(b, l10n)).toList();

    return Row(
      children: [
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                color: railBg,
                border: Border(right: BorderSide(color: borderColor)),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: FinkuLogo(size: FinkuLogoSize.md),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: NavigationRail(
                          backgroundColor: Colors.transparent,
                          selectedIndex: activeBranch.index,
                          onDestinationSelected: (i) => onSelect(ShellBranch.fromIndex(i)),
                          labelType: NavigationRailLabelType.all,
                          indicatorColor: scheme.primary.withValues(alpha: 0.18),
                          destinations: destinations,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: IconButton(
                          tooltip: l10n.t('nav', 'logout'),
                          onPressed: () {
                            ref.read(authControllerProvider.notifier).logout();
                          },
                          icon: const Icon(Icons.logout),
                          color: scheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }

  NavigationRailDestination _destinationFor(ShellBranch branch, L10nBundle l10n) {
    final icon = switch (branch) {
      ShellBranch.dashboard => Icons.dashboard_rounded,
      ShellBranch.transactions => Icons.receipt_long_rounded,
      ShellBranch.wallets => Icons.account_balance_wallet_rounded,
      ShellBranch.budget => Icons.savings_rounded,
      ShellBranch.stats => Icons.pie_chart_rounded,
      ShellBranch.goals => Icons.flag_rounded,
      ShellBranch.profile => Icons.person_rounded,
    };
    final labelKey = branch == ShellBranch.dashboard ? 'dashboard' : branch.name;
    return NavigationRailDestination(
      icon: Icon(icon),
      selectedIcon: Icon(icon),
      label: Text(l10n.t('nav', labelKey)),
    );
  }
}
