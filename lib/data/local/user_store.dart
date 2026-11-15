import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/models/quiz_stats.dart';
import '../../domain/models/saved_simulation.dart';
import 'database.dart';

/// Persistence of user data (favourites, simulations, stats, preferences).
class UserStore {
  UserStore(this._db);

  final AppDatabase _db;

  // Favourites
  Stream<Set<String>> watchFavorites() => _db
      .select(_db.favorites)
      .watch()
      .map((rows) => {for (final r in rows) r.symbol});

  Future<void> setFavorite(String symbol, bool value) async {
    if (value) {
      await _db
          .into(_db.favorites)
          .insertOnConflictUpdate(
            FavoritesCompanion.insert(symbol: symbol, addedAt: DateTime.now()),
          );
    } else {
      await (_db.delete(
        _db.favorites,
      )..where((t) => t.symbol.equals(symbol))).go();
    }
  }

  // Simulations
  Stream<List<SavedSimulation>> watchSimulations() =>
      (_db.select(
        _db.simulations,
      )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch().map(
        (rows) => [
          for (final r in rows)
            SavedSimulation(
              id: r.id,
              kind: SimulationKind.values.byName(r.kind),
              title: r.title,
              createdAt: r.createdAt,
              payload: Map<String, String>.from(jsonDecode(r.payload) as Map),
            ),
        ],
      );

  Future<void> saveSimulation(
    SimulationKind kind,
    String title,
    Map<String, String> payload,
  ) async {
    await _db
        .into(_db.simulations)
        .insert(
          SimulationsCompanion.insert(
            kind: kind.name,
            title: title,
            payload: jsonEncode(payload),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<void> deleteSimulation(int id) =>
      (_db.delete(_db.simulations)..where((t) => t.id.equals(id))).go();

  // Quiz stats
  Future<QuizStats> readQuizStats() async {
    final r = await (_db.select(
      _db.quizStatsRows,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (r == null) return const QuizStats();
    return QuizStats(
      correct: r.correct,
      answered: r.answered,
      streak: r.streak,
      bestStreak: r.bestStreak,
      lastPlayed: r.lastPlayed,
    );
  }

  Future<void> writeQuizStats(QuizStats s) => _db
      .into(_db.quizStatsRows)
      .insertOnConflictUpdate(
        QuizStatsRowsCompanion.insert(
          id: const Value(1),
          correct: Value(s.correct),
          answered: Value(s.answered),
          streak: Value(s.streak),
          bestStreak: Value(s.bestStreak),
          lastPlayed: Value(s.lastPlayed),
        ),
      );

  // Preferences
  Future<Map<String, String>> readPreferences() async {
    final rows = await _db.select(_db.preferences).get();
    return {for (final r in rows) r.key: r.value};
  }

  Future<void> writePreference(String key, String value) => _db
      .into(_db.preferences)
      .insertOnConflictUpdate(
        PreferencesCompanion.insert(key: key, value: value),
      );

  /// Erases everything the user created (GDPR right to erasure).
  Future<void> deleteAllUserData() async {
    await _db.transaction(() async {
      await _db.delete(_db.favorites).go();
      await _db.delete(_db.simulations).go();
      await _db.delete(_db.preferences).go();
      await _db.delete(_db.quizStatsRows).go();
    });
  }
}
