#!/usr/bin/env python3
"""
Shuddha Sangeetham — karnatik.com scraper
Scrapes composition pages c1000.shtml through c20000.shtml.

Usage:
    python scraper.py                     # full run, c1000–c20000
    python scraper.py --start 5000        # resume / start from a specific page
    python scraper.py --start 1000 --end 2000  # limited range

Output:
    data/raw/       — one JSON file per successfully scraped page
    data/failed.log — one line per failed page (can be re-fed as --ids)
"""

import argparse
import json
import logging
import os
import random
import re
import sys
import time
from pathlib import Path

import requests
from bs4 import BeautifulSoup

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

BASE_URL = "https://www.karnatik.com/c{n}.shtml"
START_N = 1000
END_N = 20000

DATA_DIR = Path(__file__).parent / "data"
RAW_DIR = DATA_DIR / "raw"
FAILED_LOG = DATA_DIR / "failed.log"

# Polite delay range (seconds) — stays well under any reasonable rate limit
DELAY_MIN = 2.0
DELAY_MAX = 3.5

HEADERS = {
    "User-Agent": (
        "ShudhaSangeethamBot/1.0 (personal research; "
        "contact: shuddha-sangeetham-bot@example.com)"
    ),
    "Accept-Language": "en-US,en;q=0.9",
}

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler(DATA_DIR / "scraper.log" if DATA_DIR.exists() else "scraper.log"),
    ],
)
log = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# HTML parsing helpers
# ---------------------------------------------------------------------------

def _text(element) -> str:
    """Return stripped inner text of a BS4 element, or empty string."""
    return element.get_text(separator=" ", strip=True) if element else ""


# Section labels used in the lyrics area (as plain <p> text)
_SECTION_RE = re.compile(
    r"^\s*(pallavi|anupallavi|caraNam|caranam|charanam\s*\d*|"
    r"madhyama\s*kaalam|chitta\s*swaram|swarajati|meaning|notation|other\s*information)\s*$",
    re.I,
)

# Metadata labels that appear inline in the content TD
_RAAGAM_RE = re.compile(r"raagam\s*:", re.I)
_TAALAM_RE = re.compile(r"taaLam\s*:", re.I)
_COMPOSER_RE = re.compile(r"Composer\s*:", re.I)
_LANGUAGE_RE = re.compile(r"Language\s*:", re.I)
_AROHANA_RE = re.compile(r"Aa\s*:", re.I)
_AVAROHANA_RE = re.compile(r"Av\s*:", re.I)


def _get_content_td(soup: BeautifulSoup):
    """Right-side TD (width=100%) holds the composition content."""
    td = soup.find("td", attrs={"width": "100%"})
    if td:
        return td
    tds = soup.find_all("td")
    return max(tds, key=lambda t: len(t.get_text()), default=None) if tds else None


