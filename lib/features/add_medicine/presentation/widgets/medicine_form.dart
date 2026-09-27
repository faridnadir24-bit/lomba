import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obatku/features/add_medicine/providers/add_medicine_provider.dart';
import 'package:obatku/features/add_medicine/presentation/widgets/quantity_stepper.dart';
import 'package:obatku/features/add_medicine/presentation/widgets/dosage_form_selector.dart';
import 'package:obatku/features/add_medicine/presentation/widgets/storage_rack_selector.dart';

class MedicineForm extends ConsumerStatefulWidget {
  const MedicineForm({Key? key}) : super(key: key);

  @override
  ConsumerState<MedicineForm> createState() => _MedicineFormState();
}

class _MedicineFormState extends ConsumerState<MedicineForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final namesAsync = ref.watch(existingMedicineNamesProvider);
    final formState = ref.watch(addMedicineFormProvider);
    final formNotifier = ref.read(addMedicineFormProvider.notifier);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Nama Obat'),
          namesAsync.when(
            data: (names) => Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return names.where((String option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                formNotifier.setField(name: selection);
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Masukkan atau pilih nama obat',
                  ),
                  onChanged: (val) => formNotifier.setField(name: val),
                );
              },
            ),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('Gagal memuat nama obat'),
          ),
          const SizedBox(height: 16),
          
          _buildLabel('Dosis (contoh: 500mg)'),
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Misal: 500mg',
            ),
            onChanged: (val) => formNotifier.setField(dosage: val),
          ),
          const SizedBox(height: 16),
          
          _buildLabel('Bentuk Sediaan'),
          const DosageFormSelector(),
          const SizedBox(height: 16),
          
          _buildLabel('Jumlah Stok'),
          const QuantityStepper(),
          const SizedBox(height: 16),
          
          _buildLabel('Satuan'),
          Wrap(
            spacing: 8.0,
            children: SatuanObat.values.map((unit) {
              final isSelected = formState.unit == unit;
              return ChoiceChip(
                label: Text(unit.name.toUpperCase()),
                selected: isSelected,
                selectedColor: const Color(0xFF1B4332),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF1B4332),
                  fontWeight: FontWeight.bold,
                ),
                onSelected: (selected) {
                  if (selected) formNotifier.setField(unit: unit);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          
          _buildLabel('Tgl Kedaluwarsa (ED)'),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 10),
              );
              if (date != null) {
                formNotifier.setField(expiryDate: date);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formState.expiryDate != null
                        ? '${formState.expiryDate!.month}/${formState.expiryDate!.year}'
                        : 'Pilih Bulan-Tahun',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          if (formState.expiryDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Sisa: ${formState.expiryDate!.difference(DateTime.now()).inDays} hari',
                style: const TextStyle(color: Color(0xFF27AE60), fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(height: 16),
          
          _buildLabel('Nomor Bets'),
          TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Masukkan Nomor Bets',
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () {
                  // Scan barcode logic
                },
              ),
            ),
            onChanged: (val) => formNotifier.setField(batchNumber: val),
          ),
          const SizedBox(height: 16),
          
          _buildLabel('Rak Penyimpanan'),
          const StorageRackSelector(),
          const SizedBox(height: 16),
          
          _buildLabel('Catatan'),
          TextFormField(
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Tambahkan catatan opsional',
            ),
            onChanged: (val) => formNotifier.setField(notes: val),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }
}
