import 'package:flutter/material.dart';
import 'package:obatku/core/constants/medicine_constants.dart';

class StatusBadge extends StatelessWidget {
  final StatusStok status;
  final String? customLabel;

  const StatusBadge({
    super.key,
    required this.status,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String labelText = customLabel ?? status.displayName;

    switch (status) {
      case StatusStok.aman:
        backgroundColor = const Color(0xFF27AE60);
        textColor = Colors.white;
        break;
      case StatusStok.waspada:
        backgroundColor = const Color(0xFFF39C12);
        textColor = const Color(0xFF1B4332);
        break;
      case StatusStok.kritis:
        backgroundColor = const Color(0xFFE74C3C);
        textColor = Colors.white;
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        labelText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
