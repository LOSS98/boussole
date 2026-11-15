import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/remote/price_source.dart';
import '../../domain/calculations/series_utils.dart';
import '../../domain/models/asset.dart';
import '../../domain/models/asset_analysis.dart';
import '../../domain/models/price_history.dart';
import '../../domain/models/quiz_question.dart';
import '../../domain/models/quiz_stats.dart';
import '../providers/infra_providers.dart';
import '../providers/market_providers.dart';

/// Minimum weekly points needed to build a one-year question.
const _minWeeks = 53;
const _minCachedAssets = 4;

class QuizState {
  const QuizState({
    required this.stats,
    this.question,
    this.selected,
    this.needsData = false,
    this.preparing = false,
    this.message,
  });

  final QuizStats stats;

  /// Null when not enough data is cached (see [needsData]).
  final QuizQuestion? question;

  /// Answer chosen by the user; the card is revealed once set.
  final Asset? selected;
  final bool needsData;
  final bool preparing;
  final String? message;

  bool get revealed => selected != null;
  bool get isCorrect => selected == question?.answer;

  QuizState copyWith({
    QuizStats? stats,
    QuizQuestion? question,
    Asset? selected,
    bool? needsData,
    bool? preparing,
    String? message,
    bool clearSelection = false,
  }) => QuizState(
    stats: stats ?? this.stats,
    question: question ?? this.question,
    selected: clearSelection ? null : (selected ?? this.selected),
    needsData: needsData ?? this.needsData,
    preparing: preparing ?? this.preparing,
    message: message,
  );
}

class QuizController extends AsyncNotifier<QuizState> {
  final _random = Random();

  @override
  Future<QuizState> build() async {
    final stats = await ref.read(userRepositoryProvider).quizStats();
    return _withNewQuestion(QuizState(stats: stats));
  }

  /// The quiz only draws from histories already in the local cache.
  Future<QuizState> _withNewQuestion(QuizState base) async {
    final repo = ref.read(marketRepositoryProvider);
    final catalog = await ref.read(catalogProvider.future);
    final cached = await repo.cachedWeeklySymbols(minPoints: _minWeeks);
    final candidates = [
      for (final a in catalog)
        if (cached.contains(a.symbol)) a,
    ];
    if (candidates.length < _minCachedAssets) {
      return base.copyWith(needsData: true, clearSelection: true);
    }
    final answer = candidates[_random.nextInt(candidates.length)];
    final weekly = await repo.cachedWeekly(answer.symbol);
    final end = _minWeeks - 1 + _random.nextInt(weekly.length - _minWeeks + 1);
    final window = weekly.sublist(end - (_minWeeks - 1), end + 1);
    final others = [...catalog]
      ..remove(answer)
      ..shuffle(_random);
    final options = [answer, ...others.take(3)]..shuffle(_random);
    return base.copyWith(
      question: QuizQuestion(
        answer: answer,
        options: options,
        normalized: rebase100([for (final p in window) p.close]),
        analysis: AssetAnalysis.of(window),
      ),
      needsData: false,
      clearSelection: true,
    );
  }

  Future<void> answer(Asset choice) async {
    final current = state.requireValue;
    if (current.revealed || current.question == null) return;
    final correct = choice == current.question!.answer;
    final stats = await ref
        .read(userRepositoryProvider)
        .recordAnswer(correct: correct);
    state = AsyncData(current.copyWith(selected: choice, stats: stats));
  }

  Future<void> next() async {
    final current = state.requireValue;
    state = AsyncData(await _withNewQuestion(current));
  }

  /// Downloads a few histories (when online) so that questions can be built.
  Future<void> prepareData() async {
    final current = state.requireValue;
    state = AsyncData(current.copyWith(preparing: true));
    final repo = ref.read(marketRepositoryProvider);
    final catalog = await ref.read(catalogProvider.future);
    // A mix of families; crypto is keyless so it works without any API key.
    final picks = [...catalog]..shuffle(_random);
    var loaded = 0;
    String? error;
    for (final asset in picks) {
      if (loaded >= 6) break;
      try {
        await repo.ensureHistory(asset, Granularity.weekly);
        loaded++;
      } on ApiException catch (e) {
        error = e.message;
      }
    }
    final next = await _withNewQuestion(current.copyWith(preparing: false));
    state = AsyncData(
      next.needsData
          ? next.copyWith(message: error ?? 'Not enough data could be loaded.')
          : next,
    );
  }
}

final quizControllerProvider = AsyncNotifierProvider<QuizController, QuizState>(
  QuizController.new,
);
