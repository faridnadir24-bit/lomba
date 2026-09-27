import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obatku/features/sync/providers/sync_provider.dart';

class PendingQueueList extends ConsumerWidget {
  const PendingQueueList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingItemsAsync = ref.watch(pendingTransactionsProvider);
    final countAsync = ref.watch(pendingCountProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Antrean Transaksi Tertunda',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B4332),
              ),
            ),
            countAsync.when(
              data: (count) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: count > 0 ? const Color(0xFFF39C12) : const Color(0xFF27AE60),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              loading: () => const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        pendingItemsAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: const [
                      Icon(Icons.check_circle_outline, size: 48, color: Color(0xFF27AE60)),
                      SizedBox(height: 16),
                      Text(
                        'Tidak ada transaksi tertunda',
                        style: TextStyle(color: Color(0xFF2D6A4F), fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = items[index];
                return Dismissible(
                  key: ValueKey(item['id'] ?? index),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: const Color(0xFFE74C3C),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFD8F3DC),
                      child: Icon(
                        _getIconForOperation(item['operation'] as String?),
                        color: const Color(0xFF2D6A4F),
                      ),
                    ),
                    title: Text(
                      item['title'] as String? ?? 'Stok Masuk — Paracetamol 500mg',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item['subtitle'] as String? ?? 'Menunggu sinkronisasi'),
                    trailing: const Icon(Icons.cloud_upload, color: Color(0xFFF39C12)),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ],
    );
  }

  IconData _getIconForOperation(String? operation) {
    switch (operation) {
      case 'add':
        return Icons.add_circle;
      case 'update':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      default:
        return Icons.sync;
    }
  }
}
