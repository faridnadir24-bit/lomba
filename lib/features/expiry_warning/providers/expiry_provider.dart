import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obatku/features/dashboard/providers/dashboard_provider.dart';
import 'package:obatku/core/models/medicine.dart';

/// Provider untuk obat dengan status Kritis (Kedaluwarsa <= 7 hari)
final criticalMedicinesProvider = FutureProvider<List<Medicine>>((ref) async {
  final repository = ref.watch(medicineRepositoryProvider);
  // Mengambil obat yang kedaluwarsa dalam 7 hari
  return await repository.getExpiringMedicines(7);
});

/// Provider untuk obat dengan status Waspada (Kedaluwarsa > 7 hari dan <= 30 hari)
final warningMedicinesProvider = FutureProvider<List<Medicine>>((ref) async {
  final repository = ref.watch(medicineRepositoryProvider);
  final allExpiring = await repository.getExpiringMedicines(30);
  final now = DateTime.now();
  
  return allExpiring.where((m) {
    final days = m.expiryDate.difference(now).inDays;
    return days > 7 && days <= 30;
  }).toList();
});

/// Provider untuk obat dengan status Perhatian (Kedaluwarsa > 30 hari dan <= 90 hari)
final attentionMedicinesProvider = FutureProvider<List<Medicine>>((ref) async {
  final repository = ref.watch(medicineRepositoryProvider);
  final allExpiring = await repository.getExpiringMedicines(90);
  final now = DateTime.now();
  
  return allExpiring.where((m) {
    final days = m.expiryDate.difference(now).inDays;
    return days > 30 && days <= 90;
  }).toList();
});
