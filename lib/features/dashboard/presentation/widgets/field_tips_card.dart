import 'package:flutter/material.dart';

/// Kartu statis untuk memberikan tips logistik di lapangan
class FieldTipsCard extends StatelessWidget {
  const FieldTipsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD8F3DC), // Mint
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2D6A4F).withOpacity(0.3), // Forest Green
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2D6A4F).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: Color(0xFF2D6A4F), // Forest Green
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Tips Logistik Lapangan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B4332), // Deep Green
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Selalu terapkan prinsip FEFO (First Expired, First Out) saat mengeluarkan obat. Letakkan obat dengan masa kedaluwarsa terdekat di bagian paling depan rak penyimpanan.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
