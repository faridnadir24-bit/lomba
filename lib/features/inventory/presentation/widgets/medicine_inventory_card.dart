import 'package:flutter/material.dart';
import 'package:obatku/core/constants/medicine_constants.dart';
import 'package:obatku/features/inventory/data/models/medicine.dart';
import 'package:intl/intl.dart';

class MedicineInventoryCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const MedicineInventoryCard({
    super.key,
    required this.medicine,
    required this.onTap,
    required this.onIncrement,
    required this.onDecrement,
  });

  Color _getStatusColor(StatusStok status) {
    switch (status) {
      case StatusStok.aman:
        return const Color(0xFF27AE60); // Aman
      case StatusStok.waspada:
        return const Color(0xFFF39C12); // Waspada
      case StatusStok.kritis:
        return const Color(0xFFE74C3C); // Kritis
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(medicine.status);
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      medicine.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: BorderSide(color: statusColor),
                    ),
                    child: Text(
                      medicine.status.name.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Bets: ${medicine.batchNumber}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Sediaan: ${medicine.form}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Rak: ${medicine.location}',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${medicine.quantity}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        medicine.unit,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: onDecrement,
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 28,
                        color: const Color(0xFF1B4332), // Deep Green
                      ),
                      IconButton(
                        onPressed: onIncrement,
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 28,
                        color: const Color(0xFF1B4332),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'ED: ${dateFormat.format(medicine.expiryDate)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: medicine.expiryDate.isBefore(DateTime.now().add(const Duration(days: 90)))
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        medicine.isSynced ? Icons.cloud_done : Icons.cloud_off,
                        size: 14,
                        color: medicine.isSynced ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        medicine.isSynced ? 'Tersinkron' : 'Belum Sinkron',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
