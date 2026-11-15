import 'package:flutter/material.dart';

import '../../core/glossary/glossary_entries.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';

/// All the jargon of the app, grouped by theme, searchable.
/// [term] (an entry id) is opened and scrolled into view when given.
class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key, this.term});

  final String? term;

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  final _keys = {for (final e in Glossary.entries) e.id: GlobalKey()};
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _keys[widget.term]?.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 400),
          alignment: 0.1,
        );
      }
    });
  }

  bool _matches(GlossaryEntry e) {
    final q = _query.trim().toLowerCase();
    return q.isEmpty ||
        e.term.toLowerCase().contains(q) ||
        e.definition.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visible = Glossary.entries.where(_matches).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Glossary')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        children: [
          TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Search a term',
              prefixIcon: Icon(Icons.search_rounded),
              contentPadding: EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (visible.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Center(child: Text('No term found.')),
            ),
          for (final category in GlossaryCategory.values) ...[
            if (visible.any((e) => e.category == category)) ...[
              Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.md,
                  bottom: AppSpacing.sm,
                ),
                child: Text(
                  category.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              for (final e in visible.where((e) => e.category == category))
                Padding(
                  key: _keys[e.id],
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _EntryCard(entry: e, expanded: e.id == widget.term),
                ),
            ],
          ],
        ],
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry, required this.expanded});

  final GlossaryEntry entry;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: expanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Text(
            entry.term,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          children: [
            Text(entry.definition, style: const TextStyle(height: 1.45)),
            const SizedBox(height: AppSpacing.sm + 2),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm + 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.explore_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      entry.inBoussole,
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
