#!/usr/bin/env python3
"""
Shuddha Sangeetham — GitHub JSON enrichment importer

Reads song records from the ramanarunachalam/Music GitHub JSON dataset and
produces an enrichment map keyed by karnatik.com URL.  normalize.py merges
this map into the raw scraper output before building the SQLite DB.

The JSON lyrics are in SLP1 diacritics (academic notation) — NOT plain
English — so they are never used as app lyrics.  Only structured metadata
fields are extracted:
  - deity        ("God" field, renamed per spec)
  - tala_angas   (e.g. "Laghu-1, Dhruta-2")
  - tala_count   (e.g. "4 + 2 + 2 = 8")
  - raga_arohana / raga_avarohana  (fallback when scraper missed them)

Matching key: the karnatik.com URL embedded in each song's lyricsref field.

Usage:
    python import_json.py                         # default paths
    python import_json.py --songs data/json/song  # custom song directory
    python import_json.py --out data/enrichment.json

Input:  a local clone/snapshot of the ramanarunachalam/Music `song/` directory
        (one JSON file per song, named by numeric ID).
Output: data/enrichment.json  — dict keyed by karnatik URL, values are the
        enrichment fields to merge into the scraper raw rows.
"""

import argparse
import json
import logging
import re
import sys
from pathlib import Path

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)],
)
log = logging.getLogger(__name__)

DEFAULT_SONG_DIR = Path(__file__).parent / "data" / "json" / "song"
DEFAULT_COMPOSER_DIR = Path(__file__).parent / "data" / "json" / "composer"
DEFAULT_OUT = Path(__file__).parent / "data" / "enrichment.json"
DEFAULT_COMPOSER_OUT = Path(__file__).parent / "data" / "composer_era.json"

_KARNATIK_URL_RE = re.compile(r"https?://(?:www\.)?karnatik\.com/c\d+\.shtml", re.I)


def _info_value(info: list[dict], header: str) -> str:
    """Return the 'V' value for the first info entry whose 'H' matches header."""
    for entry in info:
        if entry.get("H", "").strip().lower() == header.lower():
            return entry.get("V", "").strip()
    return ""


def parse_song(data: dict) -> dict | None:
    """
    Extract enrichment fields from a single GitHub JSON song record.
    Returns None if there is no karnatik.com link (no way to match it).

    Expected record structure:
    {
      "title": {"H": "Display name", "V": "SLP1 name"},
      "info": [
        {"H": "Type",       "V": "Krithi"},
        {"H": "Composer",   "V": "Tyagaraja",  "I": 123},
        {"H": "Raga",       "V": "Hamsanandi", "I": 44},
        {"H": "Tala",       "V": "Adi",        "I": 1},
        {"H": "Tala name",  "V": "Chatusra Jaati Triputa Tala"},
        {"H": "Tala angas", "V": "Laghu-1, Dhruta-2"},
        {"H": "Tala count", "V": "4 + 2 + 2 = 8"},
        {"H": "Language",   "V": "Telugu"},
        {"H": "God",        "V": "kRshNA"},
        ...
      ],
      "lyricsref": [{"links": [{"N": "karnatik.com", "L": "https://karnatik.com/c4571.shtml"}]}],
      ...
    }
    """
    info = data.get("info", [])

    # Find the karnatik.com URL — this is our join key
    karnatik_url = None
    for ref_block in data.get("lyricsref", []):
        for link in ref_block.get("links", []):
            url = link.get("L", "")
            if _KARNATIK_URL_RE.match(url):
                karnatik_url = url.rstrip("/").lower()
                break
        if karnatik_url:
            break

    if not karnatik_url:
        return None

    # Normalize URL: force https:// and ensure www prefix
    karnatik_url = re.sub(r"https?://(www\.)?karnatik", "https://www.karnatik", karnatik_url, flags=re.I)

    deity_raw = _info_value(info, "God")
    tala_angas = _info_value(info, "Tala angas")
    tala_count = _info_value(info, "Tala count")
    arohana = _info_value(info, "Aa")       # raga arohana (SLP1 but still useful as fallback)
    avarohana = _info_value(info, "Av")     # raga avarohana

    # deity: use the plain-English display name if present, fall back to SLP1
    # The "God" field in info has only "V" (SLP1) — use it as-is; scraper's
    # plain-English value takes precedence when merging.
    deity = deity_raw

    return {
        "karnatik_url": karnatik_url,
        "deity": deity,
        "tala_angas": tala_angas,
        "tala_count": tala_count,
        "raga_arohana_json": arohana,
        "raga_avarohana_json": avarohana,
    }


