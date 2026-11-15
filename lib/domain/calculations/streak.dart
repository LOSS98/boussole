import '../models/quiz_stats.dart';

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// Applies one answer to the quiz statistics. The streak counts consecutive
/// days with at least one correct answer.
QuizStats applyAnswer(
  QuizStats s, {
  required bool correct,
  required DateTime now,
}) {
  final today = _day(now);
  var streak = s.streak;
  var last = s.lastPlayed;
  if (correct) {
    if (last == null) {
      streak = 1;
    } else {
      final gap = today.difference(_day(last)).inDays;
      if (gap == 1) {
        streak += 1;
      } else if (gap > 1) {
        streak = 1;
      } else if (streak == 0) {
        streak = 1;
      }
    }
    last = today;
  } else if (last != null && today.difference(_day(last)).inDays > 1) {
    streak = 0;
  }
  return QuizStats(
    correct: s.correct + (correct ? 1 : 0),
    answered: s.answered + 1,
    streak: streak,
    bestStreak: streak > s.bestStreak ? streak : s.bestStreak,
    lastPlayed: last,
  );
}
