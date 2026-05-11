import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// Full krithi data for the detail page.
class KrithiDetail {
  const KrithiDetail({
    required this.id,
    required this.name,
    required this.composerName,
    required this.ragaName,
    required this.talaName,
    required this.language,
    required this.compositionType,
    required this.pallavi,
    this.deity,
    this.anupallavi,
    this.charanam,
    this.sourceUrl,
  });

  final int id;
  final String name;
  final String composerName;
  final String ragaName;
  final String talaName;
  final String language;
  final String compositionType;
  final String? deity;
  final String pallavi;
  final String? anupallavi;
  final String? charanam;
  final String? sourceUrl;
}

class KrithiDetailRepository {
  const KrithiDetailRepository(this._db);

  final AppDatabase _db;

  Future<KrithiDetail?> fetchById(int id) async {
    final rows = await _db.customSelect(
      '''
      SELECT
        k.id, k.name,
        c.name  AS composer_name,
        r.name  AS raga_name,
        t.name  AS tala_name,
        k.language, k.composition_type, k.deity,
        k.pallavi, k.anupallavi, k.charanam, k.source_url
      FROM krithis k
      JOIN composers c ON c.id = k.composer_id
      JOIN ragas     r ON r.id = k.raga_id
      JOIN talas     t ON t.id = k.tala_id
      WHERE k.id = ?
      LIMIT 1
      ''',
      variables: [Variable.withInt(id)],
    ).get();

    if (rows.isEmpty) return null;
    final row = rows.first;
    return KrithiDetail(
      id: row.read<int>('id'),
      name: row.read<String>('name'),
      composerName: row.read<String>('composer_name'),
      ragaName: row.read<String>('raga_name'),
      talaName: row.read<String>('tala_name'),
      language: row.read<String>('language'),
      compositionType: row.read<String>('composition_type'),
      deity: row.readNullable<String>('deity'),
      pallavi: row.read<String>('pallavi'),
      anupallavi: row.readNullable<String>('anupallavi'),
      charanam: row.readNullable<String>('charanam'),
      sourceUrl: row.readNullable<String>('source_url'),
    );
  }

  Future<bool> isBookmarked(int krithiId) async {
    final rows = await _db.customSelect(
      'SELECT 1 FROM bookmarks WHERE krithi_id = ? LIMIT 1',
      variables: [Variable.withInt(krithiId)],
    ).get();
    return rows.isNotEmpty;
  }

  Future<void> addBookmark(int krithiId) async {
    await _db.customStatement(
      'INSERT OR IGNORE INTO bookmarks(krithi_id) VALUES (?)',
      [krithiId],
    );
  }

  Future<void> removeBookmark(int krithiId) async {
    await _db.customStatement(
      'DELETE FROM bookmarks WHERE krithi_id = ?',
      [krithiId],
    );
  }
}
