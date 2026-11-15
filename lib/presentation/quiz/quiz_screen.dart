import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/animations/confetti.dart';
import '../../core/widgets/animations/flip_card.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/brand_header.dart';
import '../../core/widgets/disclaimer_note.dart';
import '../../core/widgets/risk_badge.dart';
import '../../core/widgets/glossary_button.dart';
import '../../core/widgets/state_views.dart';
import '../../core/widgets/stat_tile.dart';
import '../../domain/models/asset.dart';
import '../../domain/models/quiz_question.dart';
import 'quiz_controller.dart';

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess the curve'),
        actions: const [GlossaryButton(term: 'rebased')],
      ),
      body: AsyncValueView<QuizState>(
        value: state,
        onRetry: () => ref.invalidate(quizControllerProvider),
        data: (s) => _QuizBody(state: s),
      ),
    );
  }
}

class _QuizBody extends ConsumerWidget {
  const _QuizBody({required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(quizControllerProvider.notifier);
    final q = state.question;

    if (q == null) {
      return state.preparing
          ? const LoadingView(message: 'Downloading a few price histories…')
          : EmptyView(
              icon: Icons.download_for_offline_rounded,
              title: 'Let’s prepare your first questions',
              message:
                  state.message ??
                  'The quiz uses price histories saved on your device. '
                      'Download a few now to start playing.',
              action: FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size(220, 52)),
                onPressed: controller.prepareData,
                icon: const Icon(Icons.download_rounded),
                label: const Text('Download quiz data'),
              ),
            );
    }

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          children: [
            _ScoreRow(state: state),
            const SizedBox(height: AppSpacing.md),
            FlipCard(
              showBack: state.revealed,
              front: _CurveFace(question: q),
              back: _AnswerFace(question: q, correct: state.isCorrect),
            ),
            const SizedBox(height: AppSpacing.md),
            if (!state.revealed) ...[
              const Text(
                'Which asset drew this curve over one year?',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: AppSpacing.sm + 2),
              for (final option in q.options)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _OptionButton(
                    asset: option,
                    onTap: () => controller.answer(option),
                  ),
                ),
              const BrandHeader(
                title: 'Tip',
                subtitle:
                    'Wild swings usually mean a crypto or a single stock. '
                    'Smooth curves often belong to ETFs.',
                icon: Icons.lightbulb_outline_rounded,
              ),
            ] else ...[
              FilledButton.icon(
                onPressed: controller.next,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Next question'),
              ),
              const DisclaimerNote(),
            ],
          ],
        ),
        if (state.revealed && state.isCorrect) const Confetti(),
      ],
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context) {
    final s = state.stats;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StatTile(
              label: 'Score',
              value: '${s.correct}/${s.answered}',
            ),
          ),
          const SizedBox(width: AppSpacing.sm + 2),
          Expanded(
            child: StatTile(
              label: 'Streak',
              value: '${s.streak} ${s.streak == 1 ? 'day' : 'days'}',
              hint: 'Best: ${s.bestStreak}',
            ),
          ),
        ],
      ),
    );
  }
}

class _CurveFace extends StatelessWidget {
  const _CurveFace({required this.question});

  final QuizQuestion question;

  @override
  Widget build(BuildContext context) {
    final values = question.normalized;
    final up = values.last >= values.first;
    final color = up ? AppColors.gain : AppColors.loss;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mystery asset · 1 year · rebased to 100',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 190,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < values.length; i++)
                        FlSpot(i.toDouble(), values[i]),
                    ],
                    color: color,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerFace extends StatelessWidget {
  const _AnswerFace({required this.question, required this.correct});

  final QuizQuestion question;
  final bool correct;

  @override
  Widget build(BuildContext context) {
    final a = question.analysis;
    final color = correct ? AppColors.gain : AppColors.loss;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: color,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                correct ? 'Correct!' : 'Not this time',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              if (a.risk != null) RiskBadge(a.risk!),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            question.answer.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          Text(
            '${question.answer.symbol} · ${question.answer.type.label} · '
            '${Fmt.date(a.points.first.date)} → ${Fmt.date(a.points.last.date)}',
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: StatTile(
                  label: 'Return',
                  value: Fmt.percent(a.performance),
                  valueColor: (a.performance ?? 0) >= 0
                      ? AppColors.gain
                      : AppColors.loss,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: StatTile(
                  label: 'Volatility',
                  value: Fmt.percent(a.volatility, sign: false),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: StatTile(
                  label: 'Worst drop',
                  value: Fmt.percent((a.drawdown?.depth ?? 0) * 100),
                  valueColor: AppColors.loss,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({required this.asset, required this.onTap});

  final Asset asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              asset.name,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
          Text(
            asset.type.label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
