import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';

/// App bar button opening the glossary, optionally on a given term.
class GlossaryButton extends StatelessWidget {
  const GlossaryButton({super.key, this.term});

  final String? term;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Glossary',
      icon: const Icon(Icons.menu_book_outlined),
      onPressed: () => context.push(Routes.glossary(term)),
    );
  }
}
