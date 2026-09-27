import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obatku/core/models/medicine.dart';
import 'package:intl/intl.dart';

class DestructionReportDialog extends StatefulWidget {
  final Medicine medicine;

  const DestructionReportDialog({Key? key, required this.medicine}) : super(key: key);

  @override
  State<DestructionReportDialog> createState() => _DestructionReportDialogState();
}

class _DestructionReportDialogState extends State<DestructionReportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _witnessController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _witnessController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      HapticFeedback.mediumImpact();
      // TODO: Perform database mutation (type=musnah, qty=0)
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berita Acara Pemusnahan berhasil dibuat'),
          backgroundColor: Color(0xFF27AE60),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now());

    return AlertDialog(
      title: const Text('Berita Acara Pemusnahan'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tanggal: $today', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('Obat: ${widget.medicine.name}'),
              Text('Batch: ${widget.medicine.batchNumber}'),
              Text('Jumlah: ${widget.medicine.stock} ${widget.medicine.unit}'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Alasan Pemusnahan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _witnessController,
                decoration: const InputDecoration(
                  labelText: 'Nama Saksi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE74C3C),
            foregroundColor: Colors.white,
            minimumSize: const Size(120, 48),
          ),
          child: const Text('Buat Berita Acara'),
        ),
      ],
    );
  }
}
