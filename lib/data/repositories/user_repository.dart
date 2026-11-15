import '../../domain/calculations/streak.dart';
import '../../domain/models/quiz_stats.dart';
import '../../domain/models/saved_simulation.dart';
import '../local/user_store.dart';

/// Favourites, saved simulations and quiz progress.
class UserRepository {
  UserRepository(this._store);

  final UserStore _store;

  Stream<Set<String>> watchFavorites() => _store.watchFavorites();
  Future<void> setFavorite(String symbol, bool value) =>
      _store.setFavorite(symbol, value);

  Stream<List<SavedSimulation>> watchSimulations() => _store.watchSimulations();
  Future<void> saveSimulation(
    SimulationKind kind,
    String title,
    Map<String, String> payload,
  ) => _store.saveSimulation(kind, title, payload);
  Future<void> deleteSimulation(int id) => _store.deleteSimulation(id);

  Future<QuizStats> quizStats() => _store.readQuizStats();

  Future<QuizStats> recordAnswer({required bool correct}) async {
    final updated = applyAnswer(
      await _store.readQuizStats(),
      correct: correct,
      now: DateTime.now(),
    );
    await _store.writeQuizStats(updated);
    return updated;
  }
}
