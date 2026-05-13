import 'package:flutter/material.dart';

class FinkuFilterChipData {
  const FinkuFilterChipData({
    required this.id,
    required this.label,
  });

  /// Empty string means "all".
  final String id;
  final String label;
}

/// Horizontally scrollable filter chips.
class FinkuFilterChips extends StatelessWidget {
  const FinkuFilterChips({
    super.key,
    required this.chips,
    required this.selectedId,
    required this.onSelected,
  });

  final List<FinkuFilterChipData> chips;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final c = chips[i];
          final selected = c.id == selectedId;
          return FilterChip(
            label: Text(c.label),
            selected: selected,
            onSelected: (_) => onSelected(c.id),
            showCheckmark: false,
            selectedColor: scheme.primary.withValues(alpha: 0.22),
            labelStyle: TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: scheme.onSurface,
              fontSize: 13,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            side: BorderSide(
              color: selected ? scheme.primary : scheme.outline.withValues(alpha: 0.35),
            ),
          );
        },
      ),
    );
  }
}
