import 'package:flutter/material.dart';

import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BranchScaffold(
      title: 'Budget',
      subtitle: 'Pagu pengeluaran',
      children: [
        PlaceholderSection(
          icon: Icons.savings_rounded,
          title: 'Pagu per kategori',
          description:
              'Atur batas pengeluaran per kategori dan pantau seberapa cepat kamu menghabiskannya.',
          bullets: [
            'Pagu bulanan per kategori',
            'Indikator progress mingguan',
            'Peringatan saat mendekati limit',
          ],
        ),
      ],
    );
  }
}
