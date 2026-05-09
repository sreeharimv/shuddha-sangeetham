#!/usr/bin/env python3
"""
Shuddha Sangeetham — normalization & SQLite builder
Reads raw JSON files from data/raw/, cleans them, deduplicates,
normalizes raga/composer/tala names, generates SearchAlias rows,
and writes the final SQLite database ready to bundle with the Flutter app.

Usage:
    python normalize.py                        # default paths
    python normalize.py --raw data/raw --out data/shuddha.db
"""

import argparse
import json
import logging
import re
import sqlite3
import sys
import unicodedata
from pathlib import Path

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)],
)
log = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Curated name-variant tables
# Each entry: (canonical_name, [alias1, alias2, ...])
# ---------------------------------------------------------------------------

RAGA_VARIANTS: list[tuple[str, list[str]]] = [
    ("Bhairavi", ["Bhairawi", "Bairavi", "Bhairavee"]),
    ("Kalyani", ["Kalyan", "Kalyaani"]),
    ("Todi", ["Thodi", "Todi"]),
    ("Kambhoji", ["Kamboji", "Kambhodi"]),
    ("Sankarabharanam", ["Shankarabharanam", "Shankara Bharanam", "Sankarabharana"]),
    ("Arabhi", ["Arabi", "Arabia"]),
    ("Varali", ["Varali"]),
    ("Kedaragowla", ["Kedara Gowla", "Kedara", "Kedharagowla"]),
    ("Mohanam", ["Mohana", "Mohnam"]),
    ("Saveri", ["Shaveri", "Saaverri"]),
    ("Natabhairavi", ["Nata Bhairavi", "Natabhairawi"]),
    ("Hindolam", ["Hindola", "Hindolam"]),
    ("Suddha Saveri", ["Suddhasaveri", "Shuddha Saveri"]),
    ("Ritigowla", ["Riti Gowla", "Ritigaula"]),
    ("Madhyamavati", ["Madhyamawathi", "Madhyamavathi"]),
    ("Mukhari", ["Mookhari", "Moukhari"]),
    ("Begada", ["Begade", "Behag"]),
    ("Huseni", ["Husaini", "Hussaini", "Husseni"]),
    ("Kharaharapriya", ["Kharaharapriya", "Khara Harapriya"]),
    ("Poorvikalyani", ["Poorvi Kalyani", "Purvi Kalyan"]),
]

COMPOSER_VARIANTS: list[tuple[str, list[str]]] = [
    ("Tyagaraja", ["Thyagaraja", "Thyagarajar", "Tyagarajar", "St. Tyagaraja"]),
    ("Muthuswami Dikshitar", ["Dikshitar", "Dikshithar", "Muthuswami Dikshithar", "M. Dikshitar"]),
    ("Syama Sastri", ["Shyama Shastri", "Syama Shastri", "Shyama Sastri"]),
    ("Swati Tirunal", ["Swathi Thirunal", "Swati Thirunal", "Swathi Tirunal"]),
    ("Annamacharya", ["Tallapaka Annamacharya", "Annamayya"]),
    ("Purandaradasa", ["Purandhara Dasa", "Purandaradaasa"]),
    ("Papanasam Sivan", ["Papanasam Shivan", "Papanasam Sivam"]),
    ("Oottukkadu Venkata Kavi", ["Oottukkadu VK", "OVKK"]),
    ("Gopalakrishna Bharati", ["Gopalakrishna Bharathi"]),
    ("Arunachala Kavi", ["Arunachala Kavirayar"]),
]

TALA_VARIANTS: list[tuple[str, list[str]]] = [
    ("Adi", ["Adhi", "Aadi"]),
    ("Rupaka", ["Roopaka", "Roopakam"]),
    ("Misra Chapu", ["Misrachapu", "Mishra Chapu", "Misra Jhaptal"]),
    ("Khanda Chapu", ["Khandachapu", "Khanda Chaap"]),
    ("Tisra Triputa", ["Tisra Triputa", "Trisra Triputa"]),
    ("Ata", ["Atam", "Ata Talam"]),
    ("Jhampa", ["Jhampai", "Jhampa Tala"]),
    ("Triputa", ["Tripudam"]),
    ("Dhruva", ["Dhruvam"]),
    ("Matya", ["Matyam"]),
]

# ---------------------------------------------------------------------------
# Text normalisation helpers
# ---------------------------------------------------------------------------

def _normalise_str(s: str) -> str:
    """Lower-case, remove accents, collapse whitespace."""
    s = unicodedata.normalize("NFKD", s)
    s = "".join(c for c in s if not unicodedata.combining(c))
    s = re.sub(r"\s+", " ", s).strip().lower()
    return s


