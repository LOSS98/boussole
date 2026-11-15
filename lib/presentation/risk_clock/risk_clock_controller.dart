import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/calculations/loss_probability.dart';
import '../../domain/models/asset.dart';
import '../../domain/models/price_history.dart';
import '../../domain/models/saved_simulation.dart';
import '../providers/infra_providers.dart';
import '../providers/market_providers.dart';

/// Holding periods (in months) shown in the histogram.
const holdingPeriods = [1, 3, 6, 12, 24, 36, 60, 120];

String periodLabel(int months) =>
    months < 12 ? '${months}M' : '${months ~/ 12}Y';

class RiskClockInput {
  const RiskClockInput({this.asset, this.periodIndex = 3, this.saved = false});

  final Asset? asset;
  final int periodIndex;

  /// True once the current result has been saved.
  final bool saved;

  int get months => holdingPeriods[periodIndex];

  RiskClockInput copyWith({Asset? asset, int? periodIndex, bool? saved}) =>
      RiskClockInput(
        asset: asset ?? this.asset,
        periodIndex: periodIndex ?? this.periodIndex,
        saved: saved ?? false,
      );
}

class RiskClockController extends Notifier<RiskClockInput> {
  @override
  RiskClockInput build() => const RiskClockInput();

  void selectAsset(Asset a) => state = state.copyWith(asset: a);
  void selectPeriod(int index) => state = state.copyWith(periodIndex: index);

  Future<void> save(RiskClockResult result) async {
    final asset = state.asset;
    if (asset == null) return;
    final sel = result.selected;
    await ref.read(userRepositoryProvider).saveSimulation(
      SimulationKind.riskClock,
      '${asset.name} · ${periodLabel(state.months)}',
      {
        'Asset': '${asset.name} (${asset.symbol})',
        'Holding period': periodLabel(state.months),
        'Chance of loss': sel == null
            ? 'Not enough history'
            : '${(sel.probability * 100).toStringAsFixed(0)} %',
        'Windows analysed': '${sel?.windows ?? 0}',
        'History': '${result.historyMonths} months',
      },
    );
    state = RiskClockInput(
      asset: asset,
      periodIndex: state.periodIndex,
      saved: true,
    );
  }
}

final riskClockControllerProvider =
    NotifierProvider<RiskClockController, RiskClockInput>(
      RiskClockController.new,
    );

class RiskClockResult {
  const RiskClockResult({
    required this.history,
    required this.bars,
    required this.selected,
    required this.historyMonths,
  });

  final PriceHistory history;

  /// Loss probability for every entry of [holdingPeriods] (null: too short).
  final List<LossProbability?> bars;
  final LossProbability? selected;
  final int historyMonths;
}

/// Null while no asset is chosen ("not selected" state).
final riskClockResultProvider =
    Provider.autoDispose<AsyncValue<RiskClockResult?>>((ref) {
      final input = ref.watch(riskClockControllerProvider);
      final asset = input.asset;
      if (asset == null) return const AsyncData(null);
      return ref.watch(historyProvider((asset, Granularity.weekly))).whenData((
        h,
      ) {
        final bars = [
          for (final m in holdingPeriods) lossProbability(h.points, m),
        ];
        return RiskClockResult(
          history: h,
          bars: bars,
          selected: bars[input.periodIndex],
          historyMonths: historyMonths(h.points),
        );
      });
    });
