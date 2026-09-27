import 'package:obatku/core/constants/enums.dart';
import 'package:obatku/core/utils/date_utils.dart';

class Medicine {
  final String id;
  final String name;
  final String dosage;
  final String form;
  final String batchNumber;
  final int quantity;
  final String unit;
  final DateTime expiryDate;
  final int minStock;
  final String storageRack;
  final String? notes;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.form,
    required this.batchNumber,
    required this.quantity,
    required this.unit,
    required this.expiryDate,
    required this.minStock,
    required this.storageRack,
    this.notes,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'] as String,
      name: map['name'] as String,
      dosage: map['dosage'] as String,
      form: map['form'] as String,
      batchNumber: map['batch_number'] as String,
      quantity: map['quantity'] as int,
      unit: map['unit'] as String,
      expiryDate: DateTime.parse(map['expiry_date'] as String),
      minStock: map['min_stock'] as int,
      storageRack: map['storage_rack'] as String,
      notes: map['notes'] as String?,
      isSynced: (map['synced'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at'] as String) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'form': form,
      'batch_number': batchNumber,
      'quantity': quantity,
      'unit': unit,
      'expiry_date': expiryDate.toIso8601String(),
      'min_stock': minStock,
      'storage_rack': storageRack,
      'notes': notes,
      'synced': isSynced ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'form': form,
      'batchNumber': batchNumber,
      'quantity': quantity,
      'unit': unit,
      'expiryDate': expiryDate.toIso8601String(),
      'minStock': minStock,
      'storageRack': storageRack,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      form: json['form'] as String,
      batchNumber: json['batchNumber'] as String,
      quantity: json['quantity'] as int,
      unit: json['unit'] as String,
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      minStock: json['minStock'] as int,
      storageRack: json['storageRack'] as String,
      notes: json['notes'] as String?,
      isSynced: true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null,
    );
  }

  Medicine copyWith({
    String? id,
    String? name,
    String? dosage,
    String? form,
    String? batchNumber,
    int? quantity,
    String? unit,
    DateTime? expiryDate,
    int? minStock,
    String? storageRack,
    String? notes,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      form: form ?? this.form,
      batchNumber: batchNumber ?? this.batchNumber,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      minStock: minStock ?? this.minStock,
      storageRack: storageRack ?? this.storageRack,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  int get daysUntilExpiry => ObatkuDateUtils.daysBetween(DateTime.now(), expiryDate);

  StatusStok get status {
    StatusStok expiryStatus = StatusStok.aman;
    if (daysUntilExpiry <= 0) {
      expiryStatus = StatusStok.kritis;
    } else if (daysUntilExpiry <= 90) {
      expiryStatus = StatusStok.waspada;
    }

    StatusStok stockStatus = StatusStok.aman;
    if (quantity == 0) {
      stockStatus = StatusStok.kritis;
    } else if (quantity <= minStock) {
      stockStatus = StatusStok.waspada;
    }

    if (expiryStatus == StatusStok.kritis || stockStatus == StatusStok.kritis) {
      return StatusStok.kritis;
    }
    if (expiryStatus == StatusStok.waspada || stockStatus == StatusStok.waspada) {
      return StatusStok.waspada;
    }
    return StatusStok.aman;
  }

  bool get isExpired => daysUntilExpiry <= 0;

  bool get isLowStock => quantity <= minStock;

  SediaanObat get sediaan => SediaanObat.values.firstWhere(
        (e) => e.name == form,
        orElse: () => SediaanObat.tablet,
      );

  SatuanObat get satuan => SatuanObat.values.firstWhere(
        (e) => e.name == unit,
        orElse: () => SatuanObat.tablet,
      );

  RakPenyimpanan get rak => RakPenyimpanan.values.firstWhere(
        (e) => e.name == storageRack,
        orElse: () => RakPenyimpanan.umum,
      );
}
