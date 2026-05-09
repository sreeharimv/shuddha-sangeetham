import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_logo.dart';
import '../../krithi/screens/krithi_detail_screen.dart';
import '../providers/home_search_provider.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/krithi_result_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeSearchProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      // Keep AppBar minimal — the search bar IS the main action.
      appBar: AppBar(
        titleSpacing: 12,
        title: const Row(
          children: [
            AppLogo(size: 36),
            SizedBox(width: 10),
            Text(AppConstants.appName),
          ],
        ),
        actions: [
          // Search mode toggle pill
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _ModeToggle(
              mode: state.mode,
              onChanged: (m) {
                ref.read(homeSearchProvider.notifier).setMode(m);
                // Re-focus so user can keep typing
                _searchFocus.requestFocus();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search bar ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: SearchBar(
                    controller: _searchCtrl,
                    focusNode: _searchFocus,
                    hintText: state.mode == SearchMode.quick
                        ? 'Search name, raga, composer…'
                        : 'Search lyrics phrase…',
                    leading: state.isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: cs.primary,
                              ),
                            ),
                          )
                        : const Icon(Icons.search),
                    trailing: _searchCtrl.text.isNotEmpty
                        ? [
                            IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: 'Clear',
                              onPressed: () {
                                _searchCtrl.clear();
                                ref.read(homeSearchProvider.notifier).setQuery('');
                              },
                            )
                          ]
                        : null,
                    elevation: const WidgetStatePropertyAll(0),
                    backgroundColor: WidgetStatePropertyAll(
                      cs.surfaceContainerHighest,
                    ),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 8),
                    ),
                    onChanged: (v) {
                      ref.read(homeSearchProvider.notifier).setQuery(v);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Filter button — shows badge when filters are active
                _FilterButton(
                  hasActiveFilters: !state.filter.isEmpty,
                  onTap: () => _openFilterSheet(context, state),
                ),
              ],
            ),
          ),

          // ── Active filter chips ──────────────────────────────────────────
          if (!state.filter.isEmpty)
            _ActiveFilterChips(
              filter: state.filter,
              onRemove: (updated) {
                ref.read(homeSearchProvider.notifier).applyFilter(updated);
              },
              onClearAll: () {
                ref.read(homeSearchProvider.notifier).clearAllFilters();
              },
            ),

          // ── Results / idle body ──────────────────────────────────────────
          Expanded(
            child: state.isIdle
                ? _IdleBody(mode: state.mode)
                : _ResultsList(state: state),
          ),
        ],
      ),
    );
  }

  Future<void> _openFilterSheet(BuildContext context, HomeSearchState state) async {
    final result = await showFilterBottomSheet(
      context,
      initial: state.filter,
    );
    if (result != null && mounted) {
      ref.read(homeSearchProvider.notifier).applyFilter(result);
    }
  }
}

// ---------------------------------------------------------------------------
// Mode toggle pill (Quick / Lyrics)
// ---------------------------------------------------------------------------

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onChanged});

  final SearchMode mode;
  final void Function(SearchMode) onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Pill(
            label: 'Quick',
            icon: Icons.bolt,
            selected: mode == SearchMode.quick,
            onTap: () => onChanged(SearchMode.quick),
          ),
          _Pill(
            label: 'Lyrics',
            icon: Icons.music_note,
            selected: mode == SearchMode.lyrics,
            onTap: () => onChanged(SearchMode.lyrics),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: selected ? cs.onPrimary : cs.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: selected ? cs.onPrimary : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter button with active badge
// ---------------------------------------------------------------------------

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.hasActiveFilters, required this.onTap});
  final bool hasActiveFilters;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onTap,
          tooltip: 'Filters',
          icon: Icon(
            hasActiveFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
            color: hasActiveFilters ? cs.primary : cs.onSurfaceVariant,
          ),
          style: IconButton.styleFrom(
            backgroundColor: hasActiveFilters
                ? cs.primaryContainer
                : cs.surfaceContainerHighest,
            minimumSize: const Size(48, 48),
          ),
        ),
        if (hasActiveFilters)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: cs.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Active filter chips row
// ---------------------------------------------------------------------------

class _ActiveFilterChips extends StatelessWidget {
  const _ActiveFilterChips({
    required this.filter,
    required this.onRemove,
    required this.onClearAll,
  });

  final FilterState filter;
  final void Function(FilterState updated) onRemove;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];

    if (filter.ragaName != null) {
      chips.add(_chip(context, 'Raga: ${filter.ragaName}',
          () => onRemove(filter.copyWith(clearRaga: true))));
    }
    if (filter.composerName != null) {
      chips.add(_chip(context, filter.composerName!,
          () => onRemove(filter.copyWith(clearComposer: true))));
    }
    if (filter.talaName != null) {
      chips.add(_chip(context, 'Tala: ${filter.talaName}',
          () => onRemove(filter.copyWith(clearTala: true))));
    }
    if (filter.language != null) {
      chips.add(_chip(context, filter.language!,
          () => onRemove(filter.copyWith(clearLanguage: true))));
    }
    if (filter.compositionType != null) {
      chips.add(_chip(context, filter.compositionType!,
          () => onRemove(filter.copyWith(clearType: true))));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...chips,
            if (chips.length > 1)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: ActionChip(
                  label: const Text('Clear all'),
                  onPressed: onClearAll,
                  avatar: const Icon(Icons.close, size: 14),
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, String label, VoidCallback onDelete) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        deleteIcon: const Icon(Icons.close, size: 14),
        onDeleted: onDelete,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Results list
// ---------------------------------------------------------------------------

class _ResultsList extends StatelessWidget {
  const _ResultsList({required this.state});
  final HomeSearchState state;

  @override
  Widget build(BuildContext context) {
    final results = state.results;

    if (results.isEmpty && !state.isLoading) {
      return _EmptyResults(query: state.query, mode: state.mode);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
      itemCount: results.length,
      itemBuilder: (context, i) {
        final r = results[i];
        return KrithiResultCard(
          result: r,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => KrithiDetailScreen(krithiId: r.id),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Idle body — shown when no query is active and no filters applied
// ---------------------------------------------------------------------------

class _IdleBody extends StatelessWidget {
  const _IdleBody({required this.mode});
  final SearchMode mode;

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
            const AppLogo(size: 120, circular: true),
            const SizedBox(height: 24),
            Text(
              mode == SearchMode.quick
                  ? 'Search by name, raga,\nor composer'
                  : 'Search lyrics — type a phrase\nyou just heard',
              textAlign: TextAlign.center,
              style: tt.titleSmall?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Type at least ${AppConstants.searchMinChars} characters',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant.withAlpha(150)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty results state
// ---------------------------------------------------------------------------

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.query, required this.mode});
  final String query;
  final SearchMode mode;

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
            Icon(Icons.search_off, size: 48, color: cs.onSurfaceVariant.withAlpha(120)),
            const SizedBox(height: 16),
            Text(
              'No results for "$query"',
              textAlign: TextAlign.center,
              style: tt.titleSmall?.copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              mode == SearchMode.quick
                  ? 'Try a different spelling — e.g. "Bhairawi" for Bhairavi,\nor "Thyagaraja" for Tyagaraja.'
                  : 'Try a different phrase from the lyrics.',
              textAlign: TextAlign.center,
              style: tt.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
