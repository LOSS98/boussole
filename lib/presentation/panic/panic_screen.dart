import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/glossary_button.dart';
import '../../core/widgets/state_views.dart';
import 'panic_controller.dart';
import 'panic_finished_view.dart';
import 'panic_play_view.dart';
import 'panic_setup_view.dart';

class PanicScreen extends ConsumerWidget {
  const PanicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(panicControllerProvider);
    final controller = ref.read(panicControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panic button'),
        actions: [
          const GlossaryButton(term: 'crash'),
          if (state.sim != null)
            TextButton(onPressed: controller.reset, child: const Text('Quit')),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: state.loading
            ? const LoadingView()
            : state.isFinished
            ? PanicFinishedView(state: state)
            : state.isPlaying
            ? PanicPlayView(state: state)
            : PanicSetupView(error: state.error),
      ),
    );
  }
}
