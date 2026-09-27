import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:obatku/core/database/tables.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Note: For MVP, using standard sqflite.
    // TODO: Upgrade to sqlcipher for encryption in future versions.
    String path = join(await getDatabasesPath(), 'obatku.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(Tables.createMedicinesTable);
    await db.execute(Tables.createMutationsTable);
    await db.execute(Tables.createSyncQueueTable);
    await db.execute(Tables.createFacilityTable);

    for (String index in Tables.createIndexes) {
      await db.execute(index);
    }
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    Database db = await database;
    return await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAll(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    Database db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<Map<String, dynamic>?> queryById(String table, String id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<int> update(String table, Map<String, dynamic> data, String id) async {
    Database db = await database;
    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> softDelete(String table, String id) async {
    Database db = await database;
    return await db.update(
      table,
      {'deleted_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> rawUpdate(String sql, List<dynamic> args) async {
    Database db = await database;
    return await db.rawUpdate(sql, args);
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? args]) async {
    Database db = await database;
    return await db.rawQuery(sql, args);
  }
}
