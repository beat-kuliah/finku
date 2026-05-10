import 'package:flutter/material.dart';

import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BranchScaffold(
      title: 'Goals',
      subtitle: 'Target tabungan',
      children: [
        PlaceholderSection(
          icon: Icons.flag_rounded,
          title: 'Targetmu, terarah',
          description:
              'Buat target tabungan (rumah, gadget, dana darurat) lengkap dengan progres dan estimasi waktu pencapaian.',
          bullets: [
            'Buat target dengan deadline',
            'Setor manual atau otomatis',
            'Progress visual & milestone',
          ],
        ),
      ],
    );
  }
}