def _build_lookup(variants: list[tuple[str, list[str]]]) -> dict[str, str]:
    """Build alias→canonical dict (lower-cased keys)."""
    lookup: dict[str, str] = {}
    for canonical, aliases in variants:
        lookup[_normalise_str(canonical)] = canonical
        for alias in aliases:
            lookup[_normalise_str(alias)] = canonical
    return lookup


RAGA_LOOKUP = _build_lookup(RAGA_VARIANTS)
COMPOSER_LOOKUP = _build_lookup(COMPOSER_VARIANTS)
TALA_LOOKUP = _build_lookup(TALA_VARIANTS)


def _canon(name: str, lookup: dict[str, str]) -> str:
    """Return canonical form if known, else title-case the input."""
    key = _normalise_str(name)
    return lookup.get(key, name.strip().title() if name else "")


def _detect_language(text: str, declared: str) -> str:
    declared_clean = declared.lower().strip()
    if "telugu" in declared_clean:
        return "telugu"
    if "sanskrit" in declared_clean:
        return "sanskrit"
    if "tamil" in declared_clean:
        return "tamil"
    if "kannada" in declared_clean:
        return "kannada"
    if "malayalam" in declared_clean:
        return "malayalam"
    return declared_clean or "other"


def _detect_type(raw: str) -> str:
    raw_lower = raw.lower().strip()
    for t in ("varnam", "geetam", "swarajati", "tillana", "javali", "padam", "kirtanam"):
        if t in raw_lower:
            return t
    if "krithi" in raw_lower or "kirtana" in raw_lower:
        return "krithi"
    return raw_lower or "krithi"


# ---------------------------------------------------------------------------
# Deduplication key
# ---------------------------------------------------------------------------

def _dedup_key(row: dict) -> str:
    """Stable key for detecting duplicate compositions."""
    name = _normalise_str(row.get("name", ""))
    raga = _normalise_str(row.get("raga", ""))
    composer = _normalise_str(row.get("composer", ""))
    return f"{name}|{raga}|{composer}"


# ---------------------------------------------------------------------------
# SQLite schema
# ---------------------------------------------------------------------------

SCHEMA_SQL = """
PRAGMA journal_mode=WAL;
PRAGMA foreign_keys=ON;

CREATE TABLE IF NOT EXISTS composers (
    id              INTEGER PRIMARY KEY,
    name            TEXT NOT NULL UNIQUE,
    name_variants   TEXT NOT NULL DEFAULT '[]'
);

CREATE TABLE IF NOT EXISTS ragas (
    id              INTEGER PRIMARY KEY,
    name            TEXT NOT NULL UNIQUE,
    name_variants   TEXT NOT NULL DEFAULT '[]',
    arohana         TEXT NOT NULL DEFAULT '',
    avarohana       TEXT NOT NULL DEFAULT ''
);

CREATE TABLE IF NOT EXISTS talas (
    id              INTEGER PRIMARY KEY,
    name            TEXT NOT NULL UNIQUE,
    name_variants   TEXT NOT NULL DEFAULT '[]'
);

CREATE TABLE IF NOT EXISTS krithis (
    id              INTEGER PRIMARY KEY,
    name            TEXT NOT NULL,
    search_tokens   TEXT NOT NULL DEFAULT '',
    composer_id     INTEGER REFERENCES composers(id),
    raga_id         INTEGER REFERENCES ragas(id),
    tala_id         INTEGER REFERENCES talas(id),
    language        TEXT NOT NULL DEFAULT 'other',
    composition_type TEXT NOT NULL DEFAULT 'krithi',
    pallavi         TEXT NOT NULL DEFAULT '',
    anupallavi      TEXT NOT NULL DEFAULT '',
    charanam        TEXT NOT NULL DEFAULT '',
    source_url      TEXT NOT NULL DEFAULT '',
    created_at      TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS search_aliases (
    id          INTEGER PRIMARY KEY,
    entity_type TEXT NOT NULL,
    entity_id   INTEGER NOT NULL,
    alias       TEXT NOT NULL,
    UNIQUE(entity_type, entity_id, alias)
);

-- FTS5 index covering all searchable text
CREATE VIRTUAL TABLE IF NOT EXISTS krithis_fts USING fts5(
    name,
    raga,
    composer,
    tala,
    language,
    pallavi,
    anupallavi,
    charanam,
    tokenize='unicode61'
);

-- Triggers to keep FTS in sync
CREATE TRIGGER IF NOT EXISTS krithis_ai AFTER INSERT ON krithis BEGIN
    INSERT INTO krithis_fts(rowid, name, raga, composer, tala, language, pallavi, anupallavi, charanam)
    SELECT NEW.id, NEW.name,
        (SELECT name FROM ragas WHERE id = NEW.raga_id),
        (SELECT name FROM composers WHERE id = NEW.composer_id),
        (SELECT name FROM talas WHERE id = NEW.tala_id),
        NEW.language, NEW.pallavi, NEW.anupallavi, NEW.charanam;
END;

CREATE TRIGGER IF NOT EXISTS krithis_ad AFTER DELETE ON krithis BEGIN
    INSERT INTO krithis_fts(krithis_fts, rowid, name, raga, composer, tala, language, pallavi, anupallavi, charanam)
    VALUES('delete', OLD.id, OLD.name, '', '', '', OLD.language, OLD.pallavi, OLD.anupallavi, OLD.charanam);
END;
"""


