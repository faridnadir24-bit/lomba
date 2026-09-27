import 'package:flutter/material.dart';
import 'package:obatku/core/models/medicine.dart';
import 'package:obatku/features/expiry_warning/presentation/widgets/destruction_report_dialog.dart';

class CriticalActionButtons extends StatelessWidget {
  final Medicine medicine;

  const CriticalActionButtons({Key? key, required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => DestructionReportDialog(medicine: medicine),
                );
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Musnahkan'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE74C3C),
                side: const BorderSide(color: Color(0xFFE74C3C)),
                minimumSize: const Size(0, 48),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur surat pesanan darurat')),
                );
              },
              icon: const Icon(Icons.document_scanner),
              label: const Text('Pesan Darurat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF39C12),
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WarningActionButtons extends StatelessWidget {
  final Medicine medicine;

  const WarningActionButtons({Key? key, required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () {
          // Rotasi Stok
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rotasi Stok ke Poli')),
          );
        },
        icon: const Icon(Icons.swap_horiz),
        label: const Text('Rotasi ke Poli'),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFF39C12),
          side: const BorderSide(color: Color(0xFFF39C12)),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }
}

class AttentionActionButtons extends StatelessWidget {
  final Medicine medicine;

  const AttentionActionButtons({Key? key, required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () {
          // Perencanaan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tambahkan ke RKO Perencanaan')),
          );
        },
        icon: const Icon(Icons.edit_document),
        label: const Text('Rencanakan RKO'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blueGrey,
          side: const BorderSide(color: Colors.blueGrey),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }
}
