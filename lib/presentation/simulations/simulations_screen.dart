import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/state_views.dart';
import '../../domain/models/saved_simulation.dart';
import '../providers/infra_providers.dart';
import '../providers/user_providers.dart';

class SimulationsScreen extends ConsumerWidget {
  const SimulationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sims = ref.watch(simulationsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My simulations')),
      body: AsyncValueView<List<SavedSimulation>>(
        value: sims,
        onRetry: () => ref.invalidate(simulationsProvider),
        data: (list) {
          if (list.isEmpty) {
            return const EmptyView(
              icon: Icons.bookmark_border_rounded,
              title: 'Nothing saved yet',
              message:
                  'Results from the Risk clock and the Panic button '
                  'appear here once you save them.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: list.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSpacing.sm + 2),
            itemBuilder: (_, i) => _SimulationTile(sim: list[i]),
          );
        },
      ),
    );
  }
}

class _SimulationTile extends ConsumerWidget {
  const _SimulationTile({required this.sim});

  final SavedSimulation sim;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isRisk = sim.kind == SimulationKind.riskClock;
    final color = isRisk ? AppColors.blue : AppColors.loss;
    return Dismissible(
      key: ValueKey(sim.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.loss,
          borderRadius: BorderRadius.circular(AppSpacing.radius),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) =>
          ref.read(userRepositoryProvider).deleteSimulation(sim.id),
      child: AppCard(
        onTap: () => _showDetails(context),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.14),
              child: Icon(
                isRisk ? Icons.schedule_rounded : Icons.crisis_alert_rounded,
                color: color,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sim.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${isRisk ? 'Risk clock' : 'Panic button'} · ${Fmt.date(sim.createdAt)}',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sim.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              for (final e in sim.payload.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(child: Text(e.key)),
                      Flexible(
                        child: Text(
                          e.value,
                          textAlign: TextAlign.end,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Saved on ${Fmt.dateTime(sim.createdAt)}. '
                'These figures describe the past, not the future.',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
