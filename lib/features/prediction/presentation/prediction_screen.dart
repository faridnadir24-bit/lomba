import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obatku/features/prediction/providers/prediction_provider.dart';
import 'package:obatku/features/prediction/presentation/widgets/model_reliability_card.dart';
import 'package:obatku/features/prediction/presentation/widgets/trend_chart.dart';
import 'package:obatku/features/prediction/presentation/widgets/rko_recommendation_card.dart';

class PredictionScreen extends ConsumerWidget {
  const PredictionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final predictionData = ref.watch(predictionDataProvider);
    final trendData = ref.watch(trendDataProvider);
    final rkoRecommendations = ref.watch(rkoRecommendationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediksi Kebutuhan Obat'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ModelReliabilityCard(data: predictionData),
            const SizedBox(height: 24),
            const Text(
              'Tren Kebutuhan Kumulatif',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TrendChart(trends: trendData),
            ),
            const SizedBox(height: 8),
            const Text(
              '* Lonjakan diprediksi pada Januari-Februari akibat musim hujan (ISPA & Demam Berdarah).',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 24),
            RkoRecommendationCard(recommendations: rkoRecommendations),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mengekspor data ke CSV...')),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Cetak / Ekspor RKO'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B4332), // Deep Green
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
        ),
      ),
    );
  }
}
