import 'package:equatable/equatable.dart';

import '../models/price_point.dart';

enum PanicAction {
  hold('Hold'),
  sell('Sell all'),
  buyMore('Buy more'),
  buyBack('Buy back');

  const PanicAction(this.label);
  final String label;
}

/// Default amount of "Buy more", as a share of the initial amount.
/// The user can choose any other amount.
const double buyMoreShare = 0.10;

/// One decision of the user. [amount] is only used by [PanicAction.buyMore].
class PanicMove extends Equatable {
  const PanicMove(this.action, [this.amount = 0]);

  final PanicAction action;
  final double amount;

  @override
  List<Object?> get props => [action, amount];
}

/// Immutable state of a Panic Button run. Each [step] moves one week forward.
///
/// The user's portfolio (units + cash) is compared with a "do nothing"
/// baseline where the initial amount is simply held until the end.
class PanicSimulation extends Equatable {
  const PanicSimulation._({
    required this.prices,
    required this.initialAmount,
    required this.week,
    required this.units,
    required this.cash,
    required this.invested,
    required this.moves,
  });

  /// Starts a run: the whole [initialAmount] is invested at the first price.
  factory PanicSimulation.start(List<PricePoint> prices, double initialAmount) {
    if (prices.length < 2) {
      throw ArgumentError('At least two price points are required.');
    }
    if (initialAmount <= 0 || prices.first.close <= 0) {
      throw ArgumentError('Amount and first price must be positive.');
    }
    return PanicSimulation._(
      prices: prices,
      initialAmount: initialAmount,
      week: 0,
      units: initialAmount / prices.first.close,
      cash: 0,
      invested: initialAmount,
      moves: const [],
    );
  }

  final List<PricePoint> prices;
  final double initialAmount;
  final int week;
  final double units;
  final double cash;

  /// Total money put in (initial amount + reinforcements).
  final double invested;
  final List<PanicMove> moves;

  bool get isFinished => week >= prices.length - 1;
  bool get isOut => units == 0;
  double get currentPrice => prices[week].close;
  double get value => units * currentPrice + cash;

  /// Value of the baseline strategy at the current week.
  double get holdValue => initialAmount / prices.first.close * currentPrice;

  List<PanicAction> get availableActions => isOut
      ? const [PanicAction.hold, PanicAction.buyBack]
      : const [PanicAction.hold, PanicAction.sell, PanicAction.buyMore];

  /// Applies [action] at the current price, then advances one week.
  /// For [PanicAction.buyMore], [amount] is the money added (defaults to
  /// 10 % of the initial amount) and must be positive.
  PanicSimulation step(PanicAction action, {double? amount}) {
    if (isFinished) return this;
    if (!availableActions.contains(action)) {
      throw ArgumentError('Action $action not available now.');
    }
    var u = units;
    var c = cash;
    var inv = invested;
    final price = currentPrice;
    var added = 0.0;
    switch (action) {
      case PanicAction.hold:
        break;
      case PanicAction.sell:
        c += u * price;
        u = 0;
      case PanicAction.buyMore:
        added = amount ?? initialAmount * buyMoreShare;
        if (added <= 0) throw ArgumentError('Amount must be positive.');
        u += added / price;
        inv += added;
      case PanicAction.buyBack:
        u += c / price;
        c = 0;
    }
    return PanicSimulation._(
      prices: prices,
      initialAmount: initialAmount,
      week: week + 1,
      units: u,
      cash: c,
      invested: inv,
      moves: [...moves, PanicMove(action, added)],
    );
  }

  /// Portfolio value after each week played so far is not stored; this
  /// recomputes the value series by replaying [moves].
  List<double> valueSeries() {
    var sim = PanicSimulation.start(prices, initialAmount);
    final series = [sim.value];
    for (final m in moves) {
      sim = sim.step(
        m.action,
        amount: m.action == PanicAction.buyMore ? m.amount : null,
      );
      series.add(sim.value);
    }
    return series;
  }

  List<double> holdSeries() {
    final units0 = initialAmount / prices.first.close;
    return [for (var i = 0; i <= week; i++) units0 * prices[i].close];
  }

  /// Final result (valid once finished).
  PanicOutcome get outcome => PanicOutcome(
    finalValue: value,
    invested: invested,
    initialAmount: initialAmount,
    holdValue: holdValue,
    sold: moves.any((m) => m.action == PanicAction.sell),
    boughtBack: moves.any((m) => m.action == PanicAction.buyBack),
    addedMoney: moves.fold(0, (sum, m) => sum + m.amount),
  );

  @override
  List<Object?> get props => [prices, initialAmount, week, units, cash, moves];
}

class PanicOutcome extends Equatable {
  const PanicOutcome({
    required this.finalValue,
    required this.invested,
    required this.initialAmount,
    required this.holdValue,
    required this.sold,
    required this.boughtBack,
    required this.addedMoney,
  });

  final double finalValue;

  /// Initial amount + money added with "Buy more".
  final double invested;
  final double initialAmount;

  /// Final value of the "do nothing" strategy (initial amount only).
  final double holdValue;
  final bool sold;
  final bool boughtBack;
  final double addedMoney;

  bool get addedMore => addedMoney > 0;

  /// Profit or loss compared with the money actually invested.
  double get gain => finalValue - invested;

  /// Return on the money actually invested, in percent.
  double get returnPercent => invested <= 0 ? 0 : gain / invested * 100;

  /// Return of "doing nothing", in percent.
  double get holdReturnPercent => initialAmount <= 0
      ? 0
      : (holdValue - initialAmount) / initialAmount * 100;

  /// Percentage points gained (+) or lost (-) compared with doing nothing.
  /// Returns are compared, not final values, because adding money changes
  /// the amount invested: more money in does not mean better decisions.
  double get returnGap => returnPercent - holdReturnPercent;

  /// Plain difference of final values (only meaningful without added money).
  double get versusHold => finalValue - holdValue;

  @override
  List<Object?> get props => [
    finalValue,
    invested,
    initialAmount,
    holdValue,
    sold,
    boughtBack,
    addedMoney,
  ];
}
