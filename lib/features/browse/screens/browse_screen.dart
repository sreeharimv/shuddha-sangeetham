import 'package:flutter/material.dart';

/// Browse tab — placeholder for Session 5 (Browse Screen).
///
/// Will show the full krithi list with sort/filter options.
class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined, size: 64, color: cs.primary.withAlpha(100)),
            const SizedBox(height: 16),
            Text(
              'Krithi Browser — Session 5',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: cs.primary.withAlpha(150)),
            ),
            const SizedBox(height: 8),
            Text(
              'Alphabetical list of all krithis\nwith sort and filter options.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
