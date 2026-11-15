import 'package:equatable/equatable.dart';

class DrawdownResult extends Equatable {
  const DrawdownResult({
    required this.depth,
    required this.peakIndex,
    required this.troughIndex,
    this.recoveryIndex,
  });

  /// Fraction, always <= 0 (e.g. -0.28 for -28 %).
  final double depth;
  final int peakIndex;
  final int troughIndex;

  /// First index after the trough where the peak is regained, if ever.
  final int? recoveryIndex;

  /// Observations needed to climb from the peak back to the peak level.
  int? get recoveryPeriods =>
      recoveryIndex == null ? null : recoveryIndex! - peakIndex;

  @override
  List<Object?> get props => [depth, peakIndex, troughIndex, recoveryIndex];
}

/// Largest fall between a peak and the lowest point that follows it.
/// Returns null for series with fewer than 2 prices.
DrawdownResult? maxDrawdown(List<double> prices) {
  if (prices.length < 2) return null;
  var peak = 0;
  var worst = 0.0;
  var worstPeak = 0;
  var worstTrough = 0;
  for (var i = 1; i < prices.length; i++) {
    if (prices[i] > prices[peak]) peak = i;
    if (prices[peak] <= 0) continue;
    final dd = (prices[i] - prices[peak]) / prices[peak];
    if (dd < worst) {
      worst = dd;
      worstPeak = peak;
      worstTrough = i;
    }
  }
  int? recovery;
  if (worst < 0) {
    for (var i = worstTrough + 1; i < prices.length; i++) {
      if (prices[i] >= prices[worstPeak]) {
        recovery = i;
        break;
      }
    }
  }
  return DrawdownResult(
    depth: worst,
    peakIndex: worstPeak,
    troughIndex: worstTrough,
    recoveryIndex: recovery,
  );
}
