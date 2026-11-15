/// Performance in percent: (final - initial) / initial × 100.
///
/// Returns null when the initial value is not strictly positive
/// (division by zero or meaningless base).
double? performancePercent(double initial, double finalValue) {
  if (initial <= 0) return null;
  return (finalValue - initial) / initial * 100;
}
