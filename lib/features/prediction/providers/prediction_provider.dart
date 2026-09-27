import 'package:flutter_riverpod/flutter_riverpod.dart';

class PredictionData {
  final String modelVersion;
  final int accuracy;
  final int totalRecords;
  final String coverage;

  const PredictionData({
    required this.modelVersion,
    required this.accuracy,
    required this.totalRecords,
    required this.coverage,
  });
}

class RkoRecommendation {
  final String name;
  final int projectedNeed;
  final int currentStock;
  final int deficit;

  const RkoRecommendation({
    required this.name,
    required this.projectedNeed,
    required this.currentStock,
    required this.deficit,
  });
}

class TrendDataPoint {
  final int monthIndex; // 0 for Jan, 1 for Feb, etc.
  final double value;

  const TrendDataPoint(this.monthIndex, this.value);
}

class MedicineTrend {
  final String name;
  final List<TrendDataPoint> data;

  const MedicineTrend(this.name, this.data);
}

final predictionDataProvider = Provider<PredictionData>((ref) {
  return const PredictionData(
    modelVersion: 'v2.4-Edge',
    accuracy: 92,
    totalRecords: 8420,
    coverage: '6 bulan ke depan',
  );
});

final trendDataProvider = Provider<List<MedicineTrend>>((ref) {
  return [
    const MedicineTrend('Paracetamol', [
      TrendDataPoint(0, 1200), // Jan
      TrendDataPoint(1, 1400), // Feb (Spike)
      TrendDataPoint(2, 900),  // Mar
      TrendDataPoint(3, 800),  // Apr
      TrendDataPoint(4, 750),  // May
      TrendDataPoint(5, 700),  // Jun
    ]),
    const MedicineTrend('Amoxicillin', [
      TrendDataPoint(0, 600),
      TrendDataPoint(1, 750), // Spike
      TrendDataPoint(2, 500),
      TrendDataPoint(3, 450),
      TrendDataPoint(4, 400),
      TrendDataPoint(5, 400),
    ]),
    const MedicineTrend('Oralit (ORS)', [
      TrendDataPoint(0, 300),
      TrendDataPoint(1, 400),
      TrendDataPoint(2, 350),
      TrendDataPoint(3, 300),
      TrendDataPoint(4, 250),
      TrendDataPoint(5, 200),
    ]),
  ];
});

final rkoRecommendationProvider = Provider<List<RkoRecommendation>>((ref) {
  return const [
    RkoRecommendation(
      name: 'Paracetamol 500mg',
      projectedNeed: 1500,
      currentStock: 480,
      deficit: 1020,
    ),
    RkoRecommendation(
      name: 'Amoxicillin 500mg',
      projectedNeed: 800,
      currentStock: 250,
      deficit: 550,
    ),
    RkoRecommendation(
      name: 'Oralit',
      projectedNeed: 500,
      currentStock: 100,
      deficit: 400,
    ),
    RkoRecommendation(
      name: 'Vitamin C',
      projectedNeed: 1200,
      currentStock: 1500,
      deficit: -300, // Surplus
    ),
  ];
});
