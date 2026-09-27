import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:obatku/core/database/database_helper.dart';

class SyncQueueManager {
  final DatabaseHelper _dbHelper;
  final Uuid _uuid = const Uuid();

  SyncQueueManager({DatabaseHelper? dbHelper}) 
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  /// Enqueue a mutation operation for sync
  Future<void> enqueue({
    required String tableName,
    required String recordId,
    required String operation,
    required Map<String, dynamic> payload,
    int priority = 0,
  }) async {
    final db = await _dbHelper.database;
    final queueId = _uuid.v4();
    final timestamp = DateTime.now().toIso8601String();
    
    await db.insert('sync_queue', {
      'id': queueId,
      'table_name': tableName,
      'record_id': recordId,
      'operation': operation,
      'payload': jsonEncode(payload),
      'priority': priority,
      'timestamp': timestamp,
      'status': 'pending',
    });
  }

  /// Retrieve pending items sorted by priority and timestamp
  Future<List<Map<String, dynamic>>> getPendingItems() async {
    final db = await _dbHelper.database;
    return await db.query(
      'sync_queue',
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'priority DESC, timestamp ASC',
    );
  }

  /// Retrieve pending count
  Future<int> getPendingCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sync_queue WHERE status = ?',
      ['pending'],
    );
    if (result.isNotEmpty) {
      return result.first['count'] as int? ?? 0;
    }
    return 0;
  }

  /// Mark an item as synced
  Future<void> markSynced(String queueId) async {
    final db = await _dbHelper.database;
    await db.update(
      'sync_queue',
      {'status': 'synced', 'synced_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [queueId],
    );
  }

  /// Delete an item from queue
  Future<void> removeItem(String queueId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'sync_queue',
      where: 'id = ?',
      whereArgs: [queueId],
    );
  }
}
