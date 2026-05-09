import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/krithi_search_result.dart';

enum BrowseSortOrder { nameAz, byRaga, byComposer }

/// Paginated browsing of the full krithi corpus with optional filtering.
///
/// All methods are fully offline — zero network calls.
class BrowseRepository {
  const BrowseRepository(this._db);

  final AppDatabase _db;

  static const int pageSize = 50;

  /// Returns one page of krithis using [offset] for pagination.
  ///
  /// Filters are optional; supply null to skip any dimension.
  Future<List<KrithiSearchResult>> browse({
    required BrowseSortOrder sort,
    required int offset,
    int? ragaId,
    int? composerId,
    int? talaId,
    String? language,
    String? compositionType,
  }) async {
    final conditions = <String>[];
    final variables = <Variable>[];

    if (ragaId != null) {
      conditions.add('k.raga_id = ?');
      variables.add(Variable.withInt(ragaId));
    }
    if (composerId != null) {
      conditions.add('k.composer_id = ?');
      variables.add(Variable.withInt(composerId));
    }
    if (talaId != null) {
      conditions.add('k.tala_id = ?');
      variables.add(Variable.withInt(talaId));
    }
    if (language != null) {
      conditions.add('k.language = ?');
      variables.add(Variable.withString(language));
    }
    if (compositionType != null) {
      conditions.add('k.composition_type = ?');
      variables.add(Variable.withString(compositionType));
    }

    final where = conditions.isEmpty ? '1' : conditions.join(' AND ');

    final orderBy = switch (sort) {
      BrowseSortOrder.nameAz => 'k.name COLLATE NOCASE',
      BrowseSortOrder.byRaga => 'r.name COLLATE NOCASE, k.name COLLATE NOCASE',
      BrowseSortOrder.byComposer =>
        'c.name COLLATE NOCASE, k.name COLLATE NOCASE',
    };

    variables
      ..add(Variable.withInt(pageSize))
      ..add(Variable.withInt(offset));

    final rows = await _db.customSelect(
      '''
      SELECT
        k.id,
        k.name,
        r.name  AS raga_name,
        c.name  AS composer_name,
        t.name  AS tala_name,
        k.language,
        k.composition_type
      FROM krithis k
      JOIN ragas     r ON r.id = k.raga_id
      JOIN composers c ON c.id = k.composer_id
      JOIN talas     t ON t.id = k.tala_id
      WHERE $where
      ORDER BY $orderBy
      LIMIT ? OFFSET ?
      ''',
      variables: variables,
    ).get();

    return rows.map<KrithiSearchResult>(_rowToResult).toList();
  }

  /// Distinct ragas present in the krithis table, for the filter dropdown.
  Future<List<({int id, String name})>> distinctRagas() async {
    final rows = await _db.customSelect(
      '''
      SELECT DISTINCT r.id, r.name
      FROM ragas r
      WHERE EXISTS (SELECT 1 FROM krithis k WHERE k.raga_id = r.id)
      ORDER BY r.name COLLATE NOCASE
      ''',
    ).get();
    return rows
        .map((r) => (id: r.read<int>('id'), name: r.read<String>('name')))
        .toList();
  }

  /// Distinct composers present in the krithis table.
  Future<List<({int id, String name})>> distinctComposers() async {
    final rows = await _db.customSelect(
      '''
      SELECT DISTINCT c.id, c.name
      FROM composers c
      WHERE EXISTS (SELECT 1 FROM krithis k WHERE k.composer_id = c.id)
      ORDER BY c.name COLLATE NOCASE
      ''',
    ).get();
    return rows
        .map((r) => (id: r.read<int>('id'), name: r.read<String>('name')))
        .toList();
  }

  /// Distinct talas present in the krithis table.
  Future<List<({int id, String name})>> distinctTalas() async {
    final rows = await _db.customSelect(
      '''
      SELECT DISTINCT t.id, t.name
      FROM talas t
      WHERE EXISTS (SELECT 1 FROM krithis k WHERE k.tala_id = t.id)
      ORDER BY t.name COLLATE NOCASE
      ''',
    ).get();
    return rows
        .map((r) => (id: r.read<int>('id'), name: r.read<String>('name')))
        .toList();
  }

  KrithiSearchResult _rowToResult(QueryRow row) {
    return KrithiSearchResult(
      id: row.read<int>('id'),
      name: row.read<String>('name'),
      ragaName: row.read<String>('raga_name'),
      composerName: row.read<String>('composer_name'),
      talaName: row.read<String>('tala_name'),
      language: row.read<String>('language'),
      compositionType: row.read<String>('composition_type'),
    );
  }
}