# ---------------------------------------------------------------------------
# Main pipeline
# ---------------------------------------------------------------------------

def load_raw(raw_dir: Path) -> list[dict]:
    rows = []
    for f in sorted(raw_dir.glob("*.json"), key=lambda p: int(p.stem)):
        try:
            rows.append(json.loads(f.read_text(encoding="utf-8")))
        except Exception as exc:
            log.warning("Could not read %s: %s", f, exc)
    log.info("Loaded %d raw JSON files", len(rows))
    return rows


def deduplicate(rows: list[dict]) -> list[dict]:
    seen: dict[str, dict] = {}
    for row in rows:
        key = _dedup_key(row)
        if key not in seen:
            seen[key] = row
        else:
            # Keep the one with more complete lyrics
            existing = seen[key]
            if len(row.get("pallavi", "")) > len(existing.get("pallavi", "")):
                seen[key] = row
    result = list(seen.values())
    log.info("After deduplication: %d krithis (removed %d)", len(result), len(rows) - len(result))
    return result


def normalise_row(row: dict) -> dict:
    row = dict(row)
    row["raga"] = _canon(row.get("raga", ""), RAGA_LOOKUP)
    row["composer"] = _canon(row.get("composer", ""), COMPOSER_LOOKUP)
    row["tala"] = _canon(row.get("tala", ""), TALA_LOOKUP)
    row["language"] = _detect_language(row.get("pallavi", ""), row.get("language", ""))
    row["composition_type"] = _detect_type(row.get("composition_type", ""))
    return row


def _get_or_create(cur: sqlite3.Cursor, table: str, name: str, extra: dict | None = None) -> int:
    cur.execute(f"SELECT id FROM {table} WHERE name = ?", (name,))
    result = cur.fetchone()
    if result:
        return result[0]
    cols = ["name"]
    vals: list = [name]
    if extra:
        for k, v in extra.items():
            cols.append(k)
            vals.append(v)
    placeholders = ", ".join("?" * len(vals))
    col_str = ", ".join(cols)
    cur.execute(f"INSERT INTO {table} ({col_str}) VALUES ({placeholders})", vals)
    return cur.lastrowid  # type: ignore[return-value]


def _insert_aliases(cur: sqlite3.Cursor, entity_type: str, entity_id: int, aliases: list[str]) -> None:
    for alias in aliases:
        if alias:
            try:
                cur.execute(
                    "INSERT OR IGNORE INTO search_aliases (entity_type, entity_id, alias) VALUES (?, ?, ?)",
                    (entity_type, entity_id, alias.strip()),
                )
            except sqlite3.Error as exc:
                log.debug("Alias insert error: %s", exc)


def seed_curated_aliases(cur: sqlite3.Cursor) -> None:
    """Seed the SearchAlias table from our curated variant tables."""
    for canonical, aliases in RAGA_VARIANTS:
        cur.execute("SELECT id FROM ragas WHERE name = ?", (canonical,))
        row = cur.fetchone()
        if row:
            _insert_aliases(cur, "raga", row[0], [canonical] + aliases)

    for canonical, aliases in COMPOSER_VARIANTS:
        cur.execute("SELECT id FROM composers WHERE name = ?", (canonical,))
        row = cur.fetchone()
        if row:
            _insert_aliases(cur, "composer", row[0], [canonical] + aliases)

    for canonical, aliases in TALA_VARIANTS:
        cur.execute("SELECT id FROM talas WHERE name = ?", (canonical,))
        row = cur.fetchone()
        if row:
            _insert_aliases(cur, "tala", row[0], [canonical] + aliases)


