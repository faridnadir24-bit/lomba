import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obatku/core/constants/medicine_constants.dart';
import 'package:obatku/features/dashboard/providers/dashboard_provider.dart';
import 'package:obatku/features/inventory/providers/inventory_provider.dart';
import 'package:obatku/features/inventory/presentation/widgets/search_bar_with_scanner.dart';
import 'package:obatku/features/inventory/presentation/widgets/filter_chips_row.dart';
import 'package:obatku/features/inventory/presentation/widgets/medicine_inventory_card.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredMedicinesAsync = ref.watch(filteredMedicinesProvider);
    final countsAsync = ref.watch(medicineCategoryCountsProvider);
    final selectedFilter = ref.watch(inventoryStatusFilterProvider);
    final repository = ref.watch(medicineRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Obat'),
        backgroundColor: const Color(0xFF1B4332), // Deep Green
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SearchBarWithScanner(
              hintText: 'Cari nama obat, indikasi, atau no. bets...',
              onChanged: (query) {
                ref.read(inventorySearchQueryProvider.notifier).state = query;
              },
              onScanPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur pemindai barcode belum tersedia')),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          countsAsync.when(
            data: (counts) => FilterChipsRow(
              counts: counts,
              selectedFilter: selectedFilter,
              onFilterChanged: (filter) {
                ref.read(inventoryStatusFilterProvider.notifier).state = filter;
              },
            ),
            loading: () => const SizedBox(height: 48, child: Center(child: CircularProgressIndicator())),
            error: (_, __) => const SizedBox(height: 48),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredMedicinesAsync.when(
              data: (medicines) {
                if (medicines.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada obat ditemukan.'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(filteredMedicinesProvider);
                    ref.invalidate(medicineCategoryCountsProvider);
                  },
                  child: ListView.builder(
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      final medicine = medicines[index];
                      return MedicineInventoryCard(
                        medicine: medicine,
                        onTap: () {
                          context.push('/inventory/detail/${medicine.id}');
                        },
                        onIncrement: () async {
                          await repository.updateQuantity(medicine.id, 1, TipeMutasi.koreksi, 'Koreksi penambahan');
                          ref.invalidate(filteredMedicinesProvider);
                          ref.invalidate(medicineCategoryCountsProvider);
                        },
                        onDecrement: () async {
                          if (medicine.quantity > 0) {
                            await repository.updateQuantity(medicine.id, -1, TipeMutasi.koreksi, 'Koreksi pengurangan');
                            ref.invalidate(filteredMedicinesProvider);
                            ref.invalidate(medicineCategoryCountsProvider);
                          }
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('Terjadi kesalahan: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
