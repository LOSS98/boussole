import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/asset_avatar.dart';
import '../../core/widgets/brand_header.dart';
import '../../core/widgets/data_status_banner.dart';
import '../../core/widgets/disclaimer_note.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/glossary_button.dart';
import '../../core/widgets/state_views.dart';
import '../../domain/models/asset.dart';
import '../../domain/models/price_history.dart';
import '../providers/market_providers.dart';
import 'asset_picker.dart';
import 'risk_clock_controller.dart';
import 'loss_bars.dart';

class RiskClockScreen extends ConsumerWidget {
  const RiskClockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(riskClockControllerProvider);
    final result = ref.watch(riskClockResultProvider);
    final controller = ref.read(riskClockControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk clock'),
        actions: const [GlossaryButton(term: 'loss-probability')],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        children: [
          const BrandHeader(
            title: 'Time is your ally',
            subtitle:
                'Pick an asset and drag the slider: see how often it lost '
                'money over each holding period in the past.',
            icon: Icons.hourglass_bottom_rounded,
          ),
          const SizedBox(height: AppSpacing.md),
          _AssetSelector(
            asset: input.asset,
            onTap: () async {
              final picked = await pickAsset(context, ref);
              if (picked != null) controller.selectAsset(picked);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AsyncValueView<RiskClockResult?>(
            value: result,
            onRetry: () {
              final a = input.asset!;
              refreshHistory(ref, a, Granularity.weekly);
            },
            loadingMessage: 'Loading history…',
            data: (r) => r == null
                ? const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xl),
                    child: EmptyView(
                      icon: Icons.touch_app_rounded,
                      title: 'Choose an asset',
                      message: 'Select an asset above to start the simulation.',
                    ),
                  )
                : _ResultSection(input: input, result: r),
          ),
        ],
      ),
    );
  }
}

class _AssetSelector extends StatelessWidget {
  const _AssetSelector({required this.asset, required this.onTap});

  final Asset? asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final a = asset;
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          if (a != null) ...[
            AssetAvatar(a, size: 40),
            const SizedBox(width: AppSpacing.md),
          ] else ...[
            const Icon(Icons.add_circle_outline_rounded),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Text(
              a?.name ?? 'Select an asset',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
          const Icon(Icons.unfold_more_rounded),
        ],
      ),
    );
  }
}

class _ResultSection extends ConsumerWidget {
  const _ResultSection({required this.input, required this.result});

  final RiskClockInput input;
  final RiskClockResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(riskClockControllerProvider.notifier);
    final theme = Theme.of(context);
    final sel = result.selected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DataStatusBanner(result.history),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'If you had held for ${periodLabel(input.months)}…',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (sel == null)
                Text(
                  'Not enough history: only ${result.historyMonths} months are available for this asset.',
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                )
              else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(end: sel.probability * 100),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      builder: (_, v, _) => Text(
                        '${v.toStringAsFixed(0)} %',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          color: Color.lerp(
                            AppColors.gain,
                            AppColors.loss,
                            (v / 100).clamp(0, 1) * 1.6 > 1
                                ? 1
                                : (v / 100) * 1.6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('chance of ending in loss'),
                    ),
                  ],
                ),
                Text(
                  'Based on ${sel.windows} rolling periods in the history.',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Slider(
                value: input.periodIndex.toDouble(),
                min: 0,
                max: (holdingPeriods.length - 1).toDouble(),
                divisions: holdingPeriods.length - 1,
                label: periodLabel(input.months),
                onChanged: (v) => controller.selectPeriod(v.round()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1 month', style: theme.textTheme.bodySmall),
                  Text('10 years', style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionTitle('Chance of loss by holding period'),
        const SizedBox(height: AppSpacing.sm + 2),
        AppCard(
          child: LossBars(
            bars: result.bars,
            selectedIndex: input.periodIndex,
            onSelect: controller.selectPeriod,
          ),
        ),
        const DisclaimerNote(
          text:
              'Computed in US dollars, whatever the display currency. For a euro '
              'investor, exchange-rate moves change the real result. Raw prices; the '
              'past does not predict the future.',
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          onPressed: input.saved ? null : () => controller.save(result),
          icon: Icon(
            input.saved ? Icons.check_rounded : Icons.bookmark_add_outlined,
          ),
          label: Text(input.saved ? 'Saved' : 'Save this simulation'),
        ),
      ],
    );
  }
}
