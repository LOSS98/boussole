import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/charts/price_line_chart.dart';
import '../../core/widgets/stat_tile.dart';
import '../../domain/calculations/panic_simulation.dart';
import '../../domain/calculations/performance.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import 'buy_more_sheet.dart';
import 'panic_controller.dart';

class PanicPlayView extends ConsumerWidget {
  const PanicPlayView({super.key, required this.state});

  final PanicState state;

  static const _icons = {
    PanicAction.hold: Icons.pan_tool_rounded,
    PanicAction.sell: Icons.logout_rounded,
    PanicAction.buyMore: Icons.add_shopping_cart_rounded,
    PanicAction.buyBack: Icons.login_rounded,
  };

  static const _hints = {
    PanicAction.hold: 'Do nothing this week',
    PanicAction.sell: 'Cash out everything now',
    PanicAction.buyMore: 'Choose how much to add',
    PanicAction.buyBack: 'Reinvest all your cash',
  };

  /// Out of the market, "Hold" really means keeping the cash.
  static String _title(PanicAction a, bool isOut) =>
      a == PanicAction.hold && isOut ? 'Stay in cash' : a.label;

  static String _hint(PanicAction a, bool isOut) =>
      a == PanicAction.hold && isOut
      ? 'Keep your money safe in cash'
      : _hints[a]!;

  static String _glossaryId(PanicAction a, bool isOut) => switch (a) {
    PanicAction.hold => isOut ? 'stay-in-cash' : 'hold',
    PanicAction.sell => 'sell-all',
    PanicAction.buyMore => 'buy-more',
    PanicAction.buyBack => 'buy-back',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sim = state.sim!;
    final theme = Theme.of(context);
    final controller = ref.read(panicControllerProvider.notifier);
    final peak = sim.prices
        .sublist(0, sim.week + 1)
        .map((p) => p.close)
        .reduce((a, b) => a > b ? a : b);
    final marketDrop = performancePercent(peak, sim.currentPrice) ?? 0;
    final gain = performancePercent(sim.invested, sim.value) ?? 0;

    return ListView(
      key: const ValueKey('play'),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: [
        Row(
          children: [
            Text(
              'Week ${sim.week + 1} of ${sim.prices.length}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const Spacer(),
            Text(
              Fmt.date(sim.prices[sim.week].date),
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: (sim.week + 1) / sim.prices.length,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.scenario!.assetName,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.sm),
              PriceLineChart(
                points: sim.prices.sublist(0, sim.week + 1),
                height: 150,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: 'Your portfolio',
                value: Fmt.money(sim.value, symbol: '€', digits: 0),
                hint: sim.isOut ? 'All in cash' : 'Invested',
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: StatTile(
                label: 'Market vs peak',
                value: Fmt.percent(marketDrop),
                valueColor: marketDrop < 0 ? AppColors.loss : AppColors.gain,
                hint: 'You: ${Fmt.percent(gain)}',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          _prompt(marketDrop),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm + 2),
        for (final action in sim.availableActions)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              onTap: () async {
                if (action != PanicAction.buyMore) {
                  controller.act(action);
                  return;
                }
                final amount = await askBuyMoreAmount(
                  context,
                  sim.initialAmount,
                );
                if (amount != null) {
                  controller.act(action, amount: amount);
                }
              },
              child: Row(
                children: [
                  Icon(_icons[action], color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _title(action, sim.isOut),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _hint(action, sim.isOut),
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Explain',
                    icon: const Icon(Icons.help_outline_rounded),
                    onPressed: () => context.push(
                      Routes.glossary(_glossaryId(action, sim.isOut)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        TextButton.icon(
          onPressed: () => controller.skipWeeks(4),
          icon: const Icon(Icons.fast_forward_rounded),
          label: Text(sim.isOut ? 'Wait 4 weeks' : 'Hold for 4 weeks'),
        ),
      ],
    );
  }

  String _prompt(double drop) {
    if (drop <= -30) return 'Everything is red. What do you do?';
    if (drop <= -10) return 'The market is falling. What do you do?';
    if (drop < -2) return 'A dip appears. What do you do?';
    return 'Calm for now. What do you do?';
  }
}
