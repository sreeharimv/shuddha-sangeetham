import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables/search_aliases.dart';
import 'search_alias_seed.dart';

/// Seeds the [SearchAliases] table from [kSearchAliasSeed].
///
/// Called once after DB creation (or after a full re-seed on update).
/// Skips entries whose alias already exists to allow idempotent re-runs.
class SeedLoader {
  const SeedLoader(this._db);

  final AppDatabase _db;

  Future<void> seedSearchAliases() async {
    for (final seed in kSearchAliasSeed) {
      // Resolve canonical name → entity id
      final entityId = await _resolveEntityId(seed.entityType, seed.canonicalName);
      if (entityId == null) continue; // entity not in DB yet — skip

      for (final alias in seed.aliases) {
        // Also insert the canonical name itself so it matches via alias table
        await _insertAlias(seed.entityType, entityId, alias);
      }
      // Insert canonical name as its own alias too
      await _insertAlias(seed.entityType, entityId, seed.canonicalName);
    }
  }

  Future<void> _insertAlias(String type, int entityId, String alias) async {
    await _db.customInsert(
      '''
      INSERT OR IGNORE INTO search_aliases(entity_type, entity_id, alias)
      VALUES (?, ?, ?)
      ''',
      variables: [
        Variable.withString(type),
        Variable.withInt(entityId),
        Variable.withString(alias.toLowerCase()),
      ],
    );
  }

  Future<int?> _resolveEntityId(String type, String canonicalName) async {
    final table = switch (type) {
      'composer' => 'composers',
      'raga' => 'ragas',
      'tala' => 'talas',
      'artist' => 'artists',
      _ => null,
    };
    if (table == null) return null;

    final rows = await _db.customSelect(
      'SELECT id FROM $table WHERE lower(name) = ? LIMIT 1',
      variables: [Variable.withString(canonicalName.toLowerCase())],
    ).get();

    return rows.isEmpty ? null : rows.first.read<int>('id');
  }
}
