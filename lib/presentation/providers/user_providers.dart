import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/saved_simulation.dart';
import 'infra_providers.dart';

final favoritesProvider = StreamProvider<Set<String>>(
  (ref) => ref.watch(userRepositoryProvider).watchFavorites(),
);

final simulationsProvider = StreamProvider<List<SavedSimulation>>(
  (ref) => ref.watch(userRepositoryProvider).watchSimulations(),
);
