import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/krithi_search_result.dart';
import '../../../data/providers/database_provider.dart';
import '../../../data/repositories/bookmarks_repository.dart';

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------

final bookmarksRepositoryProvider = Provider<BookmarksRepository>((ref) {
  return BookmarksRepository(ref.watch(databaseProvider));
});

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class BookmarksState {
  const BookmarksState({
    this.items = const [],
    this.query = '',
    this.isLoading = false,
  });

  final List<KrithiSearchResult> items;
  final String query;
  final bool isLoading;

  BookmarksState copyWith({
    List<KrithiSearchResult>? items,
    String? query,
    bool? isLoading,
  }) {
    return BookmarksState(
      items: items ?? this.items,
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class BookmarksNotifier extends Notifier<BookmarksState> {
  @override
  BookmarksState build() {
    _load();
    return const BookmarksState(isLoading: true);
  }

  BookmarksRepository get _repo => ref.read(bookmarksRepositoryProvider);

  Future<void> _load({String? query}) async {
    state = state.copyWith(isLoading: true);
    final items = await _repo.fetchBookmarks(query: query ?? state.query);
    state = state.copyWith(items: items, isLoading: false);
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
    _load(query: query);
  }

  /// Removes a bookmark optimistically and reloads.
  Future<void> remove(int krithiId) async {
    // Optimistic removal for instant swipe feedback.
    state = state.copyWith(
      items: state.items.where((r) => r.id != krithiId).toList(),
    );
    await _repo.removeBookmark(krithiId);
  }

  /// Called when returning from KrithiDetailScreen to refresh the list
  /// (the user may have toggled a bookmark there).
  Future<void> refresh() => _load();
}

final bookmarksProvider =
    NotifierProvider<BookmarksNotifier, BookmarksState>(BookmarksNotifier.new);
