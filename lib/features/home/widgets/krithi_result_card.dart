import 'package:flutter/material.dart';

import '../../../data/models/krithi_search_result.dart';

/// Result card shown in search results and the idle featured list.
///
/// In lyrics-search mode, [result.lyricsSnippet] is shown as a preview line.
class KrithiResultCard extends StatelessWidget {
  const KrithiResultCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  final KrithiSearchResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final semanticLabel = '${result.name}, '
        'Raga ${result.ragaName}, '
        'Composer ${result.composerName}, '
        'Tala ${result.talaName}';

    return Semantics(
      label: semanticLabel,
      button: true,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.name,
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Raga: ${result.ragaName}  ·  Tala: ${result.talaName}',
                        style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${result.composerName}  ·  ${result.language}',
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant.withAlpha(180),
                        ),
                      ),
                      if (result.lyricsSnippet != null &&
                          result.lyricsSnippet!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer.withAlpha(80),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _trimSnippet(result.lyricsSnippet!),
                            style: tt.bodySmall?.copyWith(
                              color: cs.onPrimaryContainer,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: cs.onSurfaceVariant.withAlpha(120),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Trims the snippet to a single representative line for compact display.
  String _trimSnippet(String snippet) {
    final firstLine = snippet
        .split(RegExp(r'[\n\r]'))
        .map((l) => l.trim())
        .firstWhere((l) => l.isNotEmpty, orElse: () => snippet);
    return firstLine.length > 120 ? '${firstLine.substring(0, 120)}…' : firstLine;
  }
}
