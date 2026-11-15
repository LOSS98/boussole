import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/animations/favorite_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/asset_avatar.dart';
import '../../core/widgets/charts/price_line_chart.dart';
import '../../core/widgets/data_status_banner.dart';
import '../../core/widgets/disclaimer_note.dart';
import '../../core/widgets/risk_badge.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/glossary_button.dart';
import '../../core/widgets/state_views.dart';
import '../../core/widgets/stat_tile.dart';
import '../../domain/models/asset.dart';
import '../providers/infra_providers.dart';
import '../providers/market_providers.dart';
import '../providers/user_providers.dart';

class AssetDetailScreen extends ConsumerWidget {
  const AssetDetailScreen({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(catalogProvider);
    final asset = catalog.value?.where((a) => a.symbol == symbol).firstOrNull;
    if (asset == null) {
      return Scaffold(
        appBar: AppBar(),
        body: catalog.isLoading
            ? const LoadingView()
            : const EmptyView(
                icon: Icons.help_outline_rounded,
                title: 'Unknown asset',
                message: 'This asset is not in the catalog.',
              ),
      );
    }
    final range = ref.watch(chartRangeProvider);
    final view = ref.watch(assetViewProvider((asset, range)));
    final isFavorite =
        ref.watch(favoritesProvider).value?.contains(symbol) ?? false;

    return Scaffold(
      appBar: AppBar(
        actions: [
          const GlossaryButton(term: 'volatility'),
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => refreshHistory(ref, asset, range.granularity),
          ),
          FavoriteButton(
            isFavorite: isFavorite,
            onChanged: (v) =>
                ref.read(userRepositoryProvider).setFavorite(symbol, v),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        children: [
          _Header(asset: asset),
          const SizedBox(height: AppSpacing.md),
          view.when(
            skipLoadingOnReload: true,
            loading: () => const SizedBox(height: 320, child: LoadingView()),
            error: (e, _) => SizedBox(
              height: 320,
              child: ErrorView(
                error: e,
                onRetry: () => refreshHistory(ref, asset, range.granularity),
              ),
            ),
            data: (v) => _Content(asset: asset, view: v, range: range),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.asset});

  final Asset asset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        AssetAvatar(asset, size: 60, hero: true),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                asset.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${asset.symbol} · ${asset.type.label}',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({
    required this.asset,
    required this.view,
    required this.range,
  });

  final Asset asset;
  final AssetView view;
  final ChartRange range;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final a = view.analysis;
    final sym = view.currencySymbol;
    final last = a.points.isEmpty ? null : a.points.last.close;
    final perf = a.performance;
    final perfColor = perf == null
        ? null
        : (perf >= 0 ? AppColors.gain : AppColors.loss);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DataStatusBanner(view.history),
        if (view.eurUnavailable)
          const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: Text('Euro rates unavailable, showing US dollars.'),
          ),
        Text(
          asset.description,
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    last == null ? '—' : Fmt.price(last, symbol: sym),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      Fmt.percent(perf),
                      style: TextStyle(
                        color: perfColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (a.risk != null) RiskBadge(a.risk!, period: range.label),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              PriceLineChart(points: a.points, currencySymbol: sym),
              const SizedBox(height: AppSpacing.sm),
              _RangeSelector(range: range),
              if (view.history.lastUpdated != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    'Last update: ${Fmt.dateTime(view.history.lastUpdated!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionTitle('Key indicators'),
        const SizedBox(height: AppSpacing.sm + 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StatTile(
                label: 'Performance',
                value: Fmt.percent(perf),
                valueColor: perfColor,
                hint: 'Gain or loss over the period',
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: StatTile(
                label: 'Volatility',
                value: Fmt.percent(a.volatility, sign: false),
                hint: 'How much the price jumps around, per year',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm + 2),
        StatTile(
          label: 'Worst drop',
          value: a.drawdown == null
              ? '—'
              : Fmt.percent(a.drawdown!.depth * 100),
          valueColor: AppColors.loss,
          hint: 'Biggest fall from a peak to the lowest point after it',
        ),
        const DisclaimerNote(),
        const SizedBox(height: AppSpacing.lg),
        const SectionTitle('What does this mean?'),
        const SizedBox(height: AppSpacing.sm + 2),
        AppCard(
          child: Text(
            a.explain(asset),
            style: const TextStyle(height: 1.45, fontSize: 15),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const DisclaimerNote(
          text:
              'Prices are raw closing prices: dividends and stock splits are '
              'not adjusted, which can understate some performances.',
        ),
      ],
    );
  }
}

class _RangeSelector extends ConsumerWidget {
  const _RangeSelector({required this.range});

  final ChartRange range;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final r in ChartRange.values)
          ChoiceChip(
            label: Text(r.label),
            selected: r == range,
            onSelected: (_) => ref.read(chartRangeProvider.notifier).select(r),
          ),
      ],
    );
  }
}
