import 'package:flutter/material.dart';

import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';

class WalletsPage extends StatelessWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BranchScaffold(
      title: 'Wallets',
      subtitle: 'Dompet & rekening',
      children: [
        PlaceholderSection(
          icon: Icons.account_balance_wallet_rounded,
          title: 'Semua wallet kamu',
          description:
              'Kelola dompet kas, rekening bank, e-wallet, dan saldo masing-masing dari satu tempat.',
          bullets: [
            'Tambah / edit / arsipkan wallet',
            'Saldo per wallet',
            'Transfer antar wallet',
          ],
        ),
      ],
    );
  }
}
