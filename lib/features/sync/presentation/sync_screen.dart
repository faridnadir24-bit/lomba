import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obatku/features/sync/presentation/widgets/connection_status_card.dart';
import 'package:obatku/features/sync/presentation/widgets/pending_queue_list.dart';
import 'package:obatku/features/sync/presentation/widgets/sync_channel_options.dart';

class SyncScreen extends ConsumerWidget {
  const SyncScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sinkronisasi Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              // Manual sync action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            ConnectionStatusCard(),
            SizedBox(height: 24),
            PendingQueueList(),
            SizedBox(height: 24),
            SyncChannelOptions(),
            SizedBox(height: 24),
            _SecurityBadge(),
          ],
        ),
      ),
    );
  }
}

class _SecurityBadge extends StatelessWidget {
  const _SecurityBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.lock, size: 20, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              'Enkripsi AES-256 — Standar Kemenkes RI',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
