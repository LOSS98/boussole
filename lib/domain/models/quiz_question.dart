import 'asset.dart';
import 'asset_analysis.dart';

/// One "Guess the curve" question.
class QuizQuestion {
  const QuizQuestion({
    required this.answer,
    required this.options,
    required this.normalized,
    required this.analysis,
  });

  final Asset answer;

  /// Four assets, shuffled; one of them is [answer].
  final List<Asset> options;

  /// One year of prices rebased to 100.
  final List<double> normalized;
  final AssetAnalysis analysis;
}
