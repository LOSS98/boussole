import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/animations/animated_counter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/charts/drawn_line_chart.dart';
import '../../core/widgets/disclaimer_note.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/stat_tile.dart';
import '../../domain/calculations/drawdown.dart';
import '../../domain/calculations/panic_simulation.dart';
import 'panic_controller.dart';

class PanicFinishedView extends ConsumerWidget {
  const PanicFinishedView({super.key, required this.state});

  final PanicState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sim = state.sim!;
    final o = sim.outcome;
    final controller = ref.read(panicControllerProvider.notifier);
    final theme = Theme.of(context);
    final dd = maxDrawdown([for (final p in sim.prices) p.close]);
    final recovery = dd?.recoveryPeriods;

    return ListView(
      key: const ValueKey('finished'),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: [
        AppCard(
          child: Column(
            children: [
              Text(
                state.scenario!.title,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Your result',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              const SizedBox(height: AppSpacing.sm),
              AnimatedCounter(
                value: o.gain,
                format: (v) =>
                    '${v >= 0 ? '+' : '-'}${Fmt.money(v.abs(), symbol: '€', digits: 0)}',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'on ${Fmt.money(o.invested, symbol: '€', digits: 0)} invested',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('You vs doing nothing'),
              const SizedBox(height: AppSpacing.md),
              DrawnLineChart(
                series: [
                  ChartSeries(
                    sim.holdSeries(),
                    theme.colorScheme.onSurfaceVariant,
                    width: 2.5,
                  ),
                  ChartSeries(sim.valueSeries(), AppColors.blue),
                ],
              ),
              const Row(
                children: [
                  _Legend(color: AppColors.blue, label: 'Your decisions'),
                  SizedBox(width: AppSpacing.md),
                  _Legend(color: Colors.grey, label: 'Doing nothing'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: 'Your final value',
                value: Fmt.money(o.finalValue, symbol: '€', digits: 0),
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: StatTile(
                label: 'Doing nothing',
                value: Fmt.money(o.holdValue, symbol: '€', digits: 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm + 2),
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: 'Your return',
                value: Fmt.percent(o.returnPercent),
                valueColor: o.returnPercent >= 0
                    ? AppColors.gain
                    : AppColors.loss,
                hint: 'On what you invested',
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: StatTile(
                label: 'Doing nothing',
                value: Fmt.percent(o.holdReturnPercent),
                valueColor: o.holdReturnPercent >= 0
                    ? AppColors.gain
                    : AppColors.loss,
                hint: 'Return of the baseline',
              ),
            ),
          ],
        ),
        const DisclaimerNote(
          text:
              'Results are compared as returns (%), because adding money '
              'changes how much you invested.',
        ),
        const SizedBox(height: AppSpacing.sm + 2),
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: 'Worst market drop',
                value: Fmt.percent((dd?.depth ?? 0) * 100),
                valueColor: AppColors.loss,
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: StatTile(
                label: 'Time to recover',
                value: recovery == null ? 'Not yet' : '$recovery weeks',
                hint: 'Back to the previous peak',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionTitle('What to remember'),
        const SizedBox(height: AppSpacing.sm + 2),
        AppCard(
          child: Text(
            _lesson(o),
            style: const TextStyle(height: 1.45, fontSize: 15),
          ),
        ),
        const DisclaimerNote(),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          onPressed: state.saved ? null : controller.save,
          icon: Icon(
            state.saved ? Icons.check_rounded : Icons.bookmark_add_outlined,
          ),
          label: Text(state.saved ? 'Saved' : 'Save this simulation'),
        ),
        const SizedBox(height: AppSpacing.sm + 2),
        OutlinedButton.icon(
          onPressed: controller.reset,
          icon: const Icon(Icons.replay_rounded),
          label: const Text('Try again'),
        ),
      ],
    );
  }

  String _lesson(PanicOutcome o) {
    final gap = o.returnGap;
    final points = gap.abs().toStringAsFixed(1);
    final better = gap > 0.5;
    final worse = gap < -0.5;
    if (o.sold && o.boughtBack) {
      return worse
          ? 'You got out and back in, but your timing cost you $points points of '
                'return compared with doing nothing. Market timing is very hard: '
                'both the bottom and the rebound are only obvious afterwards.'
          : 'Your sell-and-buy-back timing worked this time. It is very hard to '
                'repeat: nobody knows the bottom in advance.';
    }
    if (o.sold) {
      return worse
          ? 'Selling turned a temporary drop into a permanent loss and you missed '
                'the rebound ($points points of return below doing nothing). This is '
                'loss aversion: the pain of losing feels stronger than the joy of gaining.'
          : 'In this case selling avoided part of the fall. But nobody can know '
                'the bottom in advance, and being out of the market also means missing the rebound.';
    }
    if (o.addedMore) {
      if (better) {
        return 'Adding money while prices were low improved your return by '
            '$points points: the same money bought more units. It takes nerve '
            'and is never guaranteed.';
      }
      if (worse) {
        return 'Your additions were bought at higher prices than your start, '
            'which lowered your return by $points points. Buying more is not '
            'automatically a good idea: it depends on the price you pay.';
      }
      return 'Your additions barely changed your return. Money you add earns '
          'the market return from the day you add it.';
    }
    return 'You stayed invested through the storm. Drops are part of investing, '
        'and time often heals them, though never with certainty.';
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