def build_enrichment_map(song_dir: Path) -> dict[str, dict]:
    """
    Walk all JSON files in song_dir and return a dict keyed by karnatik URL.
    Duplicate URLs (shouldn't happen) are skipped with a warning.
    """
    enrichment: dict[str, dict] = {}
    total = 0
    matched = 0
    skipped_no_url = 0

    for f in sorted(song_dir.glob("*.json"), key=lambda p: int(p.stem) if p.stem.isdigit() else 0):
        total += 1
        try:
            data = json.loads(f.read_text(encoding="utf-8"))
        except Exception as exc:
            log.warning("Could not read %s: %s", f, exc)
            continue

        result = parse_song(data)
        if result is None:
            skipped_no_url += 1
            continue

        url = result["karnatik_url"]
        if url in enrichment:
            log.debug("Duplicate karnatik URL — skipping %s (%s)", f.name, url)
            continue

        enrichment[url] = result
        matched += 1

    log.info(
        "Processed %d song files: %d matched to karnatik URL, %d skipped (no URL)",
        total, matched, skipped_no_url,
    )
    return enrichment


def build_composer_era_map(composer_dir: Path) -> dict[str, str]:
    """
    Walk all JSON files in composer_dir and return a dict keyed by composer
    display name (title.H) mapping to era string "YYYY–YYYY" or "YYYY–".
    Only composers with at least a Born year are included.
    """
    era_map: dict[str, str] = {}
    total = 0
    matched = 0

    for f in sorted(composer_dir.glob("*.json")):
        total += 1
        try:
            data = json.loads(f.read_text(encoding="utf-8"))
        except Exception as exc:
            log.warning("Could not read %s: %s", f, exc)
            continue

        name = data.get("title", {}).get("H", "").strip()
        if not name:
            continue

        info = data.get("info", [])
        born = _info_value(info, "Born")
        died = _info_value(info, "Died")

        if born:
            era = f"{born}–{died}" if died else f"{born}–"
            era_map[name] = era
            matched += 1

    log.info(
        "Processed %d composer files: %d with era data",
        total, matched,
    )
    return era_map


def merge_into_raw(raw_row: dict, enrichment: dict[str, dict]) -> dict:
    """
    Merge enrichment fields into a single raw scraper row (in-place copy).
    Rules:
      - deity: use scraper value if non-empty, else JSON value
      - tala_angas / tala_count: always take from JSON (scraper doesn't have these)
      - raga_arohana / raga_avarohana: use scraper value if non-empty, else JSON fallback
    """
    url = raw_row.get("source_url", "").rstrip("/").lower()
    enrich = enrichment.get(url)
    if enrich is None:
        return raw_row

    row = dict(raw_row)
    if not row.get("deity"):
        row["deity"] = enrich.get("deity", "")
    row["tala_angas"] = enrich.get("tala_angas", "")
    row["tala_count"] = enrich.get("tala_count", "")
    if not row.get("raga_arohana"):
        row["raga_arohana"] = enrich.get("raga_arohana_json", "")
    if not row.get("raga_avarohana"):
        row["raga_avarohana"] = enrich.get("raga_avarohana_json", "")
    return row


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Build enrichment map from GitHub JSON song directory."
    )
    parser.add_argument(
        "--songs", type=Path, default=DEFAULT_SONG_DIR,
        help=f"Directory of GitHub JSON song files (default: {DEFAULT_SONG_DIR})",
    )
    parser.add_argument(
        "--composers", type=Path, default=DEFAULT_COMPOSER_DIR,
        help=f"Directory of GitHub JSON composer files (default: {DEFAULT_COMPOSER_DIR})",
    )
    parser.add_argument(
        "--out", type=Path, default=DEFAULT_OUT,
        help=f"Output enrichment JSON path (default: {DEFAULT_OUT})",
    )
    parser.add_argument(
        "--composer-out", type=Path, default=DEFAULT_COMPOSER_OUT,
        help=f"Output composer era JSON path (default: {DEFAULT_COMPOSER_OUT})",
    )
    args = parser.parse_args()

    if not args.songs.exists():
        log.error(
            "Song directory not found: %s\n"
            "Clone ramanarunachalam/Music and point --songs at the song/ subdirectory.",
            args.songs,
        )
        sys.exit(1)

    enrichment = build_enrichment_map(args.songs)
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(
        json.dumps(enrichment, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    log.info("Enrichment map written to %s (%d entries)", args.out, len(enrichment))

    if args.composers.exists():
        era_map = build_composer_era_map(args.composers)
        args.composer_out.parent.mkdir(parents=True, exist_ok=True)
        args.composer_out.write_text(
            json.dumps(era_map, ensure_ascii=False, indent=2), encoding="utf-8"
        )
        log.info("Composer era map written to %s (%d entries)", args.composer_out, len(era_map))
    else:
        log.info("Composer directory not found at %s — skipping era map", args.composers)


if __name__ == "__main__":
    main()
