import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/state_views.dart';
import '../../presentation/glossary/glossary_screen.dart';
import '../../presentation/legal/legal_document_screen.dart';
import '../../presentation/legal/welcome_screen.dart';
import '../../presentation/providers/infra_providers.dart';

import '../../presentation/asset_detail/asset_detail_screen.dart';
import '../../presentation/catalog/catalog_screen.dart';
import '../../presentation/panic/panic_screen.dart';
import '../../presentation/quiz/quiz_screen.dart';
import '../../presentation/risk_clock/risk_clock_screen.dart';
import '../../presentation/settings/settings_screen.dart';
import '../../presentation/shell/main_shell.dart';
import '../../presentation/simulations/simulations_screen.dart';

abstract final class Routes {
  static const catalog = '/catalog';
  static const quiz = '/quiz';
  static const riskClock = '/risk-clock';
  static const panic = '/panic';
  static const saved = '/saved';
  static const settings = '/settings';
  static const splash = '/splash';
  static const welcome = '/welcome';
  static String legal(String id) => '/legal/$id';
  static String glossary([String? term]) =>
      term == null ? '/glossary' : '/glossary?term=$term';
  static String asset(String symbol) => '/catalog/asset/$symbol';
}

final routerProvider = Provider<GoRouter>((ref) {
  // Re-evaluates the redirect whenever the legal acceptance changes.
  final refresh = ValueNotifier<int>(0);
  ref.listen(legalProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  final router = GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final legal = ref.read(legalProvider);
      final loc = state.matchedLocation;
      final bool? accepted = legal.hasValue
          ? legal.requireValue.isCurrent
          : (legal.hasError ? false : null);
      if (accepted == null) return loc == Routes.splash ? null : Routes.splash;
      if (!accepted) {
        final allowed = loc == Routes.welcome || loc.startsWith('/legal/');
        return allowed ? null : Routes.welcome;
      }
      if (loc == Routes.welcome || loc == Routes.splash) return Routes.catalog;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (_, _) => const Scaffold(body: LoadingView()),
      ),
      GoRoute(path: Routes.welcome, builder: (_, _) => const WelcomeScreen()),
      GoRoute(
        path: '/glossary',
        builder: (_, state) =>
            GlossaryScreen(term: state.uri.queryParameters['term']),
      ),
      GoRoute(
        path: '/legal/:id',
        builder: (_, state) =>
            LegalDocumentScreen(id: state.pathParameters['id']!),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.catalog,
                builder: (_, _) => const CatalogScreen(),
                routes: [
                  GoRoute(
                    path: 'asset/:symbol',
                    builder: (_, state) => AssetDetailScreen(
                      symbol: state.pathParameters['symbol']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.quiz, builder: (_, _) => const QuizScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.riskClock,
                builder: (_, _) => const RiskClockScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.panic,
                builder: (_, _) => const PanicScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.saved,
                builder: (_, _) => const SimulationsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: Routes.settings, builder: (_, _) => const SettingsScreen()),
    ],
    errorBuilder: (_, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
  ref.onDispose(router.dispose);
  return router;
});
