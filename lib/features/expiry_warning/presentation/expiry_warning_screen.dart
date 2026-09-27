import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obatku/core/models/medicine.dart';
import 'package:obatku/features/expiry_warning/providers/expiry_provider.dart';
import 'package:obatku/features/expiry_warning/presentation/widgets/triage_section.dart';
import 'package:obatku/features/expiry_warning/presentation/widgets/expiry_action_buttons.dart';

class ExpiryWarningScreen extends ConsumerWidget {
  const ExpiryWarningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final criticalAsync = ref.watch(criticalMedicinesProvider);
    final warningAsync = ref.watch(warningMedicinesProvider);
    final attentionAsync = ref.watch(attentionMedicinesProvider);

    final isLoading = criticalAsync.isLoading ||
        warningAsync.isLoading ||
        attentionAsync.isLoading;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final criticalList = criticalAsync.valueOrNull ?? [];
    final warningList = warningAsync.valueOrNull ?? [];
    final attentionList = attentionAsync.valueOrNull ?? [];

    final isEmpty =
        criticalList.isEmpty && warningList.isEmpty && attentionList.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peringatan Kedaluwarsa'),
        actions: [
          const Icon(Icons.warning_amber_rounded),
          const SizedBox(width: 16),
        ],
      ),
      body: isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSummaryCards(
                    criticalCount: criticalList.length,
                    warningCount: warningList.length,
                    attentionCount: attentionList.length,
                  ),
                  const SizedBox(height: 24),
                  if (criticalList.isNotEmpty)
                    TriageSection(
                      title: 'KRITIS — Segera Tindak Lanjut!',
                      icon: Icons.warning_rounded,
                      headerColor: const Color(0xFFE74C3C), // Kritis color
                      headerTextColor: Colors.white,
                      medicines: criticalList,
                      actionBuilder: (medicine) => [
                        CriticalActionButtons(medicine: medicine),
                      ],
                    ),
                  if (warningList.isNotEmpty)
                    TriageSection(
                      title: 'WASPADA — Rotasi Stok Segera',
                      icon: Icons.timer,
                      headerColor: const Color(0xFFF39C12), // Waspada color
                      headerTextColor: Colors.black87,
                      medicines: warningList,
                      actionBuilder: (medicine) => [
                        WarningActionButtons(medicine: medicine),
                      ],
                    ),
                  if (attentionList.isNotEmpty)
                    TriageSection(
                      title: 'PERHATIAN — Perencanaan Pengadaan',
                      icon: Icons.info_outline,
                      headerColor: Colors.blueGrey.shade100, // Perhatian color
                      headerTextColor: Colors.black87,
                      medicines: attentionList,
                      actionBuilder: (medicine) => [
                        AttentionActionButtons(medicine: medicine),
                      ],
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.check_circle_outline, size: 80, color: Color(0xFF27AE60)),
          SizedBox(height: 16),
          Text(
            'Tidak ada obat mendekati kedaluwarsa',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards({
    required int criticalCount,
    required int warningCount,
    required int attentionCount,
  }) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Kritis',
            count: criticalCount,
            color: const Color(0xFFE74C3C),
            textColor: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            title: 'Waspada',
            count: warningCount,
            color: const Color(0xFFF39C12),
            textColor: Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            title: 'Perhatian',
            count: attentionCount,
            color: Colors.blueGrey.shade100,
            textColor: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final Color textColor;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