def parse_krithi_page(html: str, page_id: int) -> dict | None:
    """
    Parse a karnatik.com composition page.

    Actual page structure (verified against live pages):
      - Two-column table; right TD (width=100%) holds everything.
      - Content is nested inside <font> tags so td.children gives only ~4 nodes.
      - Use td.find_all('p') / td.find_all('hr') to traverse in document order.

    <p> index (typical):
      [0]  empty
      [1]  "alai paayudE  raagam: kaanaDaa"   ← name + raga merged
      [2]  "22 kharaharapriya janya  Aa: ...  Av: ..."  ← italic block
      [3]  "taaLam: aadi  Composer: ...  Language: Tamil  Click to view in: ..."
      [4]  "pallavi"
      [5]  lyric text
      [6]  "anupallavi"
      ...
      [18] "Meaning:"   ← stop here

    <hr> tags: 5 total on a typical page; first separates header from meta+lyrics,
    the one before Meaning separates lyrics from translations.
    We stop at the <p> containing "Meaning" rather than relying on hr count.
    """
    soup = BeautifulSoup(html, "lxml")

    title_tag = soup.find("title")
    title = _text(title_tag)
    if not title or "carnatic songs" not in title.lower():
        return None

    td = _get_content_td(soup)
    if td is None:
        return None

    # Quick guard
    if not re.search(r"\bpallavi\b", td.get_text(), re.I):
        return None

    # ---- Krithi name from <title> ----------------------------------------
    name = title.split(" - ", 1)[1].strip() if " - " in title else ""

    # ---- Walk all <p> elements inside the TD in document order -------------
    all_ps = td.find_all("p")

    raga_name = ""
    arohana = ""
    avarohana = ""
    tala = ""
    composer = ""
    language = ""
    pallavi_parts: list[str] = []
    anupallavi_parts: list[str] = []
    charanam_parts: list[str] = []
    current_section: str | None = None
    lyrics_started = False

    for p in all_ps:
        p_text = p.get_text(separator=" ", strip=True)
        p_stripped = p_text.strip()

        # Stop at Meaning / Notation / Other information
        if re.match(r"^(Meaning|Notation|Other\s+information)\s*[:\.]?$", p_stripped, re.I):
            break

        # ---- Section label detection ----------------------------------------
        if _SECTION_RE.match(p_stripped):
            label = p_stripped.lower()
            if "pallavi" == label:
                current_section = "pallavi"
                lyrics_started = True
            elif "anupallavi" == label:
                current_section = "anupallavi"
            elif re.match(r"caran|charanam", label, re.I):
                current_section = "caranam"
            # madhyama kaalam / chitta swaram remain part of caranam
            continue

        # ---- Metadata (before first lyric section label) --------------------
        if not lyrics_started:
            # P[1]: "name  raagam: ragalink"
            if _RAAGAM_RE.search(p_text):
                a = p.find("a", href=re.compile(r"raga", re.I))
                if a:
                    raga_name = _text(a)
                else:
                    raga_name = re.split(r"raagam\s*:", p_text, flags=re.I)[-1].strip()
                # name may be embedded before "raagam:" in P[1]
                if not name:
                    before_raga = re.split(r"raagam\s*:", p_text, flags=re.I)[0].strip()
                    if before_raga:
                        name = before_raga

            # P[2]: italic block with arohana / avarohana
            elif p.find("i") or (_AROHANA_RE.search(p_text) or _AVAROHANA_RE.search(p_text)):
                for line in p.get_text(separator="\n", strip=True).splitlines():
                    line = line.strip()
                    if _AROHANA_RE.match(line):
                        arohana = re.sub(r"Aa\s*:", "", line, flags=re.I).strip()
                    elif _AVAROHANA_RE.match(line):
                        avarohana = re.sub(r"Av\s*:", "", line, flags=re.I).strip()

            # P[3]: taaLam / Composer / Language (all in one <p>)
            if _TAALAM_RE.search(p_text):
                tala = re.split(r"taaLam\s*:", p_text, flags=re.I)[-1]
                tala = re.split(r"Composer\s*:", tala, flags=re.I)[0].strip()
            if _COMPOSER_RE.search(p_text):
                a = p.find("a", href=re.compile(r"co\d+", re.I))
                if a:
                    composer = _text(a)
                else:
                    raw = re.split(r"Composer\s*:", p_text, flags=re.I)[-1]
                    composer = re.split(r"Language\s*:", raw, flags=re.I)[0].strip()
            if _LANGUAGE_RE.search(p_text):
                raw = re.split(r"Language\s*:", p_text, flags=re.I)[-1]
                language = re.split(r"Click\s+to\s+view", raw, flags=re.I)[0].strip()
            continue

        # ---- Lyric content --------------------------------------------------
        if not p_stripped or _SECTION_RE.match(p_stripped):
            continue

        if current_section == "pallavi":
            pallavi_parts.append(p_stripped)
        elif current_section == "anupallavi":
            anupallavi_parts.append(p_stripped)
        elif current_section == "caranam":
            charanam_parts.append(p_stripped)

    pallavi = "\n".join(pallavi_parts).strip()
    anupallavi = "\n".join(anupallavi_parts).strip()
    charanam = "\n".join(charanam_parts).strip()

    if not pallavi:
        return None

    return {
        "page_id": page_id,
        "source_url": BASE_URL.format(n=page_id),
        "name": name,
        "raga": raga_name,
        "raga_arohana": arohana,
        "raga_avarohana": avarohana,
        "tala": tala,
        "composer": composer,
        "language": language,
        "composition_type": "",
        "pallavi": pallavi,
        "anupallavi": anupallavi,
        "charanam": charanam,
    }


