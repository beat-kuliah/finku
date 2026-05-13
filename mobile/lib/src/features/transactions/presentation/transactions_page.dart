import 'package:flutter/material.dart';

import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BranchScaffold(
      title: 'Transactions',
      subtitle: 'Catatan keuangan',
      children: [
        PlaceholderSection(
          icon: Icons.receipt_long_rounded,
          title: 'Daftar transaksi',
          description:
              'Daftar pemasukan & pengeluaran lengkap dengan filter berdasarkan tanggal, kategori, dan dompet akan hadir di sini.',
          bullets: [
            'Filter & pencarian',
            'Detail transaksi',
            'Edit / hapus dengan konfirmasi',
          ],
        ),
      ],
    );
  }
}
