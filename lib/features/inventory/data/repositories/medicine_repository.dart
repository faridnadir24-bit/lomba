import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:obatku/core/constants/enums.dart';
import 'package:obatku/core/database/database_helper.dart';
import 'package:obatku/features/inventory/data/models/medicine.dart';
import 'package:obatku/features/inventory/data/models/mutation.dart';

class MedicineRepository {
  final DatabaseHelper _dbHelper;
  final Uuid _uuid = const Uuid();

  MedicineRepository(this._dbHelper);

  Future<void> _enqueueSync(String tableName, String recordId, String operation, Map<String, dynamic> payload) async {
    await _dbHelper.insert('sync_queue', {
      'id': _uuid.v4(),
      'table_name': tableName,
      'record_id': recordId,
      'operation': operation,
      'payload': jsonEncode(payload),
      'priority': operation == 'DELETE' ? 2 : 1,
      'attempts': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Medicine>> getAllMedicines({StatusStok? statusFilter}) async {
    final List<Map<String, dynamic>> maps = await _dbHelper.queryAll(
      'medicines',
      where: 'deleted_at IS NULL',
      orderBy: 'name ASC',
    );
    
    List<Medicine> medicines = maps.map((map) => Medicine.fromMap(map)).toList();

    if (statusFilter != null) {
      medicines = medicines.where((m) => m.status == statusFilter).toList();
    }

    return medicines;
  }

  Future<List<Medicine>> searchMedicines(String query) async {
    final searchTerm = '%\$query%';
    final List<Map<String, dynamic>> maps = await _dbHelper.queryAll(
      'medicines',
      where: 'deleted_at IS NULL AND (name LIKE ? OR batch_number LIKE ? OR notes LIKE ?)',
      whereArgs: [searchTerm, searchTerm, searchTerm],
      orderBy: 'name ASC',
    );
    return maps.map((map) => Medicine.fromMap(map)).toList();
  }

  Future<Medicine?> getMedicineById(String id) async {
    final map = await _dbHelper.queryById('medicines', id);
    if (map != null && map['deleted_at'] == null) {
      return Medicine.fromMap(map);
    }
    return null;
  }

  Future<void> insertMedicine(Medicine medicine) async {
    final map = medicine.toMap();
    map['synced'] = 0;
    await _dbHelper.insert('medicines', map);
    await _enqueueSync('medicines', medicine.id, 'INSERT', medicine.toJson());
  }

  Future<void> updateMedicine(Medicine medicine) async {
    final updatedMedicine = medicine.copyWith(
      updatedAt: DateTime.now(),
      isSynced: false,
    );
    final map = updatedMedicine.toMap();
    await _dbHelper.update('medicines', map, medicine.id);
    await _enqueueSync('medicines', medicine.id, 'UPDATE', updatedMedicine.toJson());
  }

  Future<void> updateQuantity(
    String id,
    int delta, {
    required TipeMutasi type,
    String? reference,
    String? performedBy,
  }) async {
    final medicine = await getMedicineById(id);
    if (medicine == null) throw Exception('Medicine not found');

    final newQuantity = medicine.quantity + delta;
    if (newQuantity < 0) throw Exception('Insufficient stock');

    final updatedMedicine = medicine.copyWith(
      quantity: newQuantity,
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    await _dbHelper.update('medicines', updatedMedicine.toMap(), id);
    await _enqueueSync('medicines', id, 'UPDATE', updatedMedicine.toJson());

    final mutation = Mutation(
      id: _uuid.v4(),
      medicineId: id,
      type: type.name,
      quantity: delta,
      reference: reference,
      performedBy: performedBy,
      isSynced: false,
      createdAt: DateTime.now(),
    );

    await _dbHelper.insert('mutations', mutation.toMap());
    await _enqueueSync('mutations', mutation.id, 'INSERT', mutation.toJson());
  }

  Future<void> deleteMedicine(String id) async {
    final medicine = await getMedicineById(id);
    if (medicine == null) return;
    
    await _dbHelper.softDelete('medicines', id);
    
    final deletedJson = medicine.copyWith(deletedAt: DateTime.now()).toJson();
    await _enqueueSync('medicines', id, 'DELETE', deletedJson);
  }

  Future<List<Medicine>> getExpiringMedicines(int withinDays) async {
    final targetDate = DateTime.now().add(Duration(days: withinDays));
    final List<Map<String, dynamic>> maps = await _dbHelper.queryAll(
      'medicines',
      where: 'deleted_at IS NULL AND expiry_date <= ?',
      whereArgs: [targetDate.toIso8601String()],
      orderBy: 'expiry_date ASC',
    );
    return maps.map((map) => Medicine.fromMap(map)).toList();
  }

  Future<List<Medicine>> getLowStockMedicines() async {
    final List<Map<String, dynamic>> maps = await _dbHelper.queryAll(
      'medicines',
      where: 'deleted_at IS NULL AND quantity <= min_stock',
      orderBy: 'quantity ASC',
    );
    return maps.map((map) => Medicine.fromMap(map)).toList();
  }

  Future<int> getTotalCount() async {
    final result = await _dbHelper.rawQuery('SELECT COUNT(*) as count FROM medicines WHERE deleted_at IS NULL');
    return result.first['count'] as int;
  }

  Future<int> getExpiringCount(int withinDays) async {
    final targetDate = DateTime.now().add(Duration(days: withinDays));
    final result = await _dbHelper.rawQuery(
      'SELECT COUNT(*) as count FROM medicines WHERE deleted_at IS NULL AND expiry_date <= ?',
      [targetDate.toIso8601String()]
    );
    return result.first['count'] as int;
  }

  Future<int> getLowStockCount() async {
    final result = await _dbHelper.rawQuery('SELECT COUNT(*) as count FROM medicines WHERE deleted_at IS NULL AND quantity <= min_stock');
    return result.first['count'] as int;
  }

  Future<List<Mutation>> getMutationHistory(String medicineId, {int limit = 20}) async {
    final List<Map<String, dynamic>> maps = await _dbHelper.queryAll(
      'mutations',
      where: 'medicine_id = ?',
      whereArgs: [medicineId],
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return maps.map((map) => Mutation.fromMap(map)).toList();
  }

  Future<List<Medicine>> getRecentMedicines({int limit = 5}) async {
    final List<Map<String, dynamic>> maps = await _dbHelper.queryAll(
      'medicines',
      where: 'deleted_at IS NULL',
      orderBy: 'updated_at DESC',
      limit: limit,
    );
    return maps.map((map) => Medicine.fromMap(map)).toList();
  }
}
