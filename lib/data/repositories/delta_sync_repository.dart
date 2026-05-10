import 'package:drift/drift.dart';

import '../database/app_database.dart';

class DeltaSyncRepository {
  DeltaSyncRepository(this._db);

  final AppDatabase _db;

  /// Returns the most recent [updatedAt] across all local krithis, or null if
  /// the table is empty. Used as the "since" cursor sent to the sync API.
  Future<DateTime?> latestUpdatedAt() async {
    final maxExpr = _db.krithis.updatedAt.max();
    final row = await (_db.selectOnly(_db.krithis)..addColumns([maxExpr]))
        .getSingleOrNull();
    return row?.read(maxExpr);
  }

  /// Upserts a batch of krithi records received from the sync API.
  ///
  /// Each map must contain the same fields as the [Krithis] table columns,
  /// using snake_case keys matching the JSON payload.
  Future<void> upsertKrithis(List<Map<String, dynamic>> records) async {
    if (records.isEmpty) return;
    await _db.transaction(() async {
      for (final r in records) {
        await _db.into(_db.krithis).insertOnConflictUpdate(
              KrithisCompanion(
                id: Value(r['id'] as int),
                name: Value(r['name'] as String),
                composerId: Value(r['composer_id'] as int),
                ragaId: Value(r['raga_id'] as int),
                talaId: Value(r['tala_id'] as int),
                language: Value(r['language'] as String),
                compositionType: Value(r['composition_type'] as String),
                pallavi: Value(r['pallavi'] as String),
                anupallavi: Value.absentIfNull(r['anupallavi'] as String?),
                charanam: Value.absentIfNull(r['charanam'] as String?),
                sourceUrl: Value.absentIfNull(r['source_url'] as String?),
                searchTokens: Value.absentIfNull(r['search_tokens'] as String?),
                updatedAt: Value(DateTime.parse(r['updated_at'] as String)),
              ),
            );
      }
    });
  }
}
