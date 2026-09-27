import 'package:flutter/material.dart';

/// Kartu statis untuk menampilkan jadwal distribusi logistik logistik laut
class LogisticsScheduleCard extends StatelessWidget {
  const LogisticsScheduleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Estimasi tanggal 2 minggu dari waktu sekarang
    final arrivalDate = DateTime.now().add(const Duration(days: 14));
    final dateString = '${arrivalDate.day}-${arrivalDate.month}-${arrivalDate.year}';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Color(0xFF2D6A4F)), // Forest Green
                const SizedBox(width: 8),
                const Text(
                  'Jadwal Distribusi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B4332), // Deep Green
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.directions_boat, color: Colors.blueGrey, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pusat Distribusi Siberut',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Kapal: KM Mentawai Fast',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Estimasi Tiba: $dateString',
                        style: const TextStyle(
                          fontSize: 14, 
                          color: Color(0xFFE74C3C), // Kritis color for attention
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD8F3DC), // Mint
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.radio, color: Color(0xFF1B4332), size: 24), // Deep Green
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Koordinasi melalui Radio VHF Channel 16 saat kapal mendekat.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1B4332),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
