import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/krithi_detail_repository.dart';
import '../providers/krithi_detail_provider.dart';

class KrithiDetailScreen extends ConsumerWidget {
  const KrithiDetailScreen({super.key, required this.krithiId});

  final int krithiId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(krithiDetailProvider(krithiId));
    final bookmarkAsync = ref.watch(bookmarkNotifierProvider(krithiId));

    return Scaffold(
      appBar: AppBar(
        title: detailAsync.when(
          data: (d) => Text(d?.name ?? ''),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const Text('Error'),
        ),
        actions: [
          bookmarkAsync.when(
            data: (isBookmarked) => IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              ),
              tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark',
              onPressed: () =>
                  ref.read(bookmarkNotifierProvider(krithiId).notifier).toggle(),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (detail) {
          if (detail == null) {
            return const Center(child: Text('Krithi not found.'));
          }
          return _KrithiDetailBody(detail: detail);
        },
      ),
    );
  }
}

class _KrithiDetailBody extends StatelessWidget {
  const _KrithiDetailBody({required this.detail});

  final KrithiDetail detail;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header card ─────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.name,
                    style: tt.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _MetaRow(label: 'Composer', value: detail.composerName),
                  _MetaRow(label: 'Raga', value: detail.ragaName),
                  _MetaRow(label: 'Tala', value: detail.talaName),
                  _MetaRow(label: 'Language', value: _titleCase(detail.language)),
                  _MetaRow(
                    label: 'Type',
                    value: _titleCase(detail.compositionType),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── karnatik.com link ────────────────────────────────────
          if (detail.sourceUrl != null && detail.sourceUrl!.isNotEmpty)
            OutlinedButton.icon(
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('View on karnatik.com'),
              style: OutlinedButton.styleFrom(
                foregroundColor: cs.primary,
                side: BorderSide(color: cs.primary.withAlpha(100)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              onPressed: () => _openUrl(context, detail.sourceUrl!),
            ),

          const SizedBox(height: 20),

          // ── Lyrics ───────────────────────────────────────────────
          _SectionLabel(label: 'PALLAVI'),
          const SizedBox(height: 6),
          _LyricsBlock(text: detail.pallavi),

          if (detail.anupallavi != null &&
              detail.anupallavi!.trim().isNotEmpty) ...[
            const SizedBox(height: 20),
            _SectionLabel(label: 'ANUPALLAVI'),
            const SizedBox(height: 6),
            _LyricsBlock(text: detail.anupallavi!),
          ],

          if (detail.charanam != null &&
              detail.charanam!.trim().isNotEmpty) ...[
            const SizedBox(height: 20),
            _SectionLabel(label: 'CHARANAM'),
            const SizedBox(height: 6),
            _LyricsBlock(text: detail.charanam!),
          ],

          const SizedBox(height: 32),

          // ── Performances — placeholder ───────────────────────────
          _SectionLabel(label: 'PERFORMANCES'),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withAlpha(80),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: cs.outlineVariant.withAlpha(100),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.music_note_outlined,
                  size: 36,
                  color: cs.onSurfaceVariant.withAlpha(100),
                ),
                const SizedBox(height: 8),
                Text(
                  'Coming soon',
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant.withAlpha(160),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link.')),
        );
      }
    }
  }

  String _titleCase(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: tt.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: tt.bodySmall?.copyWith(color: cs.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      label,
      style: AppTextStyles.sectionLabel.copyWith(
        color: cs.primary,
        letterSpacing: 1.8,
      ),
    );
  }
}

class _LyricsBlock extends StatelessWidget {
  const _LyricsBlock({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      text.trim(),
      style: AppTextStyles.lyricsStyle.copyWith(
        color: cs.onSurface,
      ),
    );
  }
}
