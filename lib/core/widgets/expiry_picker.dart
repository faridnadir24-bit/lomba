import 'package:flutter/material.dart';
import 'package:obatku/core/utils/obatku_date_utils.dart';

Future<DateTime?> showExpiryPicker(BuildContext context, {DateTime? initialDate}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return _ExpiryPickerSheet(initialDate: initialDate ?? DateTime.now());
    },
  );
}

class _ExpiryPickerSheet extends StatefulWidget {
  final DateTime initialDate;

  const _ExpiryPickerSheet({required this.initialDate});

  @override
  State<_ExpiryPickerSheet> createState() => _ExpiryPickerSheetState();
}

class _ExpiryPickerSheetState extends State<_ExpiryPickerSheet> {
  late int selectedYear;
  late int selectedMonth;

  final List<String> months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialDate.year;
    selectedMonth = widget.initialDate.month;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16, top: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Pilih Bulan & Tahun Kedaluwarsa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B4332),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedYear--;
                  });
                },
                icon: const Icon(Icons.chevron_left),
                iconSize: 32,
                color: const Color(0xFF1B4332),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              ),
              Text(
                selectedYear.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B4332),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedYear++;
                  });
                },
                icon: const Icon(Icons.chevron_right),
                iconSize: 32,
                color: const Color(0xFF1B4332),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: 52,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final monthNum = index + 1;
              final isSelected = monthNum == selectedMonth;
              
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedMonth = monthNum;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1B4332) : const Color(0xFFD8F3DC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF1B4332) : const Color(0xFF2D6A4F),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    months[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF1B4332),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // In case ObatkuDateUtils.getLastDayOfMonth is unavailable, fallback:
                // final lastDay = DateTime(selectedYear, selectedMonth + 1, 0);
                final lastDay = ObatkuDateUtils.getLastDayOfMonth(selectedYear, selectedMonth);
                Navigator.of(context).pop(lastDay);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D6A4F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Simpan Tanggal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
