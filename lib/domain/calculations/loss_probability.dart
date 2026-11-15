import 'package:equatable/equatable.dart';

import '../models/price_point.dart';

class LossProbability extends Equatable {
  const LossProbability({required this.probability, required this.windows});

  /// Share of windows ending below their starting price, in [0, 1].
  final double probability;

  /// Number of rolling windows analysed.
  final int windows;

  @override
  List<Object?> get props => [probability, windows];
}

DateTime _addMonths(DateTime d, int months) {
  final total = d.month - 1 + months;
  final year = d.year + total ~/ 12;
  final month = total % 12 + 1;
  final lastDay = DateTime(year, month + 1, 0).day;
  return DateTime(year, month, d.day > lastDay ? lastDay : d.day);
}

/// Historical probability of losing money after holding for [months].
///
/// For every start point, the end price is the first observation on or after
/// start + [months]. Starts whose horizon exceeds the history are ignored.
/// Returns null when no complete window exists (e.g. history too short).
LossProbability? lossProbability(List<PricePoint> points, int months) {
  if (points.length < 2 || months <= 0) return null;
  var losses = 0;
  var windows = 0;
  var end = 0;
  for (var start = 0; start < points.length; start++) {
    final target = _addMonths(points[start].date, months);
    if (target.isAfter(points.last.date)) break;
    if (end < start) end = start;
    while (end < points.length && points[end].date.isBefore(target)) {
      end++;
    }
    if (end >= points.length) break;
    if (points[start].close <= 0) continue;
    windows++;
    if (points[end].close < points[start].close) losses++;
  }
  if (windows == 0) return null;
  return LossProbability(probability: losses / windows, windows: windows);
}

/// Whole months covered by the history.
int historyMonths(List<PricePoint> points) {
  if (points.length < 2) return 0;
  var m = 0;
  while (!_addMonths(points.first.date, m + 1).isAfter(points.last.date)) {
    m++;
  }
  return m;
}
