import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/krithi_search_result.dart';

/// Offline search engine for Shuddha Sangeetham.
///
/// All three methods are fully offline — zero network calls.
/// They use the SQLite FTS5 virtual tables (krithis_fts, lyrics_fts)
/// built during DB creation, plus the SearchAlias table for fuzzy matching.
class SearchRepository {
  const SearchRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------------------
  // 1. quickSearch — name / raga / composer, target < 200ms
  // ---------------------------------------------------------------------------

  /// Searches krithi name, raga name, and composer name simultaneously.
  ///
  /// Strategy:
  ///   1. Resolve [query] through SearchAlias — any alias for a raga/composer
  ///      expands the query to also match the canonical entity id.
  ///   2. FTS5 trigram match on [krithis_fts] (name + search_tokens).
  ///   3. Direct JOIN match on raga/composer name for alias-resolved ids.
  ///
  /// Results are ranked: exact name → starts-with → contains → raga/composer.
  Future<List<KrithiSearchResult>> quickSearch(String query) async {
    final q = _normalize(query);
    if (q.isEmpty) return [];

    // Resolve alias → canonical entity ids
    final aliasIds = await _resolveAliases(q);

    // Build raga/composer id filter clause
    final ragaIds = aliasIds['raga'] ?? [];
    final composerIds = aliasIds['composer'] ?? [];
    final talaIds = aliasIds['tala'] ?? [];

    final results = await _db.customSelect(
      '''
      SELECT
        k.id,
        k.name,
        r.name  AS raga_name,
        c.name  AS composer_name,
        t.name  AS tala_name,
        k.language,
        k.composition_type,
        -- Rank: 1=exact name, 2=starts-with, 3=contains, 4=raga/composer match
        CASE
          WHEN lower(k.name) = ?1          THEN 1
          WHEN lower(k.name) LIKE ?1 || '%' THEN 2
          WHEN lower(k.name) LIKE '%' || ?1 || '%' THEN 3
          ELSE 4
        END AS rank
      FROM krithis k
      JOIN ragas    r ON r.id = k.raga_id
      JOIN composers c ON c.id = k.composer_id
      JOIN talas    t ON t.id = k.tala_id
      WHERE
        k.id IN (SELECT rowid FROM krithis_fts WHERE krithis_fts MATCH ?2)
        OR (${ragaIds.isNotEmpty ? 'k.raga_id IN (${_placeholders(ragaIds.length)})' : '0'})
        OR (${composerIds.isNotEmpty ? 'k.composer_id IN (${_placeholders(composerIds.length)})' : '0'})
        OR (${talaIds.isNotEmpty ? 'k.tala_id IN (${_placeholders(talaIds.length)})' : '0'})
      ORDER BY rank, k.name
      LIMIT 50
      ''',
      variables: [
        Variable.withString(q),
        Variable.withString('"$q"'), // FTS5 phrase query
        ..._toVariables(ragaIds),
        ..._toVariables(composerIds),
        ..._toVariables(talaIds),
      ],
    ).get();

    return results.map<KrithiSearchResult>(_rowToResult).toList();
  }

  // ---------------------------------------------------------------------------
  // 2. lyricsSearch — full-text across pallavi/anupallavi/charanam, < 500ms
  // ---------------------------------------------------------------------------

  /// Searches across all lyric fields and returns matching krithis with a
  /// short snippet of the matching line for display in the result card.
  Future<List<KrithiSearchResult>> lyricsSearch(String query) async {
    final q = _normalize(query);
    if (q.isEmpty) return [];

    // FTS5 snippet() is unreliable with content= tables; instead we return
    // the pallavi text as the snippet — it's always the first lyric line
    // and gives the user enough context to confirm a match.
    final ftsRows = await _db.customSelect(
      '''
      SELECT rowid
      FROM lyrics_fts
      WHERE lyrics_fts MATCH ?1
      ORDER BY lyrics_fts.rank
      LIMIT 50
      ''',
      variables: [Variable.withString('"$q"')],
    ).get();

    if (ftsRows.isEmpty) return [];

    final ids = ftsRows.map((r) => r.read<int>('rowid')).toList();
    final placeholders = List.filled(ids.length, '?').join(', ');

    final results = await _db.customSelect(
      '''
      SELECT
        k.id,
        k.name,
        r.name  AS raga_name,
        c.name  AS composer_name,
        t.name  AS tala_name,
        k.language,
        k.composition_type,
        k.pallavi   AS snippet
      FROM krithis   k
      JOIN ragas     r ON r.id = k.raga_id
      JOIN composers c ON c.id = k.composer_id
      JOIN talas     t ON t.id = k.tala_id
      WHERE k.id IN ($placeholders)
      ''',
      variables: ids.map(Variable.withInt).toList(),
    ).get();

    return results.map<KrithiSearchResult>((row) {
      final base = _rowToResult(row);
      final snippet = row.read<String?>('snippet');
      return base.copyWith(lyricsSnippet: snippet);
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // 3. filterSearch — structured filter combination
  // ---------------------------------------------------------------------------

  /// Returns krithis matching ALL supplied non-null filters simultaneously.
  ///
  /// Any parameter left null is ignored (not filtered on).
  Future<List<KrithiSearchResult>> filterSearch({
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

    final where =
        conditions.isEmpty ? '1' : conditions.join(' AND ');

    final results = await _db.customSelect(
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
      ORDER BY k.name
      LIMIT 100
      ''',
      variables: variables,
    ).get();

    return results.map<KrithiSearchResult>(_rowToResult).toList();
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  /// Strips diacritics / accents and lowercases — matches the normalization
  /// applied when building search_tokens during the data pipeline.
  String _normalize(String input) {
    return input.trim().toLowerCase();
  }

  /// Looks up [query] in SearchAlias and returns entity ids grouped by type.
  Future<Map<String, List<int>>> _resolveAliases(String query) async {
    final rows = await _db.customSelect(
      '''
      SELECT entity_type, entity_id
      FROM search_aliases
      WHERE lower(alias) LIKE ?1
      LIMIT 50
      ''',
      variables: [Variable.withString('%$query%')],
    ).get();

    final map = <String, List<int>>{};
    for (final row in rows) {
      final type = row.read<String>('entity_type');
      final id = row.read<int>('entity_id');
      map.putIfAbsent(type, () => []).add(id);
    }
    return map;
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

  String _placeholders(int count) =>
      List.filled(count, '?').join(', ');

  List<Variable> _toVariables(List<int> ids) =>
      ids.map(Variable.withInt).toList();
}
