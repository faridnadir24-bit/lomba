import 'package:flutter/material.dart';

class StatusBanner extends StatelessWidget {
  final bool isOnline;
  final int pendingCount;
  final VoidCallback? onSyncPressed;

  const StatusBanner({
    super.key,
    required this.isOnline,
    required this.pendingCount,
    this.onSyncPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: isOnline ? const Color(0xFFE8F8F0) : const Color(0xFFFEF5E7),
      child: Row(
        children: [
          Icon(
            isOnline ? Icons.check_circle : Icons.cloud_off,
            color: isOnline ? const Color(0xFF27AE60) : const Color(0xFFF39C12),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isOnline
                  ? 'Terhubung — Data tersinkronisasi'
                  : 'Offline — $pendingCount data tertunda',
              style: TextStyle(
                color: isOnline ? const Color(0xFF1B4332) : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (!isOnline && onSyncPressed != null)
            TextButton(
              onPressed: onSyncPressed,
              style: TextButton.styleFrom(
                minimumSize: const Size(48, 48),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                backgroundColor: const Color(0xFFF39C12).withOpacity(0.2),
              ),
              child: const Text(
                'Sinkronkan',
                style: TextStyle(
                  color: Color(0xFF1B4332),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
