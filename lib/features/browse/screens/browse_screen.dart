import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/providers/database_provider.dart';
import '../../../data/repositories/browse_repository.dart';
import '../../home/widgets/krithi_result_card.dart';
import '../../krithi/screens/krithi_detail_screen.dart';
import '../providers/browse_provider.dart';

// ---------------------------------------------------------------------------
// Lightweight entity data class (used by filter pickers)
// ---------------------------------------------------------------------------

class _NamedEntity {
  const _NamedEntity(this.id, this.name);
  final int id;
  final String name;
}

final _browseRagaListProvider = FutureProvider<List<_NamedEntity>>((ref) async {
  final repo = BrowseRepository(ref.watch(databaseProvider));
  final list = await repo.distinctRagas();
  return list.map((e) => _NamedEntity(e.id, e.name)).toList();
});

final _browseComposerListProvider =
    FutureProvider<List<_NamedEntity>>((ref) async {
  final repo = BrowseRepository(ref.watch(databaseProvider));
  final list = await repo.distinctComposers();
  return list.map((e) => _NamedEntity(e.id, e.name)).toList();
});

final _browseTalaListProvider =
    FutureProvider<List<_NamedEntity>>((ref) async {
  final repo = BrowseRepository(ref.watch(databaseProvider));
  final list = await repo.distinctTalas();
  return list.map((e) => _NamedEntity(e.id, e.name)).toList();
});

// ---------------------------------------------------------------------------
// Browse Screen
// ---------------------------------------------------------------------------

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 200) {
      ref.read(browseProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(browseProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse'),
        actions: [
          _SortButton(
            current: state.sort,
            onChanged: (s) => ref.read(browseProvider.notifier).setSort(s),
          ),
          const SizedBox(width: 4),
          _FilterButton(
            hasActive: !state.filter.isEmpty,
            onTap: () => _openFilterSheet(context, state.filter),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // ── Active filter chips ──────────────────────────────────────────
          if (!state.filter.isEmpty)
            _ActiveFilterChips(
              filter: state.filter,
              onRemove: (f) => ref.read(browseProvider.notifier).applyFilter(f),
              onClearAll: () => ref.read(browseProvider.notifier).clearFilter(),
            ),

          // ── Sort label ───────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
            color: cs.surfaceContainerLow,
            child: Text(
              _sortLabel(state.sort),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
          ),

          // ── List ─────────────────────────────────────────────────────────
          Expanded(
            child: state.isLoading && state.items.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.items.isEmpty
                    ? _EmptyState(hasFilter: !state.filter.isEmpty)
                    : _KrithiList(
                        state: state,
                        scrollCtrl: _scrollCtrl,
                      ),
          ),
        ],
      ),
    );
  }

  String _sortLabel(BrowseSortOrder sort) => switch (sort) {
        BrowseSortOrder.nameAz => 'Sorted A – Z',
        BrowseSortOrder.byRaga => 'Sorted by Raga',
        BrowseSortOrder.byComposer => 'Sorted by Composer',
      };

  Future<void> _openFilterSheet(
      BuildContext context, BrowseFilterState current) async {
    final result = await showModalBottomSheet<BrowseFilterState>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BrowseFilterSheet(initial: current),
    );
    if (result != null && mounted) {
      ref.read(browseProvider.notifier).applyFilter(result);
    }
  }
}

// ---------------------------------------------------------------------------
// Krithi list with load-more footer
// ---------------------------------------------------------------------------

class _KrithiList extends StatelessWidget {
  const _KrithiList({required this.state, required this.scrollCtrl});

  final BrowseState state;
  final ScrollController scrollCtrl;

