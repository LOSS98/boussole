import '../../domain/models/asset.dart';
import '../../domain/models/price_history.dart';
import '../../domain/models/price_point.dart';

/// Raised when a remote call fails (network, quota, bad response).
class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// A provider of historical prices for assets.
abstract interface class PriceSource {
  /// Prices sorted by date. [since] lets sources download only missing data
  /// when the API supports it.
  Future<List<PricePoint>> fetch(
    Asset asset,
    Granularity granularity, {
    DateTime? since,
  });
}

/// A provider of EUR-per-USD exchange rates.
abstract interface class RatesSource {
  Future<List<PricePoint>> fetchUsdToEur({DateTime? since});
}
