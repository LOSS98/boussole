import 'package:boussole/domain/calculations/drawdown.dart';
import 'package:boussole/domain/calculations/loss_probability.dart';
import 'package:boussole/domain/calculations/performance.dart';
import 'package:boussole/domain/calculations/series_utils.dart';
import 'package:boussole/domain/calculations/volatility.dart';
import 'package:boussole/domain/models/price_point.dart';
import 'package:flutter_test/flutter_test.dart';

List<PricePoint> weekly(List<double> closes, {DateTime? start}) {
  final s = start ?? DateTime(2020, 1, 6);
  return [
    for (var i = 0; i < closes.length; i++)
      PricePoint(DateTime(s.year, s.month, s.day + 7 * i), closes[i]),
  ];
}

void main() {
  group('performancePercent', () {
    test('computes gain and loss', () {
      expect(performancePercent(100, 120), closeTo(20, 1e-9));
      expect(performancePercent(100, 80), closeTo(-20, 1e-9));
    });
    test('returns null for a zero or negative base', () {
      expect(performancePercent(0, 10), isNull);
      expect(performancePercent(-5, 10), isNull);
    });
  });

  group('maxDrawdown', () {
    test('matches the statement example (-28 %)', () {
      final r = maxDrawdown([100, 110, 125, 115, 90, 105])!;
      expect(r.depth, closeTo(-0.28, 1e-9));
      expect(r.peakIndex, 2);
      expect(r.troughIndex, 4);
      expect(r.recoveryIndex, isNull);
    });
    test('measures the recovery time', () {
      final r = maxDrawdown([100, 80, 90, 100, 110])!;
      expect(r.depth, closeTo(-0.2, 1e-9));
      expect(r.recoveryPeriods, 3);
    });
    test('is zero for a rising series', () {
      expect(maxDrawdown([1, 2, 3])!.depth, 0);
    });
    test('handles empty and single-point histories', () {
      expect(maxDrawdown([]), isNull);
      expect(maxDrawdown([5]), isNull);
    });
    test('ignores zero prices without dividing by zero', () {
      expect(maxDrawdown([0, 0, 0])!.depth, 0);
    });
  });

  group('annualizedVolatility', () {
    test('is zero for a constant return series', () {
      final pts = weekly([100, 110, 121, 133.1]);
      expect(annualizedVolatility(pts), closeTo(0, 1e-6));
    });
    test('grows with the amplitude of the moves', () {
      final calm = annualizedVolatility(weekly([100, 101, 100, 101, 100]))!;
      final wild = annualizedVolatility(weekly([100, 130, 90, 140, 80]))!;
      expect(wild, greaterThan(calm));
    });
    test('returns null with too little data', () {
      expect(annualizedVolatility([]), isNull);
      expect(annualizedVolatility(weekly([100])), isNull);
      expect(annualizedVolatility(weekly([100, 110])), isNull);
    });
    test('skips returns after a zero price', () {
      expect(periodicReturns([0, 10, 20]), [1.0]);
    });
  });

  group('lossProbability', () {
    test('always rising: never loses', () {
      final pts = weekly(List.generate(120, (i) => 100.0 + i));
      final r = lossProbability(pts, 1)!;
      expect(r.probability, 0);
      expect(r.windows, greaterThan(0));
    });
    test('always falling: always loses', () {
      final pts = weekly(List.generate(120, (i) => 500.0 - i));
      expect(lossProbability(pts, 1)!.probability, 1);
    });
    test('counts the share of losing windows', () {
      // monthly points: 100, 90, 110, 100 -> 1-month windows: down, up, down
      final pts = [
        PricePoint(DateTime(2020, 1, 1), 100),
        PricePoint(DateTime(2020, 2, 1), 90),
        PricePoint(DateTime(2020, 3, 1), 110),
        PricePoint(DateTime(2020, 4, 1), 100),
      ];
      final r = lossProbability(pts, 1)!;
      expect(r.windows, 3);
      expect(r.probability, closeTo(2 / 3, 1e-9));
    });
    test('returns null when the horizon is longer than the history', () {
      final pts = weekly(List.generate(10, (i) => 100.0 + i));
      expect(lossProbability(pts, 12), isNull);
    });
    test('handles empty history and invalid duration', () {
      expect(lossProbability([], 3), isNull);
      expect(lossProbability(weekly([1, 2, 3]), 0), isNull);
    });
    test('historyMonths', () {
      final pts = weekly(List.generate(53, (i) => 1.0));
      expect(historyMonths(pts), 11);
      expect(historyMonths([]), 0);
    });
  });

  group('series utils', () {
    test('resampleWeekly keeps the last point of each week', () {
      final daily = [
        for (var i = 0; i < 14; i++)
          PricePoint(DateTime(2024, 1, 1 + i), i.toDouble()),
      ];
      final w = resampleWeekly(daily);
      expect(w.length, 2);
      expect(w.first.close, 6);
      expect(w.last.close, 13);
    });
    test('rebase100', () {
      expect(rebase100([50, 100, 25]), [100, 200, 50]);
      expect(rebase100([]), isEmpty);
    });
    test('convertWithRates uses the latest known rate', () {
      final prices = [
        PricePoint(DateTime(2024, 1, 1), 100),
        PricePoint(DateTime(2024, 1, 10), 100),
      ];
      final rates = [
        PricePoint(DateTime(2024, 1, 2), 0.9),
        PricePoint(DateTime(2024, 1, 9), 0.8),
      ];
      final out = convertWithRates(prices, rates);
      expect(out[0].close, closeTo(90, 1e-9)); // before first rate -> first
      expect(out[1].close, closeTo(80, 1e-9));
      expect(convertWithRates(prices, []), prices);
    });
    test('lastMonths', () {
      final pts = weekly(List.generate(60, (i) => 1.0));
      final last = lastMonths(pts, 3);
      expect(last.length, lessThan(16));
      expect(lastMonths([], 3), isEmpty);
    });
  });
}
