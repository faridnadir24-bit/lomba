import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:obatku/core/constants/medicine_constants.dart';
import 'package:obatku/features/dashboard/providers/dashboard_provider.dart';
import 'package:obatku/features/inventory/providers/inventory_provider.dart';
import 'package:go_router/go_router.dart';

class MedicineDetailScreen extends ConsumerWidget {
  final String medicineId;

  const MedicineDetailScreen({
    super.key,
    required this.medicineId,
  });

  Color _getStatusColor(StatusStok status) {
    switch (status) {
      case StatusStok.aman: return const Color(0xFF27AE60);
      case StatusStok.waspada: return const Color(0xFFF39C12);
      case StatusStok.kritis: return const Color(0xFFE74C3C);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineAsync = ref.watch(medicineDetailProvider(medicineId));
    final historyAsync = ref.watch(mutationHistoryProvider(medicineId));
    final repository = ref.watch(medicineRepositoryProvider);
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
    final timeFormat = DateFormat('HH:mm', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: medicineAsync.when(
          data: (medicine) => Text(medicine?.name ?? 'Detail Obat'),
          loading: () => const Text('Memuat...'),
          error: (_, __) => const Text('Error'),
        ),
        backgroundColor: const Color(0xFF1B4332), // Deep Green
        foregroundColor: Colors.white,
      ),
      body: medicineAsync.when(
        data: (medicine) {
          if (medicine == null) {
            return const Center(child: Text('Obat tidak ditemukan.'));
          }

          final statusColor = _getStatusColor(medicine.status);
          final daysToExpiry = medicine.expiryDate.difference(DateTime.now()).inDays;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'STATUS: ${medicine.status.name.toUpperCase()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Info Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Nama Obat', medicine.name, isBold: true),
                        const Divider(),
                        _buildInfoRow('Dosis', medicine.dosage),
                        const Divider(),
                        _buildInfoRow('Sediaan', medicine.form),
                        const Divider(),
                        _buildInfoRow('No. Bets', medicine.batchNumber),
                        const Divider(),
                        _buildInfoRow('Rak Penyimpanan', medicine.location),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Jumlah Stok', style: TextStyle(color: Colors.grey)),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    if (medicine.quantity > 0) {
                                      await repository.updateQuantity(medicine.id, -1, TipeMutasi.koreksi, 'Koreksi detail');
                                      ref.invalidate(medicineDetailProvider(medicineId));
                                      ref.invalidate(mutationHistoryProvider(medicineId));
                                    }
                                  },
                                  icon: const Icon(Icons.remove_circle),
                                  color: const Color(0xFF1B4332),
                                  iconSize: 32,
                                ),
                                Text(
                                  '${medicine.quantity}',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' ${medicine.unit}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await repository.updateQuantity(medicine.id, 1, TipeMutasi.koreksi, 'Koreksi detail');
                                    ref.invalidate(medicineDetailProvider(medicineId));
                                    ref.invalidate(mutationHistoryProvider(medicineId));
                                  },
                                  icon: const Icon(Icons.add_circle),
                                  color: const Color(0xFF1B4332),
                                  iconSize: 32,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tgl Kedaluwarsa', style: TextStyle(color: Colors.grey)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  dateFormat.format(medicine.expiryDate),
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  daysToExpiry < 0 
                                      ? 'Kedaluwarsa' 
                                      : 'Sisa $daysToExpiry hari',
                                  style: TextStyle(
                                    color: daysToExpiry < 90 ? Colors.red : Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (medicine.notes != null && medicine.notes!.isNotEmpty) ...[
                          const Divider(),
                          _buildInfoRow('Catatan', medicine.notes!),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sync Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      medicine.isSynced ? Icons.cloud_done : Icons.cloud_off,
                      color: medicine.isSynced ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      medicine.isSynced ? 'Data tersinkronisasi' : 'Data belum disinkronisasi ke server',
                      style: TextStyle(
                        color: medicine.isSynced ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Mutation History
                const Text(
                  'Riwayat Mutasi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                historyAsync.when(
                  data: (history) {
                    if (history.isEmpty) {
                      return const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: Text('Belum ada riwayat mutasi.')),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        // Assuming history item has date, type, quantity, note
                        final item = history[index];
                        final isPositive = item.quantity > 0;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isPositive ? Colors.green.shade100 : Colors.red.shade100,
                              child: Icon(
                                isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                                color: isPositive ? Colors.green : Colors.red,
                              ),
                            ),
                            title: Text(item.type.toString().split('.').last.toUpperCase()),
                            subtitle: Text('${dateFormat.format(item.date)} ${timeFormat.format(item.date)}\n${item.note}'),
                            trailing: Text(
                              '${isPositive ? '+' : ''}${item.quantity}',
                              style: TextStyle(
                                color: isPositive ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Gagal memuat riwayat mutasi.'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Terjadi kesalahan: $e')),
      ),
      bottomNavigationBar: medicineAsync.whenData((medicine) => medicine == null ? const SizedBox() : BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Edit medicine action
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur edit belum tersedia')));
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Hapus Data Obat?'),
                      content: const Text('Apakah Anda yakin ingin menghapus data obat ini? Tindakan ini tidak dapat dibatalkan.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context); // close dialog
                            await repository.deleteMedicine(medicine.id);
                            if (context.mounted) {
                              context.pop(); // go back
                            }
                          },
                          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                ),
                icon: const Icon(Icons.delete),
                label: const Text('Hapus'),
              ),
            ),
          ],
        ),
      )).value ?? const SizedBox(),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 16 : 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
