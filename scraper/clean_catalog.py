#!/usr/bin/env python3
"""
Batch clean and normalize raw JSON files scraped from karnatik.com.
Applies:
  - Canonical raga, composer, and tala standardization.
  - Composition title casing without mid-word ITRANS capitals.
  - Strips Unicode diacritics and mid-word ITRANS uppercase from lyrics.
  - Separates mashed charanams into cleanly numbered stanzas.
  - Strips leaked meaning commentary, notation links, transliterations, and footers.
"""

import argparse
import json
import logging
import re
import sys
from pathlib import Path

from canonical import (
    canon_composer,
    canon_raga,
    canon_tala,
    clean_lyrics_text,
    clean_title,
    strip_diacritics,
)

_STOP_BOUNDARIES_RE = re.compile(
    r"^\s*(?:"
    r"meaning|full\s*meaning|notation|full\s*notation|(?:more|other)\s*information|information|"
    r"(?:tamil|telugu|kannada|malayalam|devanagari|hindi|sanskrit)\s*transliteration|"
    r"(?:lyrics|notation|lyrics\s*and\s*notation)?\s*(?:contributed|submitted)\s*by|"
    r"lyrics\s*from\s*compositions|"
    r"click\s*here|audio\s*here|notation\s*available|gayaka|"
    r"first\s*\|\s*previous|contact\s*us|back\s*to\s*karnatik|royal\s*carpet|"
    r"updated\s*on\s*\d"
    r")\b\s*[:\.-]?",
    re.I,
)

_INDIC_SCRIPT_RE = re.compile(r"[\u0900-\u0D7F]")

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
log = logging.getLogger(__name__)


def clean_section_text(text: str) -> str:
    """Strips leaked commentary, footers, transliterations, and Indic script."""
    if not text:
        return ""
    lines = []
    for line in text.splitlines():
        line = line.strip()
        if not line:
            continue
        if _STOP_BOUNDARIES_RE.search(line):
            break
        if line.startswith(":") or _INDIC_SCRIPT_RE.search(line):
            break
        # Strip inline meanings / commentary / footers from the line
        line = re.split(
            r"(?:\s*:\s*(?:meaning|pallavi|caraNam)|meaning\s*[:\.-]|contact\s*us|first\s*\|\s*previous)",
            line,
            flags=re.I,
        )[0].strip()
        if not line:
            break
        lines.append(line)
    return "\n".join(lines).strip()


def separate_mashed_charanams(charanam_text: str) -> str:
    """Detects and separates 'caraNam 2', 'caraNam 3' embedded inside charanam."""
    if not charanam_text:
        return ""
    marker_re = re.compile(r"\s*(?:caraNam|caranam|charanam)\s*(\d+)\s*", re.I)
    parts = marker_re.split(charanam_text)
    if len(parts) <= 1:
        return charanam_text

    stanzas: list[tuple[str, str]] = []
    p0 = clean_section_text(parts[0].strip())
    if p0:
        stanzas.append(("1", p0))

    for i in range(1, len(parts), 2):
        lbl = parts[i]
        txt = clean_section_text(parts[i + 1].strip()) if i + 1 < len(parts) else ""
        if txt:
            stanzas.append((lbl, txt))

    if not stanzas:
        return ""
    if len(stanzas) == 1:
        return stanzas[0][1]

    blocks = []
    for lbl, txt in stanzas:
        blocks.append(f"{lbl}:\n{txt}")
    return "\n\n".join(blocks)


def clean_record(data: dict) -> dict:
    """Clean a single krithi JSON record in place."""
    cleaned = dict(data)

    cleaned["name"] = clean_title(data.get("name", ""))
    cleaned["raga"] = canon_raga(data.get("raga", ""))
    cleaned["composer"] = canon_composer(data.get("composer", ""))
    cleaned["tala"] = canon_tala(data.get("tala", ""))
    if data.get("language"):
        cleaned["language"] = clean_title(data["language"])
    if data.get("deity"):
        cleaned["deity"] = clean_title(data["deity"])

    # Separate mashed charanams first, then clean lines
    p = clean_section_text(data.get("pallavi", ""))
    ap = clean_section_text(data.get("anupallavi", ""))
    ch = separate_mashed_charanams(data.get("charanam", ""))
    ch = clean_section_text(ch)

    cleaned["pallavi"] = clean_lyrics_text(p)
    cleaned["anupallavi"] = clean_lyrics_text(ap)
    cleaned["charanam"] = clean_lyrics_text(ch)

    return cleaned


def process_directory(raw_dir: Path) -> tuple[int, int]:
    files = sorted(raw_dir.glob("*.json"))
    log.info("Found %d JSON files in %s", len(files), raw_dir)
    modified = 0
    for f in files:
        try:
            raw_text = f.read_text(encoding="utf-8")
            data = json.loads(raw_text)
            cleaned = clean_record(data)
            cleaned_text = json.dumps(cleaned, ensure_ascii=False, indent=2)
            if cleaned_text != raw_text:
                f.write_text(cleaned_text, encoding="utf-8")
                modified += 1
        except Exception as e:
            log.warning("Failed to clean %s: %s", f.name, e)
    log.info("Processed %d files; %d modified", len(files), modified)
    return len(files), modified


def main():
    parser = argparse.ArgumentParser(description="Batch clean scraped karnatik raw JSONs")
    parser.add_argument("dir", type=Path, help="Directory containing raw JSON files")
    args = parser.parse_args()
    process_directory(args.dir)


if __name__ == "__main__":
    main()
