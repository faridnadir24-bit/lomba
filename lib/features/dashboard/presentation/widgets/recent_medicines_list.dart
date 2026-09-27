import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obatku/features/inventory/data/models/medicine.dart';
import 'package:obatku/features/dashboard/providers/dashboard_provider.dart';
import 'package:obatku/core/widgets/medicine_list_tile.dart';

/// Daftar obat yang baru saja diperbarui
class RecentMedicinesList extends ConsumerWidget {
  final List<Medicine> medicines;

  const RecentMedicinesList({Key? key, required this.medicines}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (medicines.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Obat Terbaru',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B4332), // Deep Green
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: medicines.length,
          itemBuilder: (context, index) {
            final medicine = medicines[index];
            return MedicineListTile(
              medicine: medicine,
              onIncrement: () async {
                final repo = ref.read(medicineRepositoryProvider);
                // Asumsi implementasi updateQuantity ada di MedicineRepository
                // await repo.updateQuantity(medicine.id, medicine.quantity + 1);
                
                // Segarkan state metrik dan daftar terbaru
                ref.invalidate(dashboardMetricsProvider);
                ref.invalidate(recentMedicinesProvider);
              },
              onDecrement: () async {
                final repo = ref.read(medicineRepositoryProvider);
                if (medicine.quantity > 0) {
                  // await repo.updateQuantity(medicine.id, medicine.quantity - 1);
                  
                  ref.invalidate(dashboardMetricsProvider);
                  ref.invalidate(recentMedicinesProvider);
                }
              },
            );
          },
        ),
      ],
    );
  }
}
