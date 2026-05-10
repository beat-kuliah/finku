import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/features/auth/presentation/providers/auth_controller.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider).valueOrNull;
    final fullName = auth?.user?.name.trim();
    final name = (fullName == null || fullName.isEmpty)
        ? 'Sahabat FinKu'
        : fullName.split(' ').first;

    return BranchScaffold(
      title: 'Halo, $name 👋',
      subtitle: 'Dashboard',
      children: const [
        PlaceholderSection(
          icon: Icons.insights_rounded,
          title: 'Ringkasan keuangan',
          description:
              'Saldo, pemasukan, dan pengeluaran bulan ini akan tampil di sini begitu integrasi data dashboard selesai.',
          bullets: [
            'Saldo total semua wallet',
            'Pemasukan & pengeluaran bulan ini',
            'Tren 7 hari terakhir',
          ],
        ),
        SizedBox(height: 16),
        PlaceholderSection(
          icon: Icons.notifications_active_rounded,
          title: 'Aktivitas terbaru',
          description: 'Lima transaksi terakhir kamu akan muncul di kartu ini.',
        ),
      ],
    );
  }
}
