import 'package:flutter/material.dart';

import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BranchScaffold(
      title: 'Stats',
      subtitle: 'Insight pengeluaran',
      children: [
        PlaceholderSection(
          icon: Icons.pie_chart_rounded,
          title: 'Visualisasi keuangan',
          description:
              'Grafik tren pemasukan/pengeluaran, breakdown per kategori, dan ringkasan bulanan akan tampil di sini.',
          bullets: [
            'Pie chart per kategori',
            'Tren bulanan',
            'Highlight pengeluaran terbesar',
          ],
        ),
      ],
    );
  }
}
