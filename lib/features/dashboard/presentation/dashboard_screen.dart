import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obatku/features/dashboard/providers/dashboard_provider.dart';
import 'package:obatku/core/widgets/status_banner.dart';
import 'package:obatku/features/dashboard/presentation/widgets/key_metrics_row.dart';
import 'package:obatku/features/dashboard/presentation/widgets/recent_medicines_list.dart';
import 'package:obatku/features/dashboard/presentation/widgets/logistics_schedule_card.dart';
import 'package:obatku/features/dashboard/presentation/widgets/field_tips_card.dart';

/// Layar Beranda utama aplikasi OBATKU
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(dashboardMetricsProvider);
    final pendingSyncAsync = ref.watch(pendingSyncCountProvider);
    final recentMedicinesAsync = ref.watch(recentMedicinesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: const Color(0xFF1B4332), // Deep Green
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            pendingSyncAsync.when(
              data: (count) => StatusBanner(
                isOffline: true, // Offline-first sesuai requirement
                pendingCount: count,
              ),
              loading: () => const SizedBox.shrink(),
              error: (err, stack) => const SizedBox.shrink(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildFacilityHeader(),
                  const SizedBox(height: 24),
                  metricsAsync.when(
                    data: (metrics) => KeyMetricsRow(metrics: metrics),
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1B4332),
                      ),
                    ),
                    error: (err, stack) => Center(
                      child: Text('Terjadi kesalahan: $err'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const FieldTipsCard(),
                  const SizedBox(height: 24),
                  recentMedicinesAsync.when(
                    data: (medicines) => RecentMedicinesList(medicines: medicines),
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1B4332),
                      ),
                    ),
                    error: (err, stack) => Center(
                      child: Text('Terjadi kesalahan: $err'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const LogisticsScheduleCard(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun header identitas fasilitas (Puskesmas Pembantu)
  Widget _buildFacilityHeader() {
    final now = DateTime.now();
    // Format tanggal sederhana Indonesia
    final dateString = '${now.day}-${now.month}-${now.year}';
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Puskesmas Pembantu Sei Berembang',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B4332), // Deep Green
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF27AE60).withOpacity(0.15), // Aman background
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    '3T',
                    style: TextStyle(
                      color: Color(0xFF27AE60), // Aman
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              dateString,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
