import 'package:flutter/material.dart';
import 'package:obatku/features/prediction/providers/prediction_provider.dart';

class RkoRecommendationCard extends StatelessWidget {
  final List<RkoRecommendation> recommendations;

  const RkoRecommendationCard({Key? key, required this.recommendations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalDeficit = 0;
    for (var rec in recommendations) {
      if (rec.deficit > 0) {
        totalDeficit += rec.deficit;
      }
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: const Text(
              'Rekomendasi RKO Otomatis',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              columns: const [
                DataColumn(label: Text('Nama Obat')),
                DataColumn(label: Text('Proyeksi Kebutuhan'), numeric: true),
                DataColumn(label: Text('Stok Riil'), numeric: true),
                DataColumn(label: Text('Selisih'), numeric: true),
              ],
              rows: recommendations.map((rec) {
                final isDeficit = rec.deficit > 0;
                return DataRow(
                  cells: [
                    DataCell(Text(rec.name)),
                    DataCell(Text(rec.projectedNeed.toString())),
                    DataCell(Text(rec.currentStock.toString())),
                    DataCell(
                      Text(
                        isDeficit ? '-${rec.deficit}' : '+${rec.deficit.abs()}',
                        style: TextStyle(
                          color: isDeficit ? const Color(0xFFE74C3C) : const Color(0xFF27AE60),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFF39C12).withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Kekurangan Stok (Items)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$totalDeficit',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE74C3C),
                    fontSize: 16,
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
