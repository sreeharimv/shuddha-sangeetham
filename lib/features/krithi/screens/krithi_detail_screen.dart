import 'package:flutter/material.dart';

/// Krithi Detail Page — placeholder for Session 6.
///
/// Receives a [krithiId] and displays:
///   • Header: name, composer, raga, tala, language, type
///   • Bookmark button
///   • "View on karnatik.com" link
///   • Lyrics: pallavi / anupallavi / charanam(s)
class KrithiDetailScreen extends StatelessWidget {
  const KrithiDetailScreen({super.key, required this.krithiId});

  final int krithiId;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Krithi Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            tooltip: 'Bookmark',
            onPressed: () {
              // Wired up in Session 6
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Krithi #$krithiId\nFull detail page — Session 6',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: cs.primary.withAlpha(150)),
        ),
      ),
    );
  }
}
