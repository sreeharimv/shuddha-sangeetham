"""
migrate_db.py — Reconcile the scraper DB to match the Drift app schema.

What this does:
1. Copies shuddha.db → shuddha_app.db (leaves scraper DB untouched)
2. Adds missing nullable columns to composers / ragas / talas
3. Drops the scraper's FTS5 table + triggers (wrong tokenizer / columns)
4. Creates the Drift-compatible FTS5 tables (krithis_fts, lyrics_fts)
   with trigram tokenizer and correct column layout
5. Populates both FTS5 tables from the krithis table
6. Creates the missing tables: artists, users, concerts,
   concert_artists, concert_attendees, bookmarks
7. Creates all indexes
8. Prints a summary
"""

import shutil
import sqlite3
from pathlib import Path

SRC = Path(__file__).parent / "data" / "shuddha.db"
DST = Path(__file__).parent / "data" / "shuddha_app.db"
ASSETS_DIR = Path(__file__).parent.parent / "assets" / "db"


def migrate():
    print(f"Copying {SRC.name} → {DST.name} …")
    shutil.copy2(SRC, DST)

    con = sqlite3.connect(DST)
    con.execute("PRAGMA journal_mode=WAL")
    con.execute("PRAGMA foreign_keys=OFF")  # off during migration
    cur = con.cursor()

    # ------------------------------------------------------------------
    # 1. Add missing columns (ALTER TABLE ignores duplicates via try/except)
    # ------------------------------------------------------------------
    print("Adding missing columns …")
    optional_columns = [
        ("composers", "era",                       "TEXT"),
        ("composers", "biography",                 "TEXT"),
        ("composers", "language_of_compositions",  "TEXT"),
        ("ragas",     "melakarta_number",           "INTEGER"),
        ("ragas",     "parent_melakarta_id",        "INTEGER"),
        ("ragas",     "characteristics",            "TEXT"),
        ("talas",     "structure",                  "TEXT"),
        ("talas",     "aksharas_count",             "INTEGER"),
        ("krithis",   "deity",                      "TEXT"),
    ]
    for table, col, col_type in optional_columns:
        try:
            cur.execute(f"ALTER TABLE {table} ADD COLUMN {col} {col_type}")
        except sqlite3.OperationalError:
            pass  # column already exists

    # ------------------------------------------------------------------
    # 2. Drop old FTS5 table and its triggers (wrong schema)
    # ------------------------------------------------------------------
    print("Rebuilding FTS5 tables …")
    for trigger in ("krithis_ai", "krithis_ad"):
        cur.execute(f"DROP TRIGGER IF EXISTS {trigger}")

    cur.execute("DROP TABLE IF EXISTS krithis_fts")

    # ------------------------------------------------------------------
    # 3. Create Drift-compatible FTS5 tables
    # ------------------------------------------------------------------

    # krithis_fts — quick search (name + search_tokens via trigram)
    cur.execute("""
        CREATE VIRTUAL TABLE IF NOT EXISTS krithis_fts
        USING fts5(
            krithi_id UNINDEXED,
            name,
            search_tokens,
            content=krithis,
            content_rowid=id,
            tokenize="trigram"
        )
    """)

    # lyrics_fts — full-text lyrics search (trigram)
    cur.execute("""
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
    """)

    # ------------------------------------------------------------------
    # 4. Populate both FTS5 tables from krithis
    # ------------------------------------------------------------------
    print("Populating krithis_fts …")
    cur.execute("""
        INSERT INTO krithis_fts(rowid, name, search_tokens)
        SELECT id, name, search_tokens FROM krithis
    """)

    print("Populating lyrics_fts …")
    cur.execute("""
        INSERT INTO lyrics_fts(rowid, pallavi, anupallavi, charanam)
        SELECT id, pallavi, anupallavi, charanam FROM krithis
    """)

    # ------------------------------------------------------------------
    # 5. Recreate sync triggers (Drift-compatible column layout)
    # ------------------------------------------------------------------
    cur.execute("""
        CREATE TRIGGER IF NOT EXISTS krithis_fts_insert
        AFTER INSERT ON krithis BEGIN
            INSERT INTO krithis_fts(rowid, name, search_tokens)
            VALUES (new.id, new.name, new.search_tokens);
        END
    """)
    cur.execute("""
        CREATE TRIGGER IF NOT EXISTS krithis_fts_delete
        AFTER DELETE ON krithis BEGIN
            INSERT INTO krithis_fts(krithis_fts, rowid, name, search_tokens)
            VALUES ('delete', old.id, old.name, old.search_tokens);
        END
    """)
    cur.execute("""
        CREATE TRIGGER IF NOT EXISTS krithis_fts_update
        AFTER UPDATE ON krithis BEGIN
            INSERT INTO krithis_fts(krithis_fts, rowid, name, search_tokens)
            VALUES ('delete', old.id, old.name, old.search_tokens);
            INSERT INTO krithis_fts(rowid, name, search_tokens)
            VALUES (new.id, new.name, new.search_tokens);
        END
    """)
    cur.execute("""
        CREATE TRIGGER IF NOT EXISTS lyrics_fts_insert
        AFTER INSERT ON krithis BEGIN
            INSERT INTO lyrics_fts(rowid, pallavi, anupallavi, charanam)
            VALUES (new.id, new.pallavi, new.anupallavi, new.charanam);
        END
    """)
    cur.execute("""
        CREATE TRIGGER IF NOT EXISTS lyrics_fts_delete
        AFTER DELETE ON krithis BEGIN
            INSERT INTO lyrics_fts(lyrics_fts, rowid, pallavi, anupallavi, charanam)
            VALUES ('delete', old.id, old.pallavi, old.anupallavi, old.charanam);
        END
    """)
    cur.execute("""
        CREATE TRIGGER IF NOT EXISTS lyrics_fts_update
        AFTER UPDATE ON krithis BEGIN
            INSERT INTO lyrics_fts(lyrics_fts, rowid, pallavi, anupallavi, charanam)
            VALUES ('delete', old.id, old.pallavi, old.anupallavi, old.charanam);
            INSERT INTO lyrics_fts(rowid, pallavi, anupallavi, charanam)
            VALUES (new.id, new.pallavi, new.anupallavi, new.charanam);
        END
    """)

    # ------------------------------------------------------------------
    # 6. Create missing app tables
    # ------------------------------------------------------------------
    print("Creating missing tables …")

    cur.execute("""
        CREATE TABLE IF NOT EXISTS artists (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            name        TEXT NOT NULL,
            name_variants TEXT NOT NULL DEFAULT '[]',
            instrument  TEXT NOT NULL DEFAULT 'vocal',
            biography   TEXT,
            created_at  TEXT NOT NULL DEFAULT (datetime('now'))
        )
    """)

    cur.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id           INTEGER PRIMARY KEY AUTOINCREMENT,
            display_name TEXT NOT NULL,
            email        TEXT NOT NULL UNIQUE,
            role         TEXT NOT NULL DEFAULT 'user',
            created_at   TEXT NOT NULL DEFAULT (datetime('now'))
        )
    """)

    cur.execute("""
        CREATE TABLE IF NOT EXISTS concerts (
            id              INTEGER PRIMARY KEY AUTOINCREMENT,
            krithi_id       INTEGER NOT NULL REFERENCES krithis(id),
            raga_id         INTEGER REFERENCES ragas(id),
            venue           TEXT,
            city            TEXT,
            sabha_name      TEXT,
            performance_date TEXT,
            attendee_count  INTEGER NOT NULL DEFAULT 1,
            status          TEXT NOT NULL DEFAULT 'active',
            created_by_user_id INTEGER REFERENCES users(id),
            created_at      TEXT NOT NULL DEFAULT (datetime('now')),
            updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
        )
    """)

    cur.execute("""
        CREATE TABLE IF NOT EXISTS concert_artists (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            concert_id  INTEGER NOT NULL REFERENCES concerts(id),
            artist_id   INTEGER NOT NULL REFERENCES artists(id),
            role        TEXT
        )
    """)

    cur.execute("""
        CREATE TABLE IF NOT EXISTS concert_attendees (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            concert_id  INTEGER NOT NULL REFERENCES concerts(id),
            user_id     INTEGER NOT NULL REFERENCES users(id),
            created_at  TEXT NOT NULL DEFAULT (datetime('now'))
        )
    """)

    cur.execute("""
        CREATE TABLE IF NOT EXISTS bookmarks (
            krithi_id    INTEGER NOT NULL REFERENCES krithis(id),
            bookmarked_at TEXT NOT NULL DEFAULT (datetime('now')),
            PRIMARY KEY (krithi_id)
        )
    """)

    # ------------------------------------------------------------------
    # 7. Indexes
    # ------------------------------------------------------------------
    print("Creating indexes …")
    indexes = [
        "CREATE INDEX IF NOT EXISTS idx_krithis_composer ON krithis(composer_id)",
        "CREATE INDEX IF NOT EXISTS idx_krithis_raga     ON krithis(raga_id)",
        "CREATE INDEX IF NOT EXISTS idx_krithis_tala     ON krithis(tala_id)",
        "CREATE INDEX IF NOT EXISTS idx_krithis_language ON krithis(language)",
        "CREATE INDEX IF NOT EXISTS idx_krithis_type     ON krithis(composition_type)",
        "CREATE INDEX IF NOT EXISTS idx_krithis_updated  ON krithis(updated_at)",
        "CREATE INDEX IF NOT EXISTS idx_search_aliases   ON search_aliases(alias)",
    ]
    for idx in indexes:
        cur.execute(idx)

    # ------------------------------------------------------------------
    # 8. Set user_version=1 so Drift skips onCreate on first open,
    #    then re-enable FK and commit
    # ------------------------------------------------------------------
    con.execute("PRAGMA user_version = 1")
    con.execute("PRAGMA foreign_keys=ON")
    con.commit()

    # ------------------------------------------------------------------
    # 9. VACUUM to shrink
    # ------------------------------------------------------------------
    print("Vacuuming …")
    con.execute("VACUUM")
    con.close()

    # ------------------------------------------------------------------
    # 10. Copy to assets/db/
    # ------------------------------------------------------------------
    ASSETS_DIR.mkdir(parents=True, exist_ok=True)
    asset_path = ASSETS_DIR / "shuddha_sangeetham.db"
    print(f"Copying to {asset_path} …")
    shutil.copy2(DST, asset_path)

    # Summary
    size_mb = asset_path.stat().st_size / 1024 / 1024
    con2 = sqlite3.connect(asset_path)
    counts = {
        t: con2.execute(f"SELECT COUNT(*) FROM {t}").fetchone()[0]
        for t in ("krithis", "composers", "ragas", "talas", "search_aliases")
    }
    con2.close()

    print("\n✓ Migration complete")
    print(f"  Asset DB : {asset_path}")
    print(f"  Size     : {size_mb:.1f} MB")
    for t, n in counts.items():
        print(f"  {t:<20} {n:>6} rows")


if __name__ == "__main__":
    migrate()
