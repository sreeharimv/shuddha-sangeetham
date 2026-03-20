import 'package:drift/drift.dart';

import 'tables/artists.dart';
import 'tables/bookmarks.dart';
import 'tables/composers.dart';
import 'tables/concerts.dart';
import 'tables/krithis.dart';
import 'tables/ragas.dart';
import 'tables/search_aliases.dart';
import 'tables/talas.dart';
import 'tables/users.dart';

// Generated file — run: dart run build_runner build
part 'app_database.g.dart';

/// The single SQLite database for Shuddha Sangeetham.
///
/// All content ships pre-bundled at install time (Session 2).
/// Delta sync (Session 9) merges new/updated records into this DB.
///
/// FTS5 virtual tables for full-text search are created in [_onMigrate]
/// and will be fully wired up in Session 3.
@DriftDatabase(
  tables: [
    Composers,
    Ragas,
    Talas,
    Artists,
    Krithis,
    SearchAliases,
    Users,
    Concerts,
    ConcertArtists,
    ConcertAttendees,
    Bookmarks,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createFts5Tables(m);
          await _createIndexes();
        },
        onUpgrade: _onMigrate,
        beforeOpen: (details) async {
          // Enable foreign key enforcement.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ---------------------------------------------------------------------------
  // FTS5 virtual tables
  // ---------------------------------------------------------------------------

  /// Creates two FTS5 virtual tables.
  ///
  /// [krithis_fts] — covers name, raga, composer, tala for quick search.
  /// [lyrics_fts]  — covers pallavi, anupallavi, charanam for lyrics search.
  ///
  /// Both use the trigram tokenizer for substring / fuzzy matching without
  /// requiring whole-word boundaries. Fully implemented in Session 3.
  Future<void> _createFts5Tables(Migrator m) async {
    // Quick-search FTS (name + raga + composer + tala fields)
    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS krithis_fts
      USING fts5(
        krithi_id UNINDEXED,
        name,
        search_tokens,
        content=krithis,
        content_rowid=id,
        tokenize="trigram"
      )
    ''');

    // Triggers to keep krithis_fts in sync with the krithis table.
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS krithis_fts_insert
      AFTER INSERT ON krithis BEGIN
        INSERT INTO krithis_fts(rowid, name, search_tokens)
        VALUES (new.id, new.name, new.search_tokens);
      END
    ''');
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS krithis_fts_delete
      AFTER DELETE ON krithis BEGIN
        INSERT INTO krithis_fts(krithis_fts, rowid, name, search_tokens)
        VALUES ('delete', old.id, old.name, old.search_tokens);
      END
    ''');
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS krithis_fts_update
      AFTER UPDATE ON krithis BEGIN
        INSERT INTO krithis_fts(krithis_fts, rowid, name, search_tokens)
        VALUES ('delete', old.id, old.name, old.search_tokens);
        INSERT INTO krithis_fts(rowid, name, search_tokens)
        VALUES (new.id, new.name, new.search_tokens);
      END
    ''');

    // Lyrics FTS (pallavi + anupallavi + charanam)
    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS lyrics_fts
      USING fts5(
        krithi_id UNINDEXED,
        pallavi,
        anupallavi,
        charanam,
        content=krithis,
        content_rowid=id,
        tokenize="trigram"
      )
    ''');

    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS lyrics_fts_insert
      AFTER INSERT ON krithis BEGIN
        INSERT INTO lyrics_fts(rowid, pallavi, anupallavi, charanam)
        VALUES (new.id, new.pallavi, new.anupallavi, new.charanam);
      END
    ''');
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS lyrics_fts_delete
      AFTER DELETE ON krithis BEGIN
        INSERT INTO lyrics_fts(lyrics_fts, rowid, pallavi, anupallavi, charanam)
        VALUES ('delete', old.id, old.pallavi, old.anupallavi, old.charanam);
      END
    ''');
    await customStatement('''
      CREATE TRIGGER IF NOT EXISTS lyrics_fts_update
      AFTER UPDATE ON krithis BEGIN
        INSERT INTO lyrics_fts(lyrics_fts, rowid, pallavi, anupallavi, charanam)
        VALUES ('delete', old.id, old.pallavi, old.anupallavi, old.charanam);
        INSERT INTO lyrics_fts(rowid, pallavi, anupallavi, charanam)
        VALUES (new.id, new.pallavi, new.anupallavi, new.charanam);
      END
    ''');
  }

  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_krithis_composer ON krithis(composer_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_krithis_raga ON krithis(raga_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_krithis_tala ON krithis(tala_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_krithis_language ON krithis(language)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_krithis_type ON krithis(composition_type)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_krithis_updated ON krithis(updated_at)',
    );
  }

  // ---------------------------------------------------------------------------
  // Migration stubs — extend in later sessions as schemaVersion increases
  // ---------------------------------------------------------------------------

  Future<void> _onMigrate(Migrator m, int from, int to) async {
    // No-op for v1. Add migration steps here when schemaVersion is bumped.
  }
}
