import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_info.dart';
import '../../core/legal/legal_documents.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/school_badge.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/state_views.dart';
import '../../data/repositories/settings_repository.dart';
import '../providers/infra_providers.dart';
import '../quiz/quiz_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: AsyncValueView<AppSettings>(
        value: settings,
        onRetry: () => ref.invalidate(settingsProvider),
        data: (s) => _Body(settings: s),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.settings});

  final AppSettings settings;

  void _update(WidgetRef ref, AppSettings Function(AppSettings) change) =>
      ref.read(settingsProvider.notifier).apply(change);

  void _snack(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _clearCache(BuildContext context, WidgetRef ref) async {
    await ref.read(marketRepositoryProvider).clearCache();
    if (context.mounted) _snack(context, 'Downloaded price data cleared');
  }

  Future<void> _deleteAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete all my data?'),
        content: const Text(
          'Favorites, saved simulations, quiz progress, preferences and downloaded '
          'prices will be erased from this device. You will be asked to accept the '
          'legal documents again. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.loss),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(legalProvider.notifier).deleteEverything();
      ref.invalidate(quizControllerProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final accepted = ref.watch(legalProvider).value?.acceptedAt;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AppCard(
          onTap: () => context.push(Routes.glossary()),
          child: const Row(
            children: [
              Icon(Icons.menu_book_outlined),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Glossary: investing terms explained',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionTitle('Appearance'),
        const SizedBox(height: AppSpacing.sm + 2),
        AppCard(
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'system', label: Text('System')),
                ButtonSegment(value: 'light', label: Text('Light')),
                ButtonSegment(value: 'dark', label: Text('Dark')),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (v) =>
                  _update(ref, (x) => x.copyWith(themeMode: v.first)),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionTitle('Display currency'),
        const SizedBox(height: AppSpacing.sm + 2),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<DisplayCurrency>(
                  segments: const [
                    ButtonSegment(
                      value: DisplayCurrency.usd,
                      label: Text('US dollar'),
                    ),
                    ButtonSegment(
                      value: DisplayCurrency.eur,
                      label: Text('Euro'),
                    ),
                  ],
                  selected: {settings.currency},
                  onSelectionChanged: (v) =>
                      _update(ref, (x) => x.copyWith(currency: v.first)),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Euro mode converts the prices on asset sheets with historical USD/EUR rates. '
                'The quiz, the Risk clock and the Panic button always work in US dollars or in percentages.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionTitle('Data sources'),
        const SizedBox(height: AppSpacing.sm + 2),
        const AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SourceRow(
                title: 'Yahoo Finance',
                text:
                    'Historical prices of stocks, ETFs and cryptocurrencies '
                    '(daily and weekly closing prices) and the USD/EUR exchange rate. '
                    'No account or API key needed.',
              ),
              SizedBox(height: AppSpacing.md),
              _SourceRow(
                title: 'Bundled crash data',
                text:
                    'Weekly prices of the S&P 500 (2020) and Bitcoin (2021-2022) '
                    'used by the Panic button, stored inside the app.',
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'Prices are raw closing prices (not adjusted for dividends or splits). '
                'Data may be delayed, incomplete or inaccurate. Yahoo Finance is an '
                'independent third party, not affiliated with Boussole.',
                style: TextStyle(fontSize: 12, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionTitle('Legal and privacy'),
        const SizedBox(height: AppSpacing.sm + 2),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final doc in LegalDocuments.all) ...[
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(
                    doc.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(doc.summary),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push(Routes.legal(doc.id)),
                ),
                const Divider(),
              ],
              ListTile(
                leading: const Icon(Icons.code_rounded),
                title: const Text(
                  'Open-source licences',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: AppInfo.name,
                  applicationVersion: AppInfo.version,
                  applicationLegalese: AppInfo.copyright,
                ),
              ),
            ],
          ),
        ),
        if (accepted != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              'You accepted version ${LegalDocuments.version} on ${Fmt.dateTime(accepted)}.',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        const SectionTitle('Storage'),
        const SizedBox(height: AppSpacing.sm + 2),
        OutlinedButton.icon(
          onPressed: () => _clearCache(context, ref),
          icon: const Icon(Icons.cleaning_services_outlined),
          label: const Text('Clear downloaded price data'),
        ),
        const SizedBox(height: AppSpacing.sm + 2),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(foregroundColor: AppColors.loss),
          onPressed: () => _deleteAll(context, ref),
          icon: const Icon(Icons.delete_forever_outlined),
          label: const Text('Delete all my data'),
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'Everything is stored on this device only. Nothing is sent to the developer.',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionTitle('Important'),
        const SizedBox(height: AppSpacing.sm + 2),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Not a banking or advisory app',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm + 2),
              const Text(
                'Boussole is not a bank, a broker or a financial adviser, and no real '
                'transaction is possible. It is provided for information and education '
                'only. Its figures are based on past data retrieved from third-party '
                'APIs, which may be late, incomplete or wrong, and they do not predict '
                'the future.\n\n'
                'The app represents what its developer understood, based on his '
                'personal experience and research. Please keep this in mind.\n\n'
                'Nothing in this app is investment advice. Investing involves risk, '
                'including the loss of all the capital invested. You alone are '
                'responsible for your decisions. The developer cannot be held '
                'responsible for any loss of money, capital, profit or any other '
                'damage resulting from the use of this app or its data.',
                style: TextStyle(height: 1.45, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionTitle('About'),
        const SizedBox(height: AppSpacing.sm + 2),
        AppCard(
          child: Column(
            children: [
              Image.asset('assets/images/logo-text.png', height: 120),
              const Text(
                'Version ${AppInfo.version}',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Developed by ${AppInfo.developer}',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppInfo.copyright,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const SchoolBadge(),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(text, style: const TextStyle(height: 1.4)),
      ],
    );
  }
}
