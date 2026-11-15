import 'package:boussole/domain/calculations/streak.dart';
import 'package:boussole/domain/models/quiz_stats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final d1 = DateTime(2024, 5, 1, 9);

  test('first correct answer starts the streak', () {
    final s = applyAnswer(const QuizStats(), correct: true, now: d1);
    expect(s.streak, 1);
    expect(s.correct, 1);
    expect(s.answered, 1);
  });

  test('same day does not increase the streak', () {
    var s = applyAnswer(const QuizStats(), correct: true, now: d1);
    s = applyAnswer(s, correct: true, now: d1.add(const Duration(hours: 3)));
    expect(s.streak, 1);
    expect(s.correct, 2);
  });

  test('next day increases, a gap resets', () {
    var s = applyAnswer(const QuizStats(), correct: true, now: d1);
    s = applyAnswer(s, correct: true, now: DateTime(2024, 5, 2, 8));
    expect(s.streak, 2);
    expect(s.bestStreak, 2);
    s = applyAnswer(s, correct: true, now: DateTime(2024, 5, 5));
    expect(s.streak, 1);
    expect(s.bestStreak, 2);
  });

  test('a wrong answer after a long gap breaks the streak', () {
    var s = applyAnswer(const QuizStats(), correct: true, now: d1);
    s = applyAnswer(s, correct: false, now: DateTime(2024, 5, 10));
    expect(s.streak, 0);
    expect(s.answered, 2);
  });

  test('a wrong answer the same day keeps the streak', () {
    var s = applyAnswer(const QuizStats(), correct: true, now: d1);
    s = applyAnswer(s, correct: false, now: d1);
    expect(s.streak, 1);
  });
}
