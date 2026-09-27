import 'package:flutter/material.dart';
import 'package:obatku/features/dashboard/providers/dashboard_provider.dart';

/// Widget baris metrik kunci untuk menampilkan statistik obat
class KeyMetricsRow extends StatelessWidget {
  final DashboardMetrics metrics;

  const KeyMetricsRow({Key? key, required this.metrics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Penyesuaian tata letak untuk layar kecil vs besar
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return Column(
        children: _buildCards(context),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildCards(context)
            .map((card) => Expanded(child: card))
            .toList(),
      );
    }
  }

  List<Widget> _buildCards(BuildContext context) {
    return [
      _MetricCard(
        title: 'Total Obat Aktif',
        value: metrics.totalObat.toString(),
        icon: Icons.medication,
        color: const Color(0xFF27AE60), // Aman
        onTap: () {
          // Navigasi ke daftar inventaris
        },
      ),
      const SizedBox(height: 12, width: 12),
      _MetricCard(
        title: 'Mendekati Kedaluwarsa',
        value: metrics.mendekatiKedaluwarsa.toString(),
        icon: Icons.timer,
        color: const Color(0xFFF39C12), // Waspada
        onTap: () {
          // Navigasi ke daftar kedaluwarsa
        },
      ),
      const SizedBox(height: 12, width: 12),
      _MetricCard(
        title: 'Stok Menipis',
        value: metrics.stokMenipis.toString(),
        icon: Icons.trending_down,
        color: const Color(0xFFE74C3C), // Kritis
        onTap: () {
          // Navigasi ke peringatan stok menipis
        },
      ),
    ];
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B4332), // Deep Green
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
