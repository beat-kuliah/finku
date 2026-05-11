import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/features/auth/presentation/providers/auth_controller.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/add_transaction_sheet.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/add_tx_fab.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/blob_background.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/bottom_nav_bar.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/finku_logo.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/more_sheet.dart';

/// Branches inside the shell — order MUST match `StatefulShellRoute.indexedStack`.
enum ShellBranch {
  dashboard('Dashboard', 'Beranda finansial kamu'),
  transactions('Transactions', 'Catatan masuk & keluar'),
  wallets('Wallets', 'Dompet & rekening'),
  budget('Budget', 'Pagu pengeluaran'),
  stats('Stats', 'Insight pengeluaran'),
  goals('Goals', 'Target tabungan'),
  profile('Profile', 'Pengaturan akun');

  const ShellBranch(this.title, this.subtitle);

  final String title;
  final String subtitle;

  /// Routing index matches the declaration order (built-in `Enum.index`).
  int get branchIndex => index;

  static ShellBranch fromIndex(int index) {
    if (index < 0 || index >= ShellBranch.values.length) {
      return ShellBranch.dashboard;
    }
    return ShellBranch.values[index];
  }
}

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

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
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
      builder: (context) => const AddTransactionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BottomNavBar(
                    activeIndex: _activeDockIndex(activeBranch),
                    items: _buildDockItems(activeBranch),
                  ),
                ),
              ),
            ),
          if (!useRail)
            Positioned(
              right: 20,
              bottom: 110,
              child: SafeArea(
                top: false,
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

  List<BottomNavItemData> _buildDockItems(ShellBranch active) {
    final moreIsActive = _moreBranches.contains(active);
    final moreLabel = moreIsActive ? active.title : 'More';

    return [
      BottomNavItemData(
        icon: Icons.dashboard_rounded,
        label: 'Home',
        onTap: () => _go(ShellBranch.dashboard),
      ),
      BottomNavItemData(
        icon: Icons.receipt_long_rounded,
        label: 'Transactions',
        onTap: () => _go(ShellBranch.transactions),
      ),
      BottomNavItemData(
        icon: Icons.account_balance_wallet_rounded,
        label: 'Wallets',
        onTap: () => _go(ShellBranch.wallets),
      ),
      BottomNavItemData(
        icon: Icons.savings_rounded,
        label: 'Budget',
        onTap: () => _go(ShellBranch.budget),
      ),
      BottomNavItemData(
        icon: Icons.more_horiz_rounded,
        label: moreLabel,
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
    final bottomPad = isTablet ? 24.0 : 130.0;

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
                              activeBranch.subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: scheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              activeBranch.title,
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
                          const SnackBar(
                            content: Text('Notifikasi: belum ada — pengaturan ada di Profil.'),
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
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final railBg = isDark
        ? FinkuColors.ink900.withValues(alpha: 0.55)
        : Colors.white.withValues(alpha: 0.55);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.06);

    final destinations = ShellBranch.values.map(_destinationFor).toList();

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
                          tooltip: 'Logout',
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

  NavigationRailDestination _destinationFor(ShellBranch branch) {
    final icon = switch (branch) {
      ShellBranch.dashboard => Icons.dashboard_rounded,
      ShellBranch.transactions => Icons.receipt_long_rounded,
      ShellBranch.wallets => Icons.account_balance_wallet_rounded,
      ShellBranch.budget => Icons.savings_rounded,
      ShellBranch.stats => Icons.pie_chart_rounded,
      ShellBranch.goals => Icons.flag_rounded,
      ShellBranch.profile => Icons.person_rounded,
    };
    return NavigationRailDestination(
      icon: Icon(icon),
      selectedIcon: Icon(icon),
      label: Text(branch.title),
    );
  }
}