  @override
  Widget build(BuildContext context) {
    final extraItem = (state.isLoading || state.hasMore) ? 1 : 0;
    final itemCount = state.items.length + extraItem;

    return ListView.builder(
      controller: scrollCtrl,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      itemCount: itemCount,
      itemBuilder: (context, i) {
        if (i == state.items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final r = state.items[i];
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
// Sort button — SegmentedButton in a menu
// ---------------------------------------------------------------------------

class _SortButton extends StatelessWidget {
  const _SortButton({required this.current, required this.onChanged});

  final BrowseSortOrder current;
  final void Function(BrowseSortOrder) onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BrowseSortOrder>(
      tooltip: 'Sort',
      icon: const Icon(Icons.sort),
      initialValue: current,
      onSelected: onChanged,
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: BrowseSortOrder.nameAz,
          child: Text('A – Z'),
        ),
        PopupMenuItem(
          value: BrowseSortOrder.byRaga,
          child: Text('By Raga'),
        ),
        PopupMenuItem(
          value: BrowseSortOrder.byComposer,
          child: Text('By Composer'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Filter icon button with active indicator
// ---------------------------------------------------------------------------

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.hasActive, required this.onTap});

  final bool hasActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onTap,
          tooltip: 'Filter',
          icon: Icon(
            hasActive ? Icons.filter_alt : Icons.filter_alt_outlined,
            color: hasActive ? cs.primary : null,
          ),
        ),
        if (hasActive)
          Positioned(
            right: 8,
            top: 8,
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
// Active filter chips
// ---------------------------------------------------------------------------

class _ActiveFilterChips extends StatelessWidget {
  const _ActiveFilterChips({
    required this.filter,
    required this.onRemove,
    required this.onClearAll,
  });

  final BrowseFilterState filter;
  final void Function(BrowseFilterState) onRemove;
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
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 2),
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
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasFilter});

  final bool hasFilter;

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
            Icon(Icons.library_music_outlined,
                size: 64, color: cs.onSurfaceVariant.withAlpha(100)),
            const SizedBox(height: 16),
            Text(
              hasFilter ? 'No krithis match these filters' : 'No krithis found',
              style: tt.titleSmall?.copyWith(color: cs.onSurface),
            ),
            if (hasFilter) ...[
              const SizedBox(height: 8),
              Text(
                'Try removing some filters.',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Browse filter bottom sheet (BrowseFilterState variant)
// ---------------------------------------------------------------------------

class _BrowseFilterSheet extends ConsumerStatefulWidget {
  const _BrowseFilterSheet({required this.initial});

  final BrowseFilterState initial;

  @override
  ConsumerState<_BrowseFilterSheet> createState() => _BrowseFilterSheetState();
}

class _BrowseFilterSheetState extends ConsumerState<_BrowseFilterSheet> {
  late BrowseFilterState _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scroll) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurfaceVariant.withAlpha(80),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 16, 8),
                child: Row(
                  children: [
                    Text('Filters',
                        style: tt.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          setState(() => _draft = const BrowseFilterState()),
                      child: const Text('Clear all'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: scroll,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    _BrowseEntityPicker(
                      label: 'Raga',
                      selectedId: _draft.ragaId,
                      selectedName: _draft.ragaName,
                      provider: _browseRagaListProvider,
                      onSelected: (e) => setState(
                        () => _draft = _draft.copyWith(
                            ragaId: e?.id,
                            ragaName: e?.name,
                            clearRaga: e == null),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _BrowseEntityPicker(
                      label: 'Composer',
                      selectedId: _draft.composerId,
                      selectedName: _draft.composerName,
                      provider: _browseComposerListProvider,
                      onSelected: (e) => setState(
                        () => _draft = _draft.copyWith(
                            composerId: e?.id,
                            composerName: e?.name,
                            clearComposer: e == null),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _BrowseEntityPicker(
                      label: 'Tala',
                      selectedId: _draft.talaId,
                      selectedName: _draft.talaName,
                      provider: _browseTalaListProvider,
                      onSelected: (e) => setState(
                        () => _draft = _draft.copyWith(
                            talaId: e?.id,
                            talaName: e?.name,
                            clearTala: e == null),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _BrowseChipGroup(
                      label: 'Language',
                      options: AppConstants.languages,
                      selected: _draft.language,
                      onSelected: (v) => setState(
                        () => _draft = _draft.copyWith(
                            language: v, clearLanguage: v == null),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _BrowseChipGroup(
                      label: 'Composition Type',
                      options: AppConstants.compositionTypes,
                      selected: _draft.compositionType,
                      onSelected: (v) => setState(
                        () => _draft = _draft.copyWith(
                            compositionType: v, clearType: v == null),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(_draft),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Entity picker (browse variant — uses _NamedEntity)
// ---------------------------------------------------------------------------

class _BrowseEntityPicker extends ConsumerStatefulWidget {
  const _BrowseEntityPicker({
    required this.label,
    required this.selectedId,
    required this.selectedName,
    required this.provider,
    required this.onSelected,
  });

  final String label;
  final int? selectedId;
  final String? selectedName;
  final FutureProvider<List<_NamedEntity>> provider;
  final void Function(_NamedEntity?) onSelected;

  @override
  ConsumerState<_BrowseEntityPicker> createState() =>
      _BrowseEntityPickerState();
}

class _BrowseEntityPickerState extends ConsumerState<_BrowseEntityPicker> {
  bool _expanded = false;
  final _ctrl = TextEditingController();
  String _filter = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isSelected = widget.selectedId != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? cs.primaryContainer.withAlpha(120)
                  : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(color: cs.primary.withAlpha(100))
                  : null,
            ),
            child: Row(
              children: [
                Text(
                  widget.label,
                  style: tt.bodyMedium?.copyWith(
                    color: isSelected ? cs.primary : cs.onSurfaceVariant,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const Spacer(),
                if (isSelected) ...[
                  Text(widget.selectedName ?? '',
                      style: tt.bodyMedium?.copyWith(color: cs.primary)),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => widget.onSelected(null),
                    child: Icon(Icons.close, size: 16, color: cs.primary),
                  ),
                ] else
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: cs.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 8),
          TextField(
            controller: _ctrl,
            onChanged: (v) => setState(() => _filter = v.toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Search ${widget.label.toLowerCase()}…',
              prefixIcon: const Icon(Icons.search, size: 18),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          ref.watch(widget.provider).when(
            data: (entities) {
              final filtered = _filter.isEmpty
                  ? entities
                  : entities
                      .where((e) => e.name.toLowerCase().contains(_filter))
                      .toList();
              if (filtered.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('No results',
                      style: Theme.of(context).textTheme.bodySmall),
                );
              }
              return Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final e = filtered[i];
                    final isSel = e.id == widget.selectedId;
                    return ListTile(
                      dense: true,
                      title: Text(e.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight:
                                  isSel ? FontWeight.w600 : null)),
                      trailing: isSel
                          ? Icon(Icons.check, color: cs.primary, size: 18)
                          : null,
                      onTap: () {
                        widget.onSelected(e);
                        setState(() {
                          _expanded = false;
                          _ctrl.clear();
                          _filter = '';
                        });
                      },
                    );
                  },
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Chip group (browse variant)
// ---------------------------------------------------------------------------

class _BrowseChipGroup extends StatelessWidget {
  const _BrowseChipGroup({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final List<String> options;
  final String? selected;
  final void Function(String?) onSelected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: tt.labelMedium?.copyWith(
                color: cs.onSurfaceVariant, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: options.map((opt) {
            final isSel = opt == selected;
            return FilterChip(
              label: Text(opt),
              selected: isSel,
              onSelected: (_) => onSelected(isSel ? null : opt),
              selectedColor: cs.primaryContainer,
              checkmarkColor: cs.primary,
              labelStyle: TextStyle(
                color: isSel ? cs.primary : cs.onSurface,
                fontWeight: isSel ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
