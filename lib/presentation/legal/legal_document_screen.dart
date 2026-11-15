import 'package:flutter/material.dart';

import '../../core/legal/legal_documents.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/state_views.dart';

class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final doc = LegalDocuments.byId(id);
    if (doc == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyView(
          icon: Icons.description_outlined,
          title: 'Document not found',
          message: 'This document does not exist.',
        ),
      );
    }
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(doc.title)),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          children: [
            Text(
              'Version ${LegalDocuments.version} · ${LegalDocuments.lastUpdated}',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.md),
            for (final s in doc.sections) ...[
              Text(
                s.heading,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final p in s.paragraphs)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
                  child: Text(p, style: const TextStyle(height: 1.5)),
                ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}
