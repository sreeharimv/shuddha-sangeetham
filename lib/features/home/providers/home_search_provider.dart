import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/krithi_search_result.dart';
import '../../../data/providers/search_provider.dart';

// ---------------------------------------------------------------------------
// Search mode
// ---------------------------------------------------------------------------

enum SearchMode { quick, lyrics }

// ---------------------------------------------------------------------------
// Active filter state — all fields nullable = "no filter applied"
// ---------------------------------------------------------------------------

class FilterState {
  const FilterState({
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

  FilterState copyWith({
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
    return FilterState(
      ragaId: clearRaga ? null : (ragaId ?? this.ragaId),
      ragaName: clearRaga ? null : (ragaName ?? this.ragaName),
      composerId: clearComposer ? null : (composerId ?? this.composerId),
      composerName: clearComposer ? null : (composerName ?? this.composerName),
      talaId: clearTala ? null : (talaId ?? this.talaId),
      talaName: clearTala ? null : (talaName ?? this.talaName),
      language: clearLanguage ? null : (language ?? this.language),
      compositionType: clearType ? null : (compositionType ?? this.compositionType),
    );
  }

  FilterState cleared() => const FilterState();
}

// ---------------------------------------------------------------------------
// Home search state
// ---------------------------------------------------------------------------

class HomeSearchState {
  const HomeSearchState({
    this.query = '',
    this.mode = SearchMode.quick,
    this.filter = const FilterState(),
    this.results = const [],
    this.isLoading = false,
  });

  final String query;
  final SearchMode mode;
  final FilterState filter;
  final List<KrithiSearchResult> results;
  final bool isLoading;

  /// True when there is no active search query and no filters applied.
  bool get isIdle => query.length < AppConstants.searchMinChars && filter.isEmpty;

  HomeSearchState copyWith({
    String? query,
    SearchMode? mode,
    FilterState? filter,
    List<KrithiSearchResult>? results,
    bool? isLoading,
  }) {
    return HomeSearchState(
      query: query ?? this.query,
      mode: mode ?? this.mode,
      filter: filter ?? this.filter,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier (Riverpod 3.x — extends Notifier)
// ---------------------------------------------------------------------------

class HomeSearchNotifier extends Notifier<HomeSearchState> {
  Timer? _debounce;

  @override
  HomeSearchState build() => const HomeSearchState();

  void setQuery(String query) {
    state = state.copyWith(query: query, isLoading: true);
    _debounce?.cancel();

    if (query.length < AppConstants.searchMinChars) {
      state = state.copyWith(results: [], isLoading: false);
      return;
    }

    final delay = state.mode == SearchMode.lyrics
        ? const Duration(milliseconds: AppConstants.lyricsSearchDebounceMs)
        : const Duration(milliseconds: AppConstants.searchDebounceMs);

    _debounce = Timer(delay, () => _runSearch(query));
  }

  void setMode(SearchMode mode) {
    if (mode == state.mode) return;
    state = state.copyWith(mode: mode, results: [], isLoading: false);
    if (state.query.length >= AppConstants.searchMinChars) {
      _runSearch(state.query);
    }
  }

  void applyFilter(FilterState filter) {
    state = state.copyWith(filter: filter, isLoading: true);
    _runFilterSearch(filter);
  }

  void clearAllFilters() {
    state = state.copyWith(filter: const FilterState(), isLoading: false);
    if (state.query.length >= AppConstants.searchMinChars) {
      _runSearch(state.query);
    } else {
      state = state.copyWith(results: []);
    }
  }

  Future<void> _runSearch(String query) async {
    final repo = ref.read(searchRepositoryProvider);
    try {
      final results = state.mode == SearchMode.lyrics
          ? await repo.lyricsSearch(query)
          : await repo.quickSearch(query);
      state = state.copyWith(results: results, isLoading: false);
    } catch (_) {
      state = state.copyWith(results: [], isLoading: false);
    }
  }

  Future<void> _runFilterSearch(FilterState filter) async {
    final repo = ref.read(searchRepositoryProvider);
    try {
      final results = await repo.filterSearch(
        ragaId: filter.ragaId,
        composerId: filter.composerId,
        talaId: filter.talaId,
        language: filter.language,
        compositionType: filter.compositionType,
      );
      state = state.copyWith(results: results, isLoading: false);
    } catch (_) {
      state = state.copyWith(results: [], isLoading: false);
    }
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final homeSearchProvider =
    NotifierProvider<HomeSearchNotifier, HomeSearchState>(
  HomeSearchNotifier.new,
);
