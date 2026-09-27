import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock SyncQueueManager
class SyncQueueManager {
  Future<List<Map<String, dynamic>>> getPendingItems() async {
    return [];
  }
  
  Future<int> getPendingCount() async {
    return 0;
  }
}

final syncQueueManagerProvider = Provider<SyncQueueManager>((ref) {
  return SyncQueueManager();
});

final connectionStatusProvider = StateProvider<bool>((ref) => false);
final lastSyncTimeProvider = StateProvider<DateTime?>((ref) => null);

final pendingTransactionsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final manager = ref.watch(syncQueueManagerProvider);
  return manager.getPendingItems();
});

final pendingCountProvider = FutureProvider<int>((ref) async {
  final manager = ref.watch(syncQueueManagerProvider);
  return manager.getPendingCount();
});
