enum RiskLevel {
  low('Low risk'),
  moderate('Moderate risk'),
  high('High risk'),
  veryHigh('Very high risk');

  const RiskLevel(this.label);
  final String label;

  /// Classifies an annualised volatility (percent).
  static RiskLevel fromVolatility(double vol) {
    if (vol < 12) return low;
    if (vol < 25) return moderate;
    if (vol < 45) return high;
    return veryHigh;
  }
}
