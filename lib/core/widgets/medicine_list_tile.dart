import 'package:flutter/material.dart';
import 'package:obatku/core/constants/medicine_constants.dart';
import 'package:obatku/core/theme/app_theme.dart';

class MedicineListTile extends StatelessWidget {
  final String name;
  final String batchNumber;
  final String dosage;
  final String form;
  final int quantity;
  final int daysUntilExpiry;
  final StatusStok status;
  final bool isSynced;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onTap;

  const MedicineListTile({
    super.key,
    required this.name,
    required this.batchNumber,
    required this.dosage,
    required this.form,
    required this.quantity,
    required this.daysUntilExpiry,
    required this.status,
    required this.isSynced,
    this.onIncrement,
    this.onDecrement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColors = Theme.of(context).extension<ObatkuStatusColors>();
    final Color color = _getColor(status, statusColors);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: const BoxConstraints(minHeight: 72),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 12),
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B4332),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Batch: $batchNumber • $dosage $form',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: daysUntilExpiry <= 30 ? const Color(0xFFFDEDEC) : const Color(0xFFF2F4F4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      daysUntilExpiry <= 30 ? '$daysUntilExpiry hari lagi!' : '$daysUntilExpiry hari lagi',
                      style: TextStyle(
                        fontSize: 12,
                        color: daysUntilExpiry <= 30 ? const Color(0xFFE74C3C) : Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onDecrement,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: const Color(0xFF2D6A4F),
                      iconSize: 24,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      padding: EdgeInsets.zero,
                    ),
                    Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onIncrement,
                      icon: const Icon(Icons.add_circle_outline),
                      color: const Color(0xFF2D6A4F),
                      iconSize: 24,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Icon(
                  isSynced ? Icons.cloud_done : Icons.schedule,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(StatusStok status, ObatkuStatusColors? colors) {
    switch (status) {
      case StatusStok.aman:
        return colors?.aman ?? const Color(0xFF27AE60);
      case StatusStok.waspada:
        return colors?.waspada ?? const Color(0xFFF39C12);
      case StatusStok.kritis:
        return colors?.kritis ?? const Color(0xFFE74C3C);
      default:
        return Colors.grey;
    }
  }
}
