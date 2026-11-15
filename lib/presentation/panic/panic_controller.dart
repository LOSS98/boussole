import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/calculations/panic_simulation.dart';
import '../../domain/models/crash_scenario.dart';
import '../../domain/models/price_point.dart';
import '../../domain/models/saved_simulation.dart';
import '../providers/infra_providers.dart';

class PanicState {
  const PanicState({
    this.scenario,
    this.sim,
    this.saved = false,
    this.loading = false,
    this.error,
  });

  final CrashScenario? scenario;

  /// Null while not configured.
  final PanicSimulation? sim;
  final bool saved;
  final bool loading;
  final String? error;

  bool get isPlaying => sim != null && !sim!.isFinished;
  bool get isFinished => sim?.isFinished ?? false;
}

class PanicController extends Notifier<PanicState> {
  @override
  PanicState build() => const PanicState();

  Future<void> start(CrashScenario scenario, double amount) async {
    state = PanicState(scenario: scenario, loading: true);
    try {
      final raw = await ref
          .read(catalogRepositoryProvider)
          .loadCrash(scenario.file);
      final prices = [
        for (final r in raw)
          PricePoint(DateTime.parse(r[0] as String), (r[1] as num).toDouble()),
      ];
      state = PanicState(
        scenario: scenario,
        sim: PanicSimulation.start(prices, amount),
      );
    } catch (e) {
      state = PanicState(
        scenario: scenario,
        error: 'Could not load the scenario.',
      );
    }
  }

  void act(PanicAction action, {double? amount}) {
    final sim = state.sim;
    if (sim == null) return;
    state = PanicState(
      scenario: state.scenario,
      sim: sim.step(action, amount: amount),
    );
  }

  /// Holds for up to [weeks] weeks (long scenarios have over 100 weeks).
  void skipWeeks(int weeks) {
    var sim = state.sim;
    if (sim == null) return;
    for (var i = 0; i < weeks && !sim!.isFinished; i++) {
      sim = sim.step(PanicAction.hold);
    }
    state = PanicState(scenario: state.scenario, sim: sim);
  }

  void reset() => state = const PanicState();

  Future<void> save() async {
    final sim = state.sim;
    final scenario = state.scenario;
    if (sim == null || !sim.isFinished || scenario == null) return;
    final o = sim.outcome;
    String money(double v) => v.toStringAsFixed(0);
    await ref
        .read(userRepositoryProvider)
        .saveSimulation(SimulationKind.panic, scenario.title, {
          'Scenario': scenario.title,
          'Starting amount': money(sim.initialAmount),
          'Total invested': money(o.invested),
          'Final value': money(o.finalValue),
          'If you did nothing': money(o.holdValue),
          'Decisions': _summarize(sim.moves),
        });
    state = PanicState(scenario: scenario, sim: sim, saved: true);
  }
}

/// "1 sale, 8 reinforcements" instead of a long list of weekly choices.
String _summarize(List<PanicMove> moves) {
  int count(PanicAction a) => moves.where((m) => m.action == a).length;
  final added = moves.fold<double>(0, (sum, m) => sum + m.amount);
  final parts = [
    if (count(PanicAction.sell) > 0) '${count(PanicAction.sell)} sale',
    if (count(PanicAction.buyBack) > 0)
      '${count(PanicAction.buyBack)} buy-back',
    if (count(PanicAction.buyMore) > 0)
      '${count(PanicAction.buyMore)} reinforcement (€${added.toStringAsFixed(0)} added)',
  ];
  return parts.isEmpty ? 'Held every week' : parts.join(', ');
}

final panicControllerProvider = NotifierProvider<PanicController, PanicState>(
  PanicController.new,
);