def build_search_tokens(row: dict, raga_name: str, composer_name: str, tala_name: str) -> str:
    """Build a space-joined token string for quick FTS pre-filtering."""
    parts = [
        row.get("name", ""),
        raga_name,
        composer_name,
        tala_name,
        row.get("language", ""),
    ]
    return " ".join(p for p in parts if p)


def build_db(rows: list[dict], db_path: Path) -> None:
    db_path.parent.mkdir(parents=True, exist_ok=True)
    if db_path.exists():
        db_path.unlink()

    con = sqlite3.connect(db_path)
    cur = con.cursor()
    cur.executescript(SCHEMA_SQL)
    con.commit()

    raga_variants_map: dict[str, list[str]] = {c: v for c, v in RAGA_VARIANTS}
    composer_variants_map: dict[str, list[str]] = {c: v for c, v in COMPOSER_VARIANTS}
    tala_variants_map: dict[str, list[str]] = {c: v for c, v in TALA_VARIANTS}

    inserted = 0
    for row in rows:
        try:
            raga_name = row["raga"] or "Unknown"
            composer_name = row["composer"] or "Unknown"
            tala_name = row["tala"] or "Unknown"

            raga_variants = json.dumps(raga_variants_map.get(raga_name, []))
            composer_variants = json.dumps(composer_variants_map.get(composer_name, []))
            tala_variants = json.dumps(tala_variants_map.get(tala_name, []))

            arohana = row.get("raga_arohana", "")
            avarohana = row.get("raga_avarohana", "")

            raga_id = _get_or_create(cur, "ragas", raga_name, {
                "name_variants": raga_variants,
                "arohana": arohana,
                "avarohana": avarohana,
            })
            composer_id = _get_or_create(cur, "composers", composer_name, {
                "name_variants": composer_variants,
            })
            tala_id = _get_or_create(cur, "talas", tala_name, {
                "name_variants": tala_variants,
            })

            search_tokens = build_search_tokens(row, raga_name, composer_name, tala_name)

            cur.execute(
                """
                INSERT INTO krithis
                    (name, search_tokens, composer_id, raga_id, tala_id,
                     language, composition_type, pallavi, anupallavi, charanam, source_url)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    row.get("name", ""),
                    search_tokens,
                    composer_id,
                    raga_id,
                    tala_id,
                    row.get("language", "other"),
                    row.get("composition_type", "krithi"),
                    row.get("pallavi", ""),
                    row.get("anupallavi", ""),
                    row.get("charanam", ""),
                    row.get("source_url", ""),
                ),
            )
            krithi_id = cur.lastrowid

            # Auto-generate alias for the krithi name itself
            _insert_aliases(cur, "krithi", krithi_id, [row.get("name", "")])

            inserted += 1
        except Exception as exc:
            log.warning("Failed to insert krithi '%s': %s", row.get("name"), exc)

    # Seed curated aliases after all reference rows are in
    seed_curated_aliases(cur)

    # FTS is a standalone table populated by triggers; no rebuild needed

    con.commit()

    # Optimise
    cur.execute("PRAGMA optimize")
    con.execute("VACUUM")
    con.close()

    size_mb = db_path.stat().st_size / (1024 * 1024)
    log.info("Database written to %s (%.1f MB) — %d krithis inserted", db_path, size_mb, inserted)


def export_sample_json(rows: list[dict], out_path: Path, n: int = 20) -> None:
    sample = rows[:n]
    out_path.write_text(json.dumps(sample, ensure_ascii=False, indent=2), encoding="utf-8")
    log.info("Sample JSON written to %s (%d krithis)", out_path, len(sample))


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(description="Normalise raw JSON and build SQLite DB.")
    parser.add_argument("--raw", type=Path, default=Path(__file__).parent / "data" / "raw",
                        help="Directory of raw JSON files (default: data/raw)")
    parser.add_argument("--out", type=Path, default=Path(__file__).parent / "data" / "shuddha.db",
                        help="Output SQLite path (default: data/shuddha.db)")
    parser.add_argument("--sample", type=Path, default=Path(__file__).parent / "data" / "sample.json",
                        help="Output sample JSON path (default: data/sample.json)")
    args = parser.parse_args()

    rows = load_raw(args.raw)
    if not rows:
        log.error("No raw JSON files found in %s — run scraper.py first.", args.raw)
        sys.exit(1)

    rows = [normalise_row(r) for r in rows]
    rows = deduplicate(rows)
    export_sample_json(rows, args.sample)
    build_db(rows, args.out)


if __name__ == "__main__":
    main()
