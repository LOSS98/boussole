import '../../domain/models/asset.dart';
import '../../domain/models/price_history.dart';
import '../../domain/models/price_point.dart';
import '../local/price_cache_store.dart';
import '../remote/price_source.dart';

/// The only class that decides between cache and network.
///
/// Strategy: cached data is used as is while younger than
/// [Granularity.maxAge] (24 h daily, 7 days weekly). Otherwise the cached
/// series is emitted immediately (status `refreshing`), then only the missing
/// data is requested and merged into the cache. If the refresh fails, the
/// cache is emitted with status `stale`.
class MarketRepository {
  MarketRepository({
    required PriceCacheStore store,
    required PriceSource source,
    required RatesSource rates,
    DateTime Function()? now,
  }) : _store = store,
       _source = source,
       _rates = rates,
       _now = now ?? DateTime.now;

  final PriceCacheStore _store;
  final PriceSource _source;
  final RatesSource _rates;
  final DateTime Function() _now;

  static const _fxSymbol = 'FX:USD-EUR';

  Stream<PriceHistory> watchHistory(
    Asset asset,
    Granularity granularity, {
    bool force = false,
  }) => _load(
    symbol: asset.symbol,
    granularity: granularity,
    force: force,
    fetch: (since) => _source.fetch(asset, granularity, since: since),
  );

  /// USD -> EUR exchange rates (daily).
  Stream<PriceHistory> watchUsdEurRates({bool force = false}) => _load(
    symbol: _fxSymbol,
    granularity: Granularity.daily,
    force: force,
    fetch: (since) => _rates.fetchUsdToEur(since: since),
  );

  /// Waits for the final state of [watchHistory] (used to prefetch data).
  Future<PriceHistory> ensureHistory(Asset asset, Granularity granularity) =>
      watchHistory(asset, granularity).last;

  /// Symbols whose weekly history is available offline (for the quiz).
  Future<List<String>> cachedWeeklySymbols({int minPoints = 60}) =>
      _store.symbolsWithWeekly(minPoints);

  Future<List<PricePoint>> cachedWeekly(String symbol) =>
      _store.read(symbol, Granularity.weekly.name);

  Future<void> clearCache() => _store.clearAll();

  Stream<PriceHistory> _load({
    required String symbol,
    required Granularity granularity,
    required bool force,
    required Future<List<PricePoint>> Function(DateTime? since) fetch,
  }) async* {
    final g = granularity.name;
    var cached = await _store.read(symbol, g);
    var meta = await _store.meta(symbol, g);

    PriceHistory snapshot(HistoryStatus status, {String? error}) =>
        PriceHistory(
          symbol: symbol,
          granularity: granularity,
          points: cached,
          lastUpdated: meta?.fetchedAt,
          status: status,
          errorMessage: error,
        );

    final fresh =
        meta != null &&
        cached.isNotEmpty &&
        _now().difference(meta.fetchedAt) < granularity.maxAge;
    if (fresh && !force) {
      yield snapshot(HistoryStatus.fresh);
      return;
    }

    if (cached.isNotEmpty) yield snapshot(HistoryStatus.refreshing);

    try {
      final since = cached.isEmpty ? null : cached.last.date;
      final incoming = await fetch(since);
      if (incoming.isEmpty && cached.isEmpty) {
        throw const ApiException('No data returned.');
      }
      final fetchedAt = _now();
      await _store.merge(symbol, g, incoming, fetchedAt: fetchedAt);
      cached = await _store.read(symbol, g);
      meta = CacheMetaInfo(fetchedAt);
      yield snapshot(HistoryStatus.fresh);
    } on ApiException catch (e) {
      if (cached.isEmpty) rethrow;
      yield snapshot(HistoryStatus.stale, error: e.message);
    }
  }
}
