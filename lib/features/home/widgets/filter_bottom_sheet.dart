import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/providers/database_provider.dart';
import '../providers/home_search_provider.dart';

// ---------------------------------------------------------------------------
// Lightweight entity picker data class
// ---------------------------------------------------------------------------

class _NamedEntity {
  const _NamedEntity(this.id, this.name);
  final int id;
  final String name;
}

// ---------------------------------------------------------------------------
// Providers for raga / composer / tala lists (loaded once from DB)
// ---------------------------------------------------------------------------

final _ragaListProvider = FutureProvider<List<_NamedEntity>>((ref) async {
  final db = ref.watch(databaseProvider);
  final rows = await db.customSelect(
    'SELECT id, name FROM ragas ORDER BY name LIMIT 500',
  ).get();
  return rows.map((r) => _NamedEntity(r.read<int>('id'), r.read<String>('name'))).toList();
});

final _composerListProvider = FutureProvider<List<_NamedEntity>>((ref) async {
  final db = ref.watch(databaseProvider);
  final rows = await db.customSelect(
    'SELECT id, name FROM composers ORDER BY name LIMIT 500',
  ).get();
  return rows.map((r) => _NamedEntity(r.read<int>('id'), r.read<String>('name'))).toList();
});

final _talaListProvider = FutureProvider<List<_NamedEntity>>((ref) async {
  final db = ref.watch(databaseProvider);
  final rows = await db.customSelect(
    'SELECT id, name FROM talas ORDER BY name LIMIT 100',
  ).get();
  return rows.map((r) => _NamedEntity(r.read<int>('id'), r.read<String>('name'))).toList();
});

// ---------------------------------------------------------------------------
// Filter bottom sheet
// ---------------------------------------------------------------------------

/// Modal bottom sheet where the user can pick raga, composer, tala,
/// language, and composition type filters simultaneously.
///
/// Call via [showFilterBottomSheet].
class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key, required this.initial});

  final FilterState initial;

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late FilterState _draft;

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
              // Drag handle
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
              // Header row
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 16, 8),
                child: Row(
                  children: [
                    Text('Filters', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    TextButton(
                      onPressed: () => setState(() => _draft = const FilterState()),
                      child: const Text('Clear all'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Scrollable filter sections
              Expanded(
                child: ListView(
                  controller: scroll,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    _EntityPicker(
                      label: 'Raga',
                      selectedId: _draft.ragaId,
                      selectedName: _draft.ragaName,
                      provider: _ragaListProvider,
                      onSelected: (e) => setState(
                        () => _draft = _draft.copyWith(ragaId: e?.id, ragaName: e?.name, clearRaga: e == null),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _EntityPicker(
                      label: 'Composer',
                      selectedId: _draft.composerId,
                      selectedName: _draft.composerName,
                      provider: _composerListProvider,
                      onSelected: (e) => setState(
                        () => _draft = _draft.copyWith(composerId: e?.id, composerName: e?.name, clearComposer: e == null),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _EntityPicker(
                      label: 'Tala',
                      selectedId: _draft.talaId,
                      selectedName: _draft.talaName,
                      provider: _talaListProvider,
                      onSelected: (e) => setState(
                        () => _draft = _draft.copyWith(talaId: e?.id, talaName: e?.name, clearTala: e == null),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ChipGroup(
                      label: 'Language',
                      options: AppConstants.languages,
                      selected: _draft.language,
                      onSelected: (v) => setState(
                        () => _draft = _draft.copyWith(
                          language: v,
                          clearLanguage: v == null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ChipGroup(
                      label: 'Composition Type',
                      options: AppConstants.compositionTypes,
                      selected: _draft.compositionType,
                      onSelected: (v) => setState(
                        () => _draft = _draft.copyWith(
                          compositionType: v,
                          clearType: v == null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              // Apply button
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
// Entity picker — searchable dropdown within the sheet
// ---------------------------------------------------------------------------

class _EntityPicker extends ConsumerStatefulWidget {
  const _EntityPicker({
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
  final void Function(_NamedEntity? entity) onSelected;

  @override
  ConsumerState<_EntityPicker> createState() => _EntityPickerState();
}

class _EntityPickerState extends ConsumerState<_EntityPicker> {
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
        // Picker row
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
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                const Spacer(),
                if (isSelected) ...[
                  Text(
                    widget.selectedName ?? '',
                    style: tt.bodyMedium?.copyWith(color: cs.primary),
                  ),
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
        // Dropdown list
        if (_expanded) ...[
          const SizedBox(height: 8),
          TextField(
            controller: _ctrl,
            onChanged: (v) => setState(() => _filter = v.toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Search ${widget.label.toLowerCase()}…',
              prefixIcon: const Icon(Icons.search, size: 18),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          ref.watch(widget.provider).when(
            data: (entities) {
              final filtered = _filter.isEmpty
                  ? entities
                  : entities.where((e) => e.name.toLowerCase().contains(_filter)).toList();
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: isSel ? FontWeight.w600 : null)),
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
// Multi-select chip group (language, composition type)
// ---------------------------------------------------------------------------

class _ChipGroup extends StatelessWidget {
  const _ChipGroup({
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

// ---------------------------------------------------------------------------
// Helper to show the sheet and return the result
// ---------------------------------------------------------------------------

Future<FilterState?> showFilterBottomSheet(
  BuildContext context, {
  required FilterState initial,
}) {
  return showModalBottomSheet<FilterState>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => FilterBottomSheet(initial: initial),
  );
}
