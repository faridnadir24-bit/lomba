import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obatku/core/constants/medicine_constants.dart';
import 'package:obatku/features/dashboard/providers/dashboard_provider.dart';
import 'package:obatku/features/inventory/data/models/medicine.dart';

/// Provider untuk pencarian nama obat
final inventorySearchQueryProvider = StateProvider<String>((ref) => '');

/// Provider untuk filter status stok (null berarti Semua)
final inventoryStatusFilterProvider = StateProvider<StatusStok?>((ref) => null);

/// Provider untuk daftar obat yang telah difilter
final filteredMedicinesProvider = FutureProvider<List<Medicine>>((ref) async {
  final query = ref.watch(inventorySearchQueryProvider);
  final filter = ref.watch(inventoryStatusFilterProvider);
  final repository = ref.watch(medicineRepositoryProvider);

  if (query.isNotEmpty) {
    return repository.searchMedicines(query);
  } else if (filter != null) {
    return repository.getAllMedicines(statusFilter: filter);
  } else {
    return repository.getAllMedicines();
  }
});

/// Provider untuk jumlah obat berdasarkan kategori
final medicineCategoryCountsProvider = FutureProvider<Map<StatusStok?, int>>((ref) async {
  final repository = ref.watch(medicineRepositoryProvider);
  final allMedicines = await repository.getAllMedicines();
  
  final Map<StatusStok?, int> counts = {
    null: allMedicines.length,
    StatusStok.aman: allMedicines.where((m) => m.status == StatusStok.aman).length,
    StatusStok.waspada: allMedicines.where((m) => m.status == StatusStok.waspada).length,
    StatusStok.kritis: allMedicines.where((m) => m.status == StatusStok.kritis).length,
  };
  
  return counts;
});

/// Provider untuk detail obat berdasarkan ID
final medicineDetailProvider = FutureProvider.family<Medicine?, String>((ref, id) async {
  final repository = ref.watch(medicineRepositoryProvider);
  return repository.getMedicineById(id);
});

/// Provider untuk riwayat mutasi berdasarkan ID obat
final mutationHistoryProvider = FutureProvider.family<List<dynamic>, String>((ref, id) async {
  final repository = ref.watch(medicineRepositoryProvider);
  return repository.getMutationHistory(id);
});
