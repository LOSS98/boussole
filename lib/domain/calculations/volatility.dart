import 'dart:math';

import '../models/price_point.dart';

/// Simple returns between consecutive prices. Pairs with a non-positive
/// previous price are skipped.
List<double> periodicReturns(List<double> prices) {
  final returns = <double>[];
  for (var i = 1; i < prices.length; i++) {
    if (prices[i - 1] > 0) returns.add(prices[i] / prices[i - 1] - 1);
  }
  return returns;
}

/// Number of observations per year, deduced from the dates of the series.
double periodsPerYear(List<PricePoint> points) {
  if (points.length < 2) return 0;
  final days = points.last.date.difference(points.first.date).inHours / 24;
  if (days <= 0) return 0;
  return (points.length - 1) * 365.25 / days;
}

/// Annualised volatility (in percent): sample standard deviation of the
/// periodic returns × sqrt(periods per year). Null if fewer than 2 returns.
double? annualizedVolatility(List<PricePoint> points) {
  final returns = periodicReturns([for (final p in points) p.close]);
  if (returns.length < 2) return null;
  final mean = returns.reduce((a, b) => a + b) / returns.length;
  final variance =
      returns.map((r) => pow(r - mean, 2)).reduce((a, b) => a + b) /
      (returns.length - 1);
  return sqrt(variance) * sqrt(periodsPerYear(points)) * 100;
}
