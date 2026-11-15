import 'package:boussole/domain/calculations/panic_simulation.dart';
import 'package:boussole/domain/models/price_point.dart';
import 'package:flutter_test/flutter_test.dart';

List<PricePoint> prices(List<double> closes) => [
  for (var i = 0; i < closes.length; i++)
    PricePoint(DateTime(2020, 1, 6 + 7 * i), closes[i]),
];

PanicSimulation run(PanicSimulation s, List<PanicAction> actions) {
  for (final a in actions) {
    s = s.step(a);
  }
  return s;
}

void main() {
  // V-shaped crash: 100 -> 50 -> 100
  final crash = prices([100, 75, 50, 75, 100]);

  test('holding every week equals the baseline', () {
    final s = run(
      PanicSimulation.start(crash, 1000),
      List.filled(4, PanicAction.hold),
    );
    expect(s.isFinished, isTrue);
    expect(s.outcome.finalValue, closeTo(1000, 1e-9));
    expect(s.outcome.versusHold, closeTo(0, 1e-9));
  });

  test('selling at the bottom locks in the loss', () {
    final s = run(PanicSimulation.start(crash, 1000), [
      PanicAction.hold,
      PanicAction.sell, // at 75
      PanicAction.hold,
      PanicAction.hold,
    ]);
    expect(s.outcome.finalValue, closeTo(750, 1e-9));
    expect(s.outcome.versusHold, closeTo(-250, 1e-9));
    expect(s.outcome.sold, isTrue);
  });

  test('buying more during the dip beats holding', () {
    final s = run(PanicSimulation.start(crash, 1000), [
      PanicAction.hold,
      PanicAction.hold,
      PanicAction.buyMore, // 100 € at 50 -> 2 units
      PanicAction.hold,
    ]);
    expect(s.invested, closeTo(1100, 1e-9));
    expect(s.outcome.finalValue, closeTo(1200, 1e-9));
    expect(s.outcome.gain, closeTo(100, 1e-9));
  });

  test('buying back after a sale', () {
    var s = run(PanicSimulation.start(crash, 1000), [
      PanicAction.hold,
      PanicAction.sell,
    ]);
    expect(s.isOut, isTrue);
    expect(s.availableActions, contains(PanicAction.buyBack));
    s = run(s, [PanicAction.buyBack, PanicAction.hold]);
    expect(s.isOut, isFalse);
    expect(
      s.outcome.finalValue,
      closeTo(1500, 1e-9),
    ); // 750 cash -> 15 units at 50, worth 100
  });

  test('buy more uses the amount chosen by the user', () {
    var s = PanicSimulation.start(crash, 1000);
    s = s.step(PanicAction.hold);
    s = s.step(PanicAction.hold); // week 2, price 50
    s = s.step(PanicAction.buyMore, amount: 500); // 10 units
    s = s.step(PanicAction.hold); // last week, price 100
    expect(s.invested, closeTo(1500, 1e-9));
    expect(s.valueSeries().length, 5);
    // 10 initial units + 10 bought = 20 units, worth 100 each at the end
    expect(s.isFinished, isTrue);
    expect(s.outcome.finalValue, closeTo(2000, 1e-9));
  });

  test('buy more rejects a zero or negative amount', () {
    final s = PanicSimulation.start(crash, 1000);
    expect(() => s.step(PanicAction.buyMore, amount: 0), throwsArgumentError);
    expect(() => s.step(PanicAction.buyMore, amount: -50), throwsArgumentError);
  });

  test('returns are compared, so adding money alone does not "win"', () {
    // Buying more at the START price adds money but no skill.
    var s = PanicSimulation.start(crash, 1000);
    s = s.step(PanicAction.buyMore, amount: 1000); // week 0, price 100
    s = run(s, List.filled(3, PanicAction.hold));
    final o = s.outcome;
    expect(o.finalValue, closeTo(2000, 1e-9));
    expect(o.versusHold, closeTo(1000, 1e-9)); // looks like a win...
    expect(o.returnGap, closeTo(0, 1e-9)); // ...but the return is the same
  });

  test('buying the dip improves the return, buying the top does not', () {
    final dip = run(PanicSimulation.start(crash, 1000), [
      PanicAction.hold,
      PanicAction.hold,
    ]).step(PanicAction.buyMore, amount: 500).step(PanicAction.hold);
    expect(dip.outcome.returnGap, greaterThan(0));
    expect(dip.outcome.addedMore, isTrue);

    final top = PanicSimulation.start(crash, 1000)
        .step(PanicAction.buyMore, amount: 500)
        .step(PanicAction.hold)
        .step(PanicAction.hold)
        .step(PanicAction.hold);
    expect(top.outcome.returnGap, closeTo(0, 1e-9));
  });

  test('sell then buy back is tracked', () {
    final s = run(PanicSimulation.start(crash, 1000), [
      PanicAction.sell,
      PanicAction.buyBack,
      PanicAction.hold,
      PanicAction.hold,
    ]);
    expect(s.outcome.sold, isTrue);
    expect(s.outcome.boughtBack, isTrue);
  });

  test('actions that are not available throw', () {
    final s = PanicSimulation.start(crash, 1000);
    expect(() => s.step(PanicAction.buyBack), throwsArgumentError);
  });

  test('value series replays the decisions', () {
    final s = run(PanicSimulation.start(crash, 1000), [
      PanicAction.hold,
      PanicAction.sell,
    ]);
    expect(s.valueSeries(), [1000, 750, 500 * 1.5]);
    expect(s.holdSeries(), [1000, 750, 500]);
  });

  test('invalid starts are rejected', () {
    expect(() => PanicSimulation.start(crash, 0), throwsArgumentError);
    expect(() => PanicSimulation.start(crash, -5), throwsArgumentError);
    expect(
      () => PanicSimulation.start(prices([100]), 100),
      throwsArgumentError,
    );
    expect(
      () => PanicSimulation.start(prices([0, 10]), 100),
      throwsArgumentError,
    );
  });

  test('stepping a finished simulation is a no-op', () {
    final s = run(
      PanicSimulation.start(crash, 1000),
      List.filled(4, PanicAction.hold),
    );
    expect(s.step(PanicAction.hold), same(s));
  });
}
