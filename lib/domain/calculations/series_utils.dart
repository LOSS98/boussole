import '../models/price_point.dart';

/// Keeps one point per ISO week (the last one), used to derive weekly data
/// from daily data (crypto).
List<PricePoint> resampleWeekly(List<PricePoint> daily) {
  final result = <PricePoint>[];
  int? lastKey;
  for (final p in daily) {
    final monday = DateTime(
      p.date.year,
      p.date.month,
      p.date.day,
    ).subtract(Duration(days: p.date.weekday - 1));
    final key = monday.millisecondsSinceEpoch;
    if (key == lastKey) {
      result[result.length - 1] = p;
    } else {
      result.add(p);
      lastKey = key;
    }
  }
  return result;
}

/// Returns the points of the last [months] months of the series.
List<PricePoint> lastMonths(List<PricePoint> points, int months) {
  if (points.isEmpty) return points;
  final end = points.last.date;
  final from = DateTime(end.year, end.month - months, end.day);
  return points.where((p) => !p.date.isBefore(from)).toList();
}

/// Rebases a series to 100 at its first value.
List<double> rebase100(List<double> values) {
  if (values.isEmpty || values.first <= 0) return values;
  return [for (final v in values) v / values.first * 100];
}

/// Converts USD prices to EUR using dated EUR-per-USD [rates]
/// (sorted). Each price uses the latest rate on or before its date,
/// or the first rate if none is earlier. Empty [rates] returns [points].
List<PricePoint> convertWithRates(
  List<PricePoint> points,
  List<PricePoint> rates,
) {
  if (rates.isEmpty) return points;
  var j = 0;
  final out = <PricePoint>[];
  for (final p in points) {
    while (j + 1 < rates.length && !rates[j + 1].date.isAfter(p.date)) {
      j++;
    }
    out.add(PricePoint(p.date, p.close * rates[j].close));
  }
  return out;
}
