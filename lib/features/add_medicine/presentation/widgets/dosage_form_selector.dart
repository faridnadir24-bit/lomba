import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obatku/features/add_medicine/providers/add_medicine_provider.dart';

class DosageFormSelector extends ConsumerWidget {
  const DosageFormSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(addMedicineFormProvider);
    final formNotifier = ref.read(addMedicineFormProvider.notifier);

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: SediaanObat.values.map((sediaan) {
        final isSelected = formState.form == sediaan;
        return GestureDetector(
          onTap: () => formNotifier.setField(form: sediaan),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1B4332) : const Color(0xFFD8F3DC),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isSelected ? const Color(0xFF1B4332) : const Color(0xFF1B4332),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIconForSediaan(sediaan),
                  color: isSelected ? Colors.white : const Color(0xFF1B4332),
                ),
                const SizedBox(width: 8),
                Text(
                  _getLabelForSediaan(sediaan),
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF1B4332),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconForSediaan(SediaanObat sediaan) {
    switch (sediaan) {
      case SediaanObat.tablet:
        return Icons.medication;
      case SediaanObat.kapsul:
        return Icons.medication_liquid;
      case SediaanObat.sirup:
        return Icons.local_drink;
      case SediaanObat.injeksi:
        return Icons.vaccines;
      case SediaanObat.salep:
        return Icons.healing;
    }
  }

  String _getLabelForSediaan(SediaanObat sediaan) {
    switch (sediaan) {
      case SediaanObat.tablet:
        return 'Tablet';
      case SediaanObat.kapsul:
        return 'Kapsul';
      case SediaanObat.sirup:
        return 'Sirup';
      case SediaanObat.injeksi:
        return 'Injeksi';
      case SediaanObat.salep:
        return 'Salep';
    }
  }
}
