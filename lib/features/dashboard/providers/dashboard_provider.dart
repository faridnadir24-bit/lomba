import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obatku/features/inventory/data/repositories/medicine_repository.dart';
import 'package:obatku/features/inventory/data/models/medicine.dart';
import 'package:obatku/core/database/database_helper.dart';
import 'package:obatku/core/utils/sync_queue.dart';
import 'package:obatku/core/constants/app_constants.dart';

/// Kelas metrik untuk menyimpan ringkasan data di beranda
class DashboardMetrics {
  final int totalObat;
  final int mendekatiKedaluwarsa;
  final int stokMenipis;

  const DashboardMetrics({
    required this.totalObat,
    required this.mendekatiKedaluwarsa,
    required this.stokMenipis,
  });
}

/// Provider untuk DatabaseHelper
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  // Diasumsikan DatabaseHelper memiliki singleton getter instance
  return DatabaseHelper.instance;
});

/// Provider untuk MedicineRepository
final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  final dbHelper = ref.read(databaseHelperProvider);
  return MedicineRepository(dbHelper);
});

/// Provider untuk SyncQueueManager
final syncQueueManagerProvider = Provider<SyncQueueManager>((ref) {
  final dbHelper = ref.read(databaseHelperProvider);
  return SyncQueueManager(dbHelper);
});

/// Provider untuk mengambil metrik utama di dashboard
final dashboardMetricsProvider = FutureProvider<DashboardMetrics>((ref) async {
  final repository = ref.read(medicineRepositoryProvider);
  final allMedicines = await repository.getAllMedicines();
  
  int totalObat = allMedicines.length;
  int mendekatiKedaluwarsa = 0;
  int stokMenipis = 0;
  
  final now = DateTime.now();
  
  for (var med in allMedicines) {
    if (med.quantity <= med.minimumStock) {
      stokMenipis++;
    }
    // Asumsikan 90 hari (3 bulan) sebagai mendekati kedaluwarsa
    if (med.expiryDate.isAfter(now) && med.expiryDate.difference(now).inDays <= 90) {
      mendekatiKedaluwarsa++;
    }
  }
  
  return DashboardMetrics(
    totalObat: totalObat,
    mendekatiKedaluwarsa: mendekatiKedaluwarsa,
    stokMenipis: stokMenipis,
  );
});

/// Provider untuk mengambil 5 obat terakhir yang diperbarui
final recentMedicinesProvider = FutureProvider<List<Medicine>>((ref) async {
  final repository = ref.read(medicineRepositoryProvider);
  final allMedicines = await repository.getAllMedicines();
  
  // Mengambil 5 obat terakhir, dibalik urutannya untuk menyimulasikan data terbaru
  return allMedicines.reversed.take(5).toList();
});

/// Provider untuk mengetahui jumlah antrean sinkronisasi
final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  final syncQueue = ref.read(syncQueueManagerProvider);
  final items = await syncQueue.getPendingItems();
  return items.length;
});
