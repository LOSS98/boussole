import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_info.dart';
import '../../core/legal/legal_documents.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/school_badge.dart';
import '../providers/infra_providers.dart';

/// Shown at first launch (and after a legal update): the documents must be
/// accepted before the app can be used.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  Image.asset('assets/images/logo-text.png', height: 120),
                  Text(
                    'Before you start',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _Point(
                    icon: Icons.school_rounded,
                    text:
                        'Boussole is an educational app. It is not a bank, a broker or a financial adviser.',
                  ),
                  const _Point(
                    icon: Icons.psychology_alt_rounded,
                    text: AppInfo.authorNotice,
                  ),
                  const _Point(
                    icon: Icons.lightbulb_outline_rounded,
                    text:
                        'It shows past market data. It gives no advice and no guarantee about the future.',
                  ),
                  const _Point(
                    icon: Icons.money_off_rounded,
                    text:
                        'All simulations use fictional money. The developer cannot be held liable for any loss.',
                  ),
                  const _Point(
                    icon: Icons.lock_outline_rounded,
                    text:
                        'No account, no tracking. Your data stays on your device.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const SchoolBadge(),
                  const SizedBox(height: AppSpacing.md),
                  for (final doc in LegalDocuments.all)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: AppCard(
                        onTap: () => context.push(Routes.legal(doc.id)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    doc.summary,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Material(
              color: theme.colorScheme.surface,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: theme.dividerColor)),
                ),
                child: Column(
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _accepted,
                      onChanged: (v) => setState(() => _accepted = v ?? false),
                      title: const Text(
                        'I am 18 or older and I accept the Terms of Use, the Financial '
                        'Disclaimer and the Privacy Policy.',
                        style: TextStyle(fontSize: 13, height: 1.35),
                      ),
                    ),
                    FilledButton(
                      onPressed: _accepted
                          ? () => ref.read(legalProvider.notifier).accept()
                          : null,
                      child: const Text('Accept and continue'),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'If you do not accept, please close the app.',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
        ],
      ),
    );
  }
}
