import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obatku/features/add_medicine/providers/add_medicine_provider.dart';

class StorageRackSelector extends ConsumerWidget {
  const StorageRackSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(addMedicineFormProvider);
    final formNotifier = ref.read(addMedicineFormProvider.notifier);

    return Column(
      children: RakPenyimpanan.values.map((rack) {
        final isSelected = formState.storageRack == rack;
        
        return GestureDetector(
          onTap: () => formNotifier.setField(storageRack: rack),
          child: Container(
            height: 72,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFD8F3DC) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFF1B4332) : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  _getIconForRack(rack),
                  size: 32,
                  color: const Color(0xFF1B4332),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getTitleForRack(rack),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        _getSubtitleForRack(rack),
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.check_circle, color: Color(0xFF1B4332)),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconForRack(RakPenyimpanan rack) {
    switch (rack) {
      case RakPenyimpanan.umum:
        return Icons.shelves;
      case RakPenyimpanan.triage:
        return Icons.emergency;
      case RakPenyimpanan.coldChain:
        return Icons.ac_unit;
    }
  }

  String _getTitleForRack(RakPenyimpanan rack) {
    switch (rack) {
      case RakPenyimpanan.umum:
        return 'Rak Umum';
      case RakPenyimpanan.triage:
        return 'Triage/Darurat';
      case RakPenyimpanan.coldChain:
        return 'Cold Chain';
    }
  }

  String _getSubtitleForRack(RakPenyimpanan rack) {
    switch (rack) {
      case RakPenyimpanan.umum:
        return 'Penyimpanan obat rutin';
      case RakPenyimpanan.triage:
        return 'Obat kedaruratan 24 jam';
      case RakPenyimpanan.coldChain:
        return 'Vaksin & serum (2°-8°C)';
    }
  }
}
