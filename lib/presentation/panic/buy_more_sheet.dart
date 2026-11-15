import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

const _maxAmount = 1000000.0;

/// Bottom sheet asking how much to add. Returns the amount, or null if the
/// user cancels. [startingAmount] is used for the quick-pick percentages.
Future<double?> askBuyMoreAmount(BuildContext context, double startingAmount) {
  return showModalBottomSheet<double>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _BuyMoreSheet(startingAmount: startingAmount),
  );
}

class _BuyMoreSheet extends StatefulWidget {
  const _BuyMoreSheet({required this.startingAmount});

  final double startingAmount;

  @override
  State<_BuyMoreSheet> createState() => _BuyMoreSheetState();
}

class _BuyMoreSheetState extends State<_BuyMoreSheet> {
  static const _shares = [0.05, 0.10, 0.25, 0.50];

  final _formKey = GlobalKey<FormState>();
  late final _controller = TextEditingController(
    text: (widget.startingAmount * 0.10).toStringAsFixed(0),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    final amount = double.tryParse((value ?? '').trim().replaceAll(',', '.'));
    if (amount == null) return 'Enter a valid number';
    if (amount <= 0) return 'The amount must be greater than 0';
    if (amount > _maxAmount) return 'Maximum is 1,000,000';
    return null;
  }

  void _confirm() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(
      context,
    ).pop(double.parse(_controller.text.trim().replaceAll(',', '.')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How much do you add?',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text('Fictional money, bought at this week\'s price.'),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final share in _shares)
                  ActionChip(
                    label: Text('${(share * 100).round()} % of start'),
                    onPressed: () => setState(
                      () => _controller.text = (widget.startingAmount * share)
                          .toStringAsFixed(0),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _validate,
              decoration: const InputDecoration(
                labelText: 'Amount to add',
                prefixText: '€ ',
              ),
              onFieldSubmitted: (_) => _confirm(),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(onPressed: _confirm, child: const Text('Buy')),
          ],
        ),
      ),
    );
  }
}
