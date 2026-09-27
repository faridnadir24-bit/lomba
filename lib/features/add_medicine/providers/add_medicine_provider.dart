import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SediaanObat { tablet, kapsul, sirup, injeksi, salep }
enum SatuanObat { tablet, strip, botol, ampul, vial, saset }
enum RakPenyimpanan { umum, triage, coldChain }

class AddMedicineFormState {
  final String name;
  final String dosage;
  final SediaanObat form;
  final int quantity;
  final SatuanObat unit;
  final DateTime? expiryDate;
  final String batchNumber;
  final RakPenyimpanan storageRack;
  final String notes;

  const AddMedicineFormState({
    this.name = '',
    this.dosage = '',
    this.form = SediaanObat.tablet,
    this.quantity = 0,
    this.unit = SatuanObat.tablet,
    this.expiryDate,
    this.batchNumber = '',
    this.storageRack = RakPenyimpanan.umum,
    this.notes = '',
  });

  AddMedicineFormState copyWith({
    String? name,
    String? dosage,
    SediaanObat? form,
    int? quantity,
    SatuanObat? unit,
    DateTime? expiryDate,
    String? batchNumber,
    RakPenyimpanan? storageRack,
    String? notes,
  }) {
    return AddMedicineFormState(
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      form: form ?? this.form,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      batchNumber: batchNumber ?? this.batchNumber,
      storageRack: storageRack ?? this.storageRack,
      notes: notes ?? this.notes,
    );
  }
}

class AddMedicineFormNotifier extends StateNotifier<AddMedicineFormState> {
  AddMedicineFormNotifier() : super(const AddMedicineFormState());

  void setField({
    String? name,
    String? dosage,
    SediaanObat? form,
    int? quantity,
    SatuanObat? unit,
    DateTime? expiryDate,
    String? batchNumber,
    RakPenyimpanan? storageRack,
    String? notes,
  }) {
    state = state.copyWith(
      name: name,
      dosage: dosage,
      form: form,
      quantity: quantity,
      unit: unit,
      expiryDate: expiryDate,
      batchNumber: batchNumber,
      storageRack: storageRack,
      notes: notes,
    );
  }

  void reset() {
    state = const AddMedicineFormState();
  }

  bool validate() {
    if (state.name.isEmpty || state.dosage.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> submit() async {
    if (!validate()) throw Exception("Validasi gagal");
    // Simulate API/DB insert
    await Future.delayed(const Duration(seconds: 1));
    reset();
  }
}

final addMedicineFormProvider = StateNotifierProvider<AddMedicineFormNotifier, AddMedicineFormState>((ref) {
  return AddMedicineFormNotifier();
});

final existingMedicineNamesProvider = FutureProvider<List<String>>((ref) async {
  return ['Paracetamol', 'Amoxicillin', 'Ibuprofen', 'Vitamin C', 'Antasida'];
});
