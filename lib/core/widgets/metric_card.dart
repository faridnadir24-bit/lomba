import 'package:flutter/material.dart';
import 'package:obatku/core/constants/medicine_constants.dart';
import 'package:obatku/core/theme/app_theme.dart';

class MetricCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final StatusStok status;
  final VoidCallback? onTap;

  const MetricCard({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColors = Theme.of(context).extension<ObatkuStatusColors>();
    final Color color = _getColor(status, statusColors);
    final Color containerColor = _getContainerColor(status, statusColors);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.5),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: containerColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B4332),
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
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

  Color _getContainerColor(StatusStok status, ObatkuStatusColors? colors) {
    switch (status) {
      case StatusStok.aman:
        return colors?.amanContainer ?? const Color(0xFFD8F3DC);
      case StatusStok.waspada:
        return colors?.waspadaContainer ?? const Color(0xFFFEF5E7);
      case StatusStok.kritis:
        return colors?.kritisContainer ?? const Color(0xFFFDEDEC);
      default:
        return Colors.grey.shade200;
    }
  }
}
