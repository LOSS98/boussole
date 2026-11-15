import '../calculations/drawdown.dart';
import '../calculations/performance.dart';
import '../calculations/volatility.dart';
import 'asset.dart';
import 'price_point.dart';
import 'risk_level.dart';

/// Indicators of an asset over a selected period.
class AssetAnalysis {
  AssetAnalysis._({
    required this.points,
    required this.performance,
    required this.volatility,
    required this.drawdown,
    required this.risk,
  });

  factory AssetAnalysis.of(List<PricePoint> points) {
    final perf = points.length < 2
        ? null
        : performancePercent(points.first.close, points.last.close);
    final vol = annualizedVolatility(points);
    return AssetAnalysis._(
      points: points,
      performance: perf,
      volatility: vol,
      drawdown: maxDrawdown([for (final p in points) p.close]),
      risk: vol == null ? null : RiskLevel.fromVolatility(vol),
    );
  }

  final List<PricePoint> points;
  final double? performance;
  final double? volatility;
  final DrawdownResult? drawdown;
  final RiskLevel? risk;

  /// Plain-English explanation adapted to the asset profile.
  String explain(Asset asset) {
    final buffer = StringBuffer();
    final perf = performance;
    if (perf != null) {
      final dir = perf >= 0 ? 'gained' : 'lost';
      buffer.write(
        'Over this period, ${asset.name} $dir ${perf.abs().toStringAsFixed(1)} %. ',
      );
    }
    final dd = drawdown;
    if (dd != null && dd.depth < 0) {
      buffer.write(
        'At its worst, it fell ${(dd.depth.abs() * 100).toStringAsFixed(0)} % from a peak to a low: '
        'that is what you would have lived through if you had bought at the top. ',
      );
    }
    switch (asset.type) {
      case AssetType.crypto:
        buffer.write(
          'Cryptocurrencies are among the most volatile assets: double-digit weekly moves are common.',
        );
      case AssetType.etf:
        buffer.write(
          'An ETF holds many assets at once, which usually smooths out the ride compared with a single company.',
        );
      case AssetType.stock:
        buffer.write(
          'A single stock depends on one company, so its price can move sharply on one piece of news.',
        );
    }
    return buffer.toString();
  }
}
