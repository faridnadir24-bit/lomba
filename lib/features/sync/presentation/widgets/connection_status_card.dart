import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obatku/features/sync/providers/sync_provider.dart';

class ConnectionStatusCard extends ConsumerWidget {
  const ConnectionStatusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectionStatusProvider);
    final lastSyncTime = ref.watch(lastSyncTimeProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: isOnline ? const Color(0xFFD8F3DC) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOnline ? const Color(0xFF27AE60) : const Color(0xFFE74C3C),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isOnline ? Icons.cloud_done : Icons.cloud_off,
            size: 64,
            color: isOnline ? const Color(0xFF27AE60) : const Color(0xFFE74C3C),
          ),
          const SizedBox(height: 16),
          Text(
            isOnline ? 'Terhubung' : 'Offline',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isOnline ? const Color(0xFF1B4332) : const Color(0xFFC62828),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lastSyncTime != null
                ? 'Terakhir sinkronisasi: ${lastSyncTime.toLocal()}'
                : 'Belum pernah sinkronisasi',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isOnline ? const Color(0xFF2D6A4F) : const Color(0xFFD32F2F),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isOnline ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B4332),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey.shade400,
              ),
              child: const Text(
                'Sinkronkan Sekarang',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
