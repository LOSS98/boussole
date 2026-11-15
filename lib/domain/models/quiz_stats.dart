import 'package:equatable/equatable.dart';

class QuizStats extends Equatable {
  const QuizStats({
    this.correct = 0,
    this.answered = 0,
    this.streak = 0,
    this.bestStreak = 0,
    this.lastPlayed,
  });

  final int correct;
  final int answered;

  /// Consecutive days with at least one correct answer.
  final int streak;
  final int bestStreak;
  final DateTime? lastPlayed;

  @override
  List<Object?> get props => [
    correct,
    answered,
    streak,
    bestStreak,
    lastPlayed,
  ];
}
