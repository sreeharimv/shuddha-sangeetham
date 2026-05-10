import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/widgets/krithi_result_card.dart';
import '../../krithi/screens/krithi_detail_screen.dart';
import '../providers/bookmarks_provider.dart';

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookmarksProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) =>
                  ref.read(bookmarksProvider.notifier).setQuery(v),
              decoration: InputDecoration(
                hintText: 'Search bookmarks…',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: state.query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          ref
                              .read(bookmarksProvider.notifier)
                              .setQuery('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: cs.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                isDense: true,
              ),
            ),
          ),
        ),
      ),
      body: _BookmarksBody(state: state),
    );
  }
}

// ---------------------------------------------------------------------------
// Body
// ---------------------------------------------------------------------------

class _BookmarksBody extends ConsumerWidget {
  const _BookmarksBody({required this.state});

  final BookmarksState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.items.isEmpty) {
      return _EmptyState(hasQuery: state.query.isNotEmpty);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      itemCount: state.items.length,
      itemBuilder: (context, i) {
        final result = state.items[i];
        return Dismissible(
          key: ValueKey(result.id),
          direction: DismissDirection.endToStart,
          background: _SwipeBackground(),
          onDismissed: (_) {
            ref.read(bookmarksProvider.notifier).remove(result.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Removed "\${result.name}" from bookmarks'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: KrithiResultCard(
            result: result,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => KrithiDetailScreen(krithiId: result.id),
                ),
              );
              // Refresh in case the user toggled the bookmark on detail page.
              ref.read(bookmarksProvider.notifier).refresh();
            },
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Swipe-to-delete background
// ---------------------------------------------------------------------------

class _SwipeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: Icon(Icons.bookmark_remove, color: cs.onErrorContainer),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasQuery});

  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: cs.onSurfaceVariant.withAlpha(100),
            ),
            const SizedBox(height: 16),
            Text(
              hasQuery ? 'No bookmarks match your search' : 'No bookmarks yet',
              style: tt.titleSmall?.copyWith(color: cs.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              hasQuery
                  ? 'Try a different search term.'
                  : 'Tap the bookmark icon on any krithi to save it here.',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
