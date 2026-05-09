import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/krithi_search_result.dart';
import '../../../data/providers/database_provider.dart';
import '../../../data/repositories/browse_repository.dart';

// ---------------------------------------------------------------------------
// Browse filter state
// ---------------------------------------------------------------------------

class BrowseFilterState {
  const BrowseFilterState({
    this.ragaId,
    this.ragaName,
    this.composerId,
    this.composerName,
    this.talaId,
    this.talaName,
    this.language,
    this.compositionType,
  });

  final int? ragaId;
  final String? ragaName;
  final int? composerId;
  final String? composerName;
  final int? talaId;
  final String? talaName;
  final String? language;
  final String? compositionType;

  bool get isEmpty =>
      ragaId == null &&
      composerId == null &&
      talaId == null &&
      language == null &&
      compositionType == null;

  BrowseFilterState copyWith({
    int? ragaId,
    String? ragaName,
    int? composerId,
    String? composerName,
    int? talaId,
    String? talaName,
    String? language,
    String? compositionType,
    bool clearRaga = false,
    bool clearComposer = false,
    bool clearTala = false,
    bool clearLanguage = false,
    bool clearType = false,
  }) {
    return BrowseFilterState(
      ragaId: clearRaga ? null : (ragaId ?? this.ragaId),
      ragaName: clearRaga ? null : (ragaName ?? this.ragaName),
      composerId: clearComposer ? null : (composerId ?? this.composerId),
      composerName: clearComposer ? null : (composerName ?? this.composerName),
      talaId: clearTala ? null : (talaId ?? this.talaId),
      talaName: clearTala ? null : (talaName ?? this.talaName),
      language: clearLanguage ? null : (language ?? this.language),
      compositionType:
          clearType ? null : (compositionType ?? this.compositionType),
    );
  }

  BrowseFilterState cleared() => const BrowseFilterState();
}

// ---------------------------------------------------------------------------
// Browse state
// ---------------------------------------------------------------------------

class BrowseState {
  const BrowseState({
    this.sort = BrowseSortOrder.nameAz,
    this.filter = const BrowseFilterState(),
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
  });

  final BrowseSortOrder sort;
  final BrowseFilterState filter;
  final List<KrithiSearchResult> items;
  final bool isLoading;
  final bool hasMore;

  BrowseState copyWith({
    BrowseSortOrder? sort,
    BrowseFilterState? filter,
    List<KrithiSearchResult>? items,
    bool? isLoading,
    bool? hasMore,
  }) {
    return BrowseState(
      sort: sort ?? this.sort,
      filter: filter ?? this.filter,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class BrowseNotifier extends Notifier<BrowseState> {
  @override
  BrowseState build() {
    Future.microtask(_loadFirstPage);
    return const BrowseState(isLoading: true);
  }

  BrowseRepository get _repo =>
      BrowseRepository(ref.read(databaseProvider));

  Future<void> _loadFirstPage() async {
    state = state.copyWith(items: [], isLoading: true, hasMore: true);
    try {
      final items = await _repo.browse(
        sort: state.sort,
        offset: 0,
        ragaId: state.filter.ragaId,
        composerId: state.filter.composerId,
        talaId: state.filter.talaId,
        language: state.filter.language,
        compositionType: state.filter.compositionType,
      );
      state = state.copyWith(
        items: items,
        isLoading: false,
        hasMore: items.length == BrowseRepository.pageSize,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false, hasMore: false);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true);
    try {
      final next = await _repo.browse(
        sort: state.sort,
        offset: state.items.length,
        ragaId: state.filter.ragaId,
        composerId: state.filter.composerId,
        talaId: state.filter.talaId,
        language: state.filter.language,
        compositionType: state.filter.compositionType,
      );
      state = state.copyWith(
        items: [...state.items, ...next],
        isLoading: false,
        hasMore: next.length == BrowseRepository.pageSize,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  void setSort(BrowseSortOrder sort) {
    if (sort == state.sort) return;
    state = state.copyWith(sort: sort);
    _loadFirstPage();
  }

  void applyFilter(BrowseFilterState filter) {
    state = state.copyWith(filter: filter);
    _loadFirstPage();
  }

  void clearFilter() {
    state = state.copyWith(filter: const BrowseFilterState());
    _loadFirstPage();
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final browseProvider =
    NotifierProvider<BrowseNotifier, BrowseState>(BrowseNotifier.new);

final browseRepositoryProvider = Provider<BrowseRepository>((ref) {
  return BrowseRepository(ref.watch(databaseProvider));
});
