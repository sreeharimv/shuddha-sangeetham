import 'package:flutter/material.dart';

/// Bookmarks tab — placeholder for Session 7 (Bookmarks Screen).
///
/// Will show locally saved krithis, sorted by most recently bookmarked.
class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_border, size: 64, color: cs.primary.withAlpha(100)),
            const SizedBox(height: 16),
            Text(
              'Bookmarks — Session 7',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: cs.primary.withAlpha(150)),
            ),
            const SizedBox(height: 8),
            Text(
              'Your saved krithis will appear here.\nNo account needed — stored on device.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
