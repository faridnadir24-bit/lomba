import 'package:flutter/material.dart';
import 'package:obatku/features/prediction/providers/prediction_provider.dart';

class ModelReliabilityCard extends StatelessWidget {
  final PredictionData data;

  const ModelReliabilityCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD8F3DC), // Mint background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2D6A4F).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF1B4332)),
              const SizedBox(width: 8),
              Text(
                'Model Edge AI ${data.modelVersion}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B4332),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatBadge(Icons.check_circle_outline, 'Akurasi ${data.accuracy}%'),
              const SizedBox(width: 8),
              _buildStatBadge(Icons.storage, '${data.totalRecords} Riwayat'),
              const SizedBox(width: 8),
              _buildStatBadge(Icons.calendar_today, data.coverage),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Diproses secara lokal di perangkat',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF2D6A4F),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF2D6A4F)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D6A4F),
            ),
          ),
        ],
      ),
    );
  }
}
