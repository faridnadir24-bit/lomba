import 'package:flutter/material.dart';
import 'package:obatku/core/constants/medicine_constants.dart';

class FilterChipsRow extends StatelessWidget {
  final Map<StatusStok?, int> counts;
  final StatusStok? selectedFilter;
  final ValueChanged<StatusStok?> onFilterChanged;

  const FilterChipsRow({
    super.key,
    required this.counts,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  Color _getStatusColor(StatusStok? status) {
    switch (status) {
      case StatusStok.aman:
        return const Color(0xFF27AE60);
      case StatusStok.waspada:
        return const Color(0xFFF39C12);
      case StatusStok.kritis:
        return const Color(0xFFE74C3C);
      case null:
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(StatusStok? status) {
    switch (status) {
      case StatusStok.aman:
        return 'Aman';
      case StatusStok.waspada:
        return 'Waspada';
      case StatusStok.kritis:
        return 'Kritis';
      case null:
      default:
        return 'Semua';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filters = [null, StatusStok.aman, StatusStok.waspada, StatusStok.kritis];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          final count = counts[filter] ?? 0;
          final color = _getStatusColor(filter);

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text('${_getStatusLabel(filter)} ($count)'),
              selected: isSelected,
              onSelected: (selected) {
                onFilterChanged(selected ? filter : null);
              },
              selectedColor: color.withOpacity(0.2),
              checkmarkColor: color,
              labelStyle: TextStyle(
                color: isSelected ? color : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? color : Colors.grey.shade300,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
