import 'package:flutter/material.dart';

/// Profile / Settings tab — placeholder for Session 8.
///
/// Will contain dark mode toggle, text size selector, and About section.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline, size: 64, color: cs.primary.withAlpha(100)),
            const SizedBox(height: 16),
            Text(
              'Settings & Profile — Session 8',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: cs.primary.withAlpha(150)),
            ),
            const SizedBox(height: 8),
            Text(
              'Dark mode toggle, text size,\nand About (karnatik.com attribution).',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
