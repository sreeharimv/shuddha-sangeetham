import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Home tab — placeholder for Session 4 (Search UI).
///
/// Prominent search bar is shown as a structural placeholder.
/// All search logic is wired up in Session 4.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shuddha Sangeetham'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar placeholder — will be functional in Session 4.
            SearchBar(
              hintText: 'Search krithis, ragas, composers…',
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(
                cs.surfaceContainerHighest,
              ),
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            const SizedBox(height: 24),
            _PlaceholderBody(color: cs.primary),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderBody extends StatelessWidget {
  const _PlaceholderBody({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.music_note, size: 64, color: color.withAlpha(100)),
            const SizedBox(height: 16),
            Text(
              'Search UI — Session 4',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: color.withAlpha(150)),
            ),
            const SizedBox(height: 8),
            Text(
              'Featured krithis and quick filters\nwill appear here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.teal700.withAlpha(120),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
