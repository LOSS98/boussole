import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/brand_header.dart';
import '../../core/widgets/disclaimer_note.dart';
import '../../domain/models/crash_scenario.dart';
import 'panic_controller.dart';

class PanicSetupView extends ConsumerStatefulWidget {
  const PanicSetupView({super.key, this.error});

  final String? error;

  @override
  ConsumerState<PanicSetupView> createState() => _PanicSetupViewState();
}

class _PanicSetupViewState extends ConsumerState<PanicSetupView> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController(text: '1000');
  CrashScenario _scenario = crashScenarios.first;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    final text = (value ?? '').trim().replaceAll(',', '.');
    if (text.isEmpty) return 'Enter an amount';
    final amount = double.tryParse(text);
    if (amount == null) return 'Enter a valid number';
    if (amount <= 0) return 'The amount must be greater than 0';
    if (amount < 100) return 'Minimum is 100';
    if (amount > 1000000) return 'Maximum is 1,000,000';
    return null;
  }

  void _start() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amount.text.trim().replaceAll(',', '.'));
    ref.read(panicControllerProvider.notifier).start(_scenario, amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      key: const ValueKey('setup'),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: [
        const BrandHeader(
          title: 'Could you keep your cool?',
          subtitle:
              'Relive a real crash week by week. Hold, sell or buy more, '
              'then compare with doing nothing.',
          icon: Icons.crisis_alert_rounded,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          '1. Choose a crash',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm + 2),
        for (final s in crashScenarios)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              onTap: () => setState(() => _scenario = s),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    s == _scenario
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    color: s == _scenario ? theme.colorScheme.primary : null,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          s.assetName,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.story,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        Text(
          '2. Pick a virtual amount',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm + 2),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: _validate,
            decoration: const InputDecoration(
              labelText: 'Amount invested',
              prefixText: '€ ',
              helperText:
                  'Fictional euros, between 100 and 1,000,000. Only the % changes matter.',
            ),
            onFieldSubmitted: (_) => _start(),
          ),
        ),
        if (widget.error != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              widget.error!,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          onPressed: _start,
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Start the simulation'),
        ),
        const DisclaimerNote(
          text:
              'No real transaction happens. Past crashes do not predict future ones.',
        ),
      ],
    );
  }
}
