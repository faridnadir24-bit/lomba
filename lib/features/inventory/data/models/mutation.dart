import 'package:obatku/core/constants/enums.dart';

class Mutation {
  final String id;
  final String medicineId;
  final String type;
  final int quantity;
  final String? reference;
  final String? performedBy;
  final String? notes;
  final bool isSynced;
  final DateTime createdAt;

  const Mutation({
    required this.id,
    required this.medicineId,
    required this.type,
    required this.quantity,
    this.reference,
    this.performedBy,
    this.notes,
    required this.isSynced,
    required this.createdAt,
  });

  factory Mutation.fromMap(Map<String, dynamic> map) {
    return Mutation(
      id: map['id'] as String,
      medicineId: map['medicine_id'] as String,
      type: map['type'] as String,
      quantity: map['quantity'] as int,
      reference: map['reference'] as String?,
      performedBy: map['performed_by'] as String?,
      notes: map['notes'] as String?,
      isSynced: (map['synced'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicine_id': medicineId,
      'type': type,
      'quantity': quantity,
      'reference': reference,
      'performed_by': performedBy,
      'notes': notes,
      'synced': isSynced ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineId': medicineId,
      'type': type,
      'quantity': quantity,
      'reference': reference,
      'performedBy': performedBy,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Mutation.fromJson(Map<String, dynamic> json) {
    return Mutation(
      id: json['id'] as String,
      medicineId: json['medicineId'] as String,
      type: json['type'] as String,
      quantity: json['quantity'] as int,
      reference: json['reference'] as String?,
      performedBy: json['performedBy'] as String?,
      notes: json['notes'] as String?,
      isSynced: true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Mutation copyWith({
    String? id,
    String? medicineId,
    String? type,
    int? quantity,
    String? reference,
    String? performedBy,
    String? notes,
    bool? isSynced,
    DateTime? createdAt,
  }) {
    return Mutation(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      reference: reference ?? this.reference,
      performedBy: performedBy ?? this.performedBy,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  TipeMutasi get tipeMutasi => TipeMutasi.values.firstWhere(
        (e) => e.name == type,
        orElse: () => TipeMutasi.masuk,
      );
}
