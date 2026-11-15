import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/settings_repository.dart';
import '../../domain/calculations/series_utils.dart';
import '../../domain/models/asset.dart';
import '../../domain/models/asset_analysis.dart';
import '../../domain/models/price_history.dart';
import 'infra_providers.dart';

final catalogProvider = FutureProvider<List<Asset>>(
  (ref) => ref.watch(catalogRepositoryProvider).load(),
);

/// Symbols for which the user asked for a forced refresh (pull/refresh button).
class ForcedRefresh extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void request(String key) => state = {...state, key};
  bool consume(String key) {
    final had = state.contains(key);
    if (had) state = {...state}..remove(key);
    return had;
  }
}

final forcedRefreshProvider = NotifierProvider<ForcedRefresh, Set<String>>(
  ForcedRefresh.new,
);

typedef HistoryQuery = (Asset, Granularity);

/// Price history of an asset: emits cached data first, then refreshed data.
final historyProvider = StreamProvider.autoDispose
    .family<PriceHistory, HistoryQuery>((ref, query) async* {
      final (asset, granularity) = query;
      final repo = ref.watch(marketRepositoryProvider);
      final key = '${asset.symbol}/${granularity.name}';
      final force = ref.read(forcedRefreshProvider.notifier).consume(key);
      yield* repo.watchHistory(asset, granularity, force: force);
    });

void refreshHistory(WidgetRef ref, Asset asset, Granularity g) {
  ref.read(forcedRefreshProvider.notifier).request('${asset.symbol}/${g.name}');
  ref.invalidate(historyProvider((asset, g)));
}

final usdEurRatesProvider = StreamProvider.autoDispose<PriceHistory>((
  ref,
) async* {
  final repo = ref.watch(marketRepositoryProvider);
  yield* repo.watchUsdEurRates();
});

// ---- Asset detail -------------------------------------------------------------

enum ChartRange {
  m1('1M', 1, Granularity.daily),
  m3('3M', 3, Granularity.daily),
  m6('6M', 6, Granularity.weekly),
  y1('1Y', 12, Granularity.weekly),
  y5('5Y', 60, Granularity.weekly),
  y10('10Y', 120, Granularity.weekly);

  const ChartRange(this.label, this.months, this.granularity);
  final String label;
  final int months;
  final Granularity granularity;
}

class ChartRangeNotifier extends Notifier<ChartRange> {
  @override
  ChartRange build() => ChartRange.y1;

  void select(ChartRange r) => state = r;
}

final chartRangeProvider =
    NotifierProvider.autoDispose<ChartRangeNotifier, ChartRange>(
      ChartRangeNotifier.new,
    );

/// What the detail screen displays for one asset and one range.
class AssetView {
  const AssetView({
    required this.history,
    required this.analysis,
    required this.currencySymbol,
    this.eurUnavailable = false,
  });

  final PriceHistory history;
  final AssetAnalysis analysis;
  final String currencySymbol;
  final bool eurUnavailable;
}

typedef AssetViewQuery = (Asset, ChartRange);

final assetViewProvider = Provider.autoDispose
    .family<AsyncValue<AssetView>, AssetViewQuery>((ref, query) {
      final (asset, range) = query;
      final historyAsync = ref.watch(
        historyProvider((asset, range.granularity)),
      );
      final wantsEur = ref.watch(
        settingsProvider.select(
          (s) => s.value?.currency == DisplayCurrency.eur,
        ),
      );
      final ratesAsync = wantsEur ? ref.watch(usdEurRatesProvider) : null;

      return historyAsync.whenData((history) {
        var points = lastMonths(history.points, range.months);
        var symbol = '\$';
        var eurUnavailable = false;
        if (wantsEur) {
          final rates = ratesAsync?.value;
          if (rates != null && rates.points.isNotEmpty) {
            points = convertWithRates(points, rates.points);
            symbol = '€';
          } else {
            eurUnavailable = ratesAsync?.hasError ?? false;
          }
        }
        return AssetView(
          history: history,
          analysis: AssetAnalysis.of(points),
          currencySymbol: symbol,
          eurUnavailable: eurUnavailable,
        );
      });
    });
