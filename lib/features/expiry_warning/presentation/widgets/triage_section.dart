import 'package:flutter/material.dart';
import 'package:obatku/core/models/medicine.dart';

class TriageSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color headerColor;
  final Color headerTextColor;
  final List<Medicine> medicines;
  final List<Widget> Function(Medicine) actionBuilder;

  const TriageSection({
    Key? key,
    required this.title,
    required this.icon,
    required this.headerColor,
    required this.headerTextColor,
    required this.medicines,
    required this.actionBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          initiallyExpanded: true,
          backgroundColor: Colors.white,
          collapsedBackgroundColor: headerColor.withOpacity(0.1),
          title: Row(
            children: [
              Icon(icon, color: headerColor == Colors.white ? headerTextColor : headerColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: headerColor == Colors.white ? headerTextColor : headerColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${medicines.length}',
                  style: TextStyle(
                    color: headerTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          children: medicines.map((medicine) => _buildMedicineItem(medicine)).toList(),
        ),
      ),
    );
  }

  Widget _buildMedicineItem(Medicine medicine) {
    final days = medicine.expiryDate.difference(DateTime.now()).inDays;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  medicine.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: headerColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$days hari lagi!',
                  style: TextStyle(
                    color: headerColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Batch: ${medicine.batchNumber}'),
          Text('Stok: ${medicine.stock} ${medicine.unit}'),
          const SizedBox(height: 16),
          Row(
            children: actionBuilder(medicine),
          ),
          const Divider(height: 32),
        ],
      ),
    );
  }
}