# ---------------------------------------------------------------------------
# Scraping loop
# ---------------------------------------------------------------------------

def load_already_scraped() -> set[int]:
    """Return set of page IDs already saved in RAW_DIR."""
    scraped = set()
    for f in RAW_DIR.glob("*.json"):
        try:
            scraped.add(int(f.stem))
        except ValueError:
            pass
    return scraped


def load_failed() -> set[int]:
    """Return set of previously failed page IDs."""
    failed = set()
    if FAILED_LOG.exists():
        for line in FAILED_LOG.read_text().splitlines():
            line = line.strip()
            if line.isdigit():
                failed.add(int(line))
    return failed


def append_failed(page_id: int) -> None:
    with open(FAILED_LOG, "a") as f:
        f.write(f"{page_id}\n")


def scrape(start: int, end: int, retry_failed: bool = False) -> None:
    RAW_DIR.mkdir(parents=True, exist_ok=True)
    DATA_DIR.mkdir(parents=True, exist_ok=True)

    already_scraped = load_already_scraped()
    previously_failed = load_failed()

    session = requests.Session()
    session.headers.update(HEADERS)

    if retry_failed:
        ids_to_scrape = sorted(previously_failed - already_scraped)
        log.info("Retrying %d previously failed pages", len(ids_to_scrape))
        # Clear the failed log so we start fresh
        FAILED_LOG.write_text("")
    else:
        ids_to_scrape = [n for n in range(start, end + 1) if n not in already_scraped]
        log.info(
            "Scraping pages %d–%d (%d remaining, %d already done)",
            start, end, len(ids_to_scrape), len(already_scraped),
        )

    success = 0
    skipped = 0
    failed = 0

    for i, page_id in enumerate(ids_to_scrape):
        url = BASE_URL.format(n=page_id)
        try:
            resp = session.get(url, timeout=20)
            if resp.status_code == 404:
                log.debug("404 — %s (gap page, skipping)", url)
                skipped += 1
            elif resp.status_code != 200:
                log.warning("HTTP %d — %s", resp.status_code, url)
                append_failed(page_id)
                failed += 1
            else:
                krithi = parse_krithi_page(resp.text, page_id)
                if krithi is None:
                    log.debug("No composition content — %s", url)
                    skipped += 1
                else:
                    out_path = RAW_DIR / f"{page_id}.json"
                    out_path.write_text(json.dumps(krithi, ensure_ascii=False, indent=2), encoding="utf-8")
                    log.info("[%d/%d] Saved %s — %s", i + 1, len(ids_to_scrape), page_id, krithi["name"])
                    success += 1

        except requests.exceptions.RequestException as exc:
            log.error("Network error on %s: %s", url, exc)
            append_failed(page_id)
            failed += 1

        # Polite delay — skip after the last item
        if i < len(ids_to_scrape) - 1:
            time.sleep(random.uniform(DELAY_MIN, DELAY_MAX))

    log.info("Done. success=%d  skipped=%d  failed=%d", success, skipped, failed)


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(description="Scrape karnatik.com composition pages.")
    parser.add_argument("--start", type=int, default=START_N, help=f"First page ID (default {START_N})")
    parser.add_argument("--end", type=int, default=END_N, help=f"Last page ID (default {END_N})")
    parser.add_argument(
        "--retry-failed",
        action="store_true",
        help="Re-attempt all pages listed in data/failed.log instead of the range",
    )
    args = parser.parse_args()

    # Ensure log handler path is correct now that DATA_DIR may have been created
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    # Reconfigure file handler with correct path
    for handler in log.handlers[:]:
        if isinstance(handler, logging.FileHandler):
            log.removeHandler(handler)
    log.addHandler(logging.FileHandler(DATA_DIR / "scraper.log"))

    scrape(args.start, args.end, retry_failed=args.retry_failed)


if __name__ == "__main__":
    main()
