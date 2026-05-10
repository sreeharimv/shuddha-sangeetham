import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/krithi_search_result.dart';

/// Fetches bookmarked krithis from the local SQLite database.
///
/// All operations are fully offline — no network calls.
class BookmarksRepository {
  const BookmarksRepository(this._db);

  final AppDatabase _db;

  static const String _baseSelect = '''
    SELECT
      k.id, k.name,
      r.name  AS raga_name,
      c.name  AS composer_name,
      t.name  AS tala_name,
      k.language, k.composition_type
    FROM bookmarks b
    JOIN krithis   k ON k.id = b.krithi_id
    JOIN composers c ON c.id = k.composer_id
    JOIN ragas     r ON r.id = k.raga_id
    JOIN talas     t ON t.id = k.tala_id
  ''';

  /// All bookmarks sorted by most recently bookmarked, optionally filtered
  /// by [query] (case-insensitive substring match on name, composer, raga).
  Future<List<KrithiSearchResult>> fetchBookmarks({String? query}) async {
    final trimmed = query?.trim();
    final hasQuery = trimmed != null && trimmed.isNotEmpty;

    final sql = hasQuery
        ? '$_baseSelect WHERE (k.name LIKE ? OR c.name LIKE ? OR r.name LIKE ?) ORDER BY b.bookmarked_at DESC'
        : '$_baseSelect ORDER BY b.bookmarked_at DESC';

    final variables = hasQuery
        ? [
            Variable.withString('%$trimmed%'),
            Variable.withString('%$trimmed%'),
            Variable.withString('%$trimmed%'),
          ]
        : <Variable>[];

    final rows = await _db
        .customSelect(sql, variables: variables)
        .get();

    return rows.map((row) {
      return KrithiSearchResult(
        id: row.read<int>('id'),
        name: row.read<String>('name'),
        ragaName: row.read<String>('raga_name'),
        composerName: row.read<String>('composer_name'),
        talaName: row.read<String>('tala_name'),
        language: row.read<String>('language'),
        compositionType: row.read<String>('composition_type'),
      );
    }).toList();
  }

  Future<void> removeBookmark(int krithiId) async {
    await _db.customStatement(
      'DELETE FROM bookmarks WHERE krithi_id = ?',
      [krithiId],
    );
  }
}
