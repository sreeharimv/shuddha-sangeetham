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

from canonical import (
    clean_lyrics_text,
    clean_title,
    canon_raga,
    canon_composer,
    canon_tala,
    strip_diacritics,
)

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

BASE_URL = "https://www.karnatik.com/c{n}.shtml"
START_N = 1000
END_N = 20000

DATA_DIR = Path(__file__).parent / "data"
RAW_DIR = DATA_DIR / "raw"
HTML_DIR = DATA_DIR / "html"
FAILED_LOG = DATA_DIR / "failed.log"

# Polite delay range (seconds per worker)
DELAY_MIN = 0.3
DELAY_MAX = 0.6
DEFAULT_WORKERS = 3

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


# Section headings (pallavi, anupallavi, charanams, etc.)
_SECTION_HEADING_RE = re.compile(
    r"^\s*(pallavi|anupallavi|samash[tT]i\s*c[ha]raNam|c[ha]raNam\s*\d*|charanam\s*\d*|madhyama\s*k[aA]lam|chitta\s*swaram|swarajati|muktAyi\s*swaram)\b\s*[:\.-]?",
    re.I,
)

# Hard stop boundaries: meanings, notations, transliterations, credits, footers
_STOP_BOUNDARIES_RE = re.compile(
    r"^\s*(?:"
    r"(?:meaning|full\s*meaning|notation|full\s*notation|(?:more|other)\s*information|information)\b|"
    r"(?:tamil|telugu|kannada|malayalam|devanagari|hindi|sanskrit)\s*transliteration\b|"
    r"(?:lyrics|notation|lyrics\s*and\s*notation)?\s*(?:contributed|submitted)\s*by\b|"
    r"lyrics\s*from\s*compositions\b|"
    r"(?:click\s*here|audio\s*here|notation\s*available|gayaka)\b|"
    r"first\b\s*\||previous\b\s*\||contact\s*us\b|back\s*to\s*karnatik\b|royal\s*carpet\b|"
    r"updated\s*on\s*\d"
    r")\s*[:\.-]?",
    re.I,
)

# Indic script Unicode block
_INDIC_SCRIPT_RE = re.compile(r"[\u0900-\u0D7F]")

# Swara notation lines — skip these
_SWARA_RE = re.compile(r"^[srgmpdn,;|.()\s\d]+$", re.I)

# Metadata labels that appear inline
_RAAGAM_RE = re.compile(r"raagam\s*:", re.I)
_TAALAM_RE = re.compile(r"t[aA]{1,2}[lL][aA]m\s*:", re.I)
_COMPOSER_RE = re.compile(r"Composer\s*:", re.I)
_LANGUAGE_RE = re.compile(r"Language\s*:", re.I)
_AROHANA_RE = re.compile(r"Aa\s*:", re.I)
_AVAROHANA_RE = re.compile(r"Av\s*:", re.I)
_DEITY_RE = re.compile(r"God\s*:", re.I)

_COMP_TYPE_RE = re.compile(
    r"\b(bhajan|kaNNi|kanni|noTTusvar[aA]|nottaswara|nottuswara|nottu\b|varnam|varNa|tillAnA|tillana|padam|javali|swarajati)\b",
    re.I,
)


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

    Line-stream architecture:
      - Strips rogue mid-document tags (</body></html>) that break DOM tree parsers.
      - Converts <br>, <p>, <tr>, <hr> into newlines so inline charanams are not flattened.
      - Scans lines linearly, cleanly stopping at meaning / transliterations / footers.
      - Normalizes metadata (raga, composer, tala, title) and strips ITRANS/diacritics from lyrics.
    """
    html_clean = re.sub(r"</?(?:html|body|head)[^>]*>", "", html, flags=re.I)
    soup = BeautifulSoup(html_clean, "lxml")

    title_tag = soup.find("title")
    title = _text(title_tag)
    if not title or "carnatic songs" not in title.lower():
        return None

    td = _get_content_td(soup)
    if td is None:
        return None

    # Title extraction (handles both "Carnatic Songs - name" and "Carnatic Songs: name")
    raw_name = re.sub(r"^(?:Carnatic\s+Songs\s*[:\-]\s*)", "", title, flags=re.I).strip()
    if " - " in raw_name:
        raw_name = raw_name.split(" - ", 1)[1].strip()
    name = clean_title(raw_name)

    # Fallback to Song: <name> in body if title was empty
    if not name:
        song_m = re.search(r"Song\s*:\s*([^<\n\r]+)", td.get_text())
        if song_m:
            name = clean_title(song_m.group(1).strip())

    comp_type_m = _COMP_TYPE_RE.search(name)
    composition_type = comp_type_m.group(1).lower() if comp_type_m else ""

    # Extract metadata links from DOM before conversion
    raga_a = td.find("a", href=re.compile(r"raga", re.I))
    raga_name = canon_raga(_text(raga_a)) if raga_a else ""

    comp_a = td.find("a", href=re.compile(r"co\d+", re.I))
    composer = canon_composer(_text(comp_a)) if comp_a else ""

    # Convert line break elements into newlines so verses and inline charanams aren't collapsed
    for elem in td.find_all(["br", "p", "tr", "div", "hr"]):
        elem.insert_after("\n")

    lines = [l.strip() for l in td.get_text().splitlines() if l.strip()]

    tala = ""
    language = ""
    deity = ""
    arohana = ""
    avarohana = ""

    pallavi_lines: list[str] = []
    anupallavi_lines: list[str] = []
    charanams: list[tuple[str, list[str]]] = []
    current_charanam: list[str] = []
    current_charanam_label = "1"

    current_section: str | None = None
    lyrics_started = False

    for line in lines:
        # Check hard stop boundaries
        if _STOP_BOUNDARIES_RE.search(line):
            break
        if lyrics_started and _INDIC_SCRIPT_RE.search(line):
            break
        if lyrics_started and line.startswith(":"):
            # Line starting with colon during lyrics is English meaning/commentary
            break

        # Check section heading
        m_sec = _SECTION_HEADING_RE.match(line)
        if m_sec:
            sec_raw = m_sec.group(1).lower().strip()
            remainder = line[m_sec.end():].strip()
            remainder = re.sub(r"^[:\.-]\s*", "", remainder).strip()

            lyrics_started = True

            if "pallavi" in sec_raw and "anupallavi" not in sec_raw:
                current_section = "pallavi"
                if remainder and not _SWARA_RE.match(remainder):
                    pallavi_lines.append(remainder)
            elif "anupallavi" in sec_raw:
                current_section = "anupallavi"
                if remainder and not _SWARA_RE.match(remainder):
                    anupallavi_lines.append(remainder)
            else:  # charanam / samashti charanam
                current_section = "charanam"
                if current_charanam:
                    charanams.append((current_charanam_label, current_charanam))
                    current_charanam = []
                num_m = re.search(r"\d+", sec_raw)
                current_charanam_label = num_m.group(0) if num_m else str(len(charanams) + 1)
                if remainder and not _SWARA_RE.match(remainder):
                    current_charanam.append(remainder)
            continue

        if not lyrics_started:
            if not raga_name and _RAAGAM_RE.search(line):
                raw = re.split(r"raagam\s*:", line, flags=re.I)[-1]
                raw = re.split(r"(?:\bt[aA]{1,2}[lL][aA]m\s*:|\bComposer\s*:|\bLanguage\s*:)", raw, flags=re.I)[0]
                raga_name = canon_raga(raw.strip())
            if not tala and _TAALAM_RE.search(line):
                raw = re.split(r"t[aA]{1,2}[lL][aA]m\s*:", line, flags=re.I)[-1]
                raw = re.split(r"(?:\bComposer\s*:|\bLanguage\s*:|\bGod\s*:|\bClick\b)", raw, flags=re.I)[0]
                tala = canon_tala(raw.strip())
            if not composer and _COMPOSER_RE.search(line):
                raw = re.split(r"Composer\s*:", line, flags=re.I)[-1]
                raw = re.split(r"(?:\bLanguage\s*:|\bGod\s*:|\bClick\b)", raw, flags=re.I)[0]
                composer = canon_composer(raw.strip())
            if not language and _LANGUAGE_RE.search(line):
                raw = re.split(r"Language\s*:", line, flags=re.I)[-1]
                raw = re.split(r"(?:\bGod\s*:|\bClick\b)", raw, flags=re.I)[0]
                language = clean_title(raw.strip())
            if not deity and _DEITY_RE.search(line):
                raw = re.split(r"God\s*:", line, flags=re.I)[-1]
                deity = clean_title(raw.strip())
            if not arohana and _AROHANA_RE.search(line):
                arohana = re.sub(r".*?Aa\s*:\s*", "", line, flags=re.I).strip()
            if not avarohana and _AVAROHANA_RE.search(line):
                avarohana = re.sub(r".*?Av\s*:\s*", "", line, flags=re.I).strip()
            continue

        # Inside lyrics
        if _SWARA_RE.match(line):
            continue
        if _AROHANA_RE.search(line) or _AVAROHANA_RE.search(line) or re.match(r"^\d+\s+\w", line):
            continue

        if current_section == "pallavi":
            pallavi_lines.append(line)
        elif current_section == "anupallavi":
            anupallavi_lines.append(line)
        elif current_section == "charanam":
            current_charanam.append(line)

    if current_charanam:
        charanams.append((current_charanam_label, current_charanam))

    # Format charanams
    if len(charanams) == 1:
        charanam_text = "\n".join(charanams[0][1])
    elif len(charanams) > 1:
        blocks = []
        for lbl, ch_lines in charanams:
            blocks.append(f"{lbl}:\n" + "\n".join(ch_lines))
        charanam_text = "\n\n".join(blocks)
    else:
        charanam_text = ""

    pallavi = clean_lyrics_text("\n".join(pallavi_lines))
    anupallavi = clean_lyrics_text("\n".join(anupallavi_lines))
    charanam = clean_lyrics_text(charanam_text)

    # Fallback for non-krithi structured pages (bhajan, noTTusvarA, etc.)
    if not pallavi and not charanam:
        td_full_text = td.get_text()
        has_carnatic = _RAAGAM_RE.search(td_full_text) or _TAALAM_RE.search(td_full_text)
        if not has_carnatic:
            return None
        fallback_lines: list[str] = []
        meta_passed = False
        for line in lines:
            if _STOP_BOUNDARIES_RE.search(line):
                break
            if (_RAAGAM_RE.search(line) or _TAALAM_RE.search(line) or
                    _AROHANA_RE.search(line) or _AVAROHANA_RE.search(line) or
                    _COMPOSER_RE.search(line) or _LANGUAGE_RE.search(line)):
                meta_passed = True
                continue
            if re.match(r"^\d+\s+\w.*\bAa\s*:", line):
                meta_passed = True
                continue
            if not meta_passed:
                continue
            if _SWARA_RE.match(line) or re.match(r"^\d+$", line) or len(line) <= 1:
                continue
            fallback_lines.append(line)
        pallavi = clean_lyrics_text("\n".join(fallback_lines))
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
        "composition_type": composition_type,
        "deity": deity,
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


import threading
from concurrent.futures import ThreadPoolExecutor

_FAILED_LOCK = threading.Lock()


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
    with _FAILED_LOCK:
        with open(FAILED_LOG, "a") as f:
            f.write(f"{page_id}\n")


def load_empty_raga() -> list[int]:
    """Return sorted list of page IDs whose saved raw JSON has an empty raga."""
    empty = []
    for f in RAW_DIR.glob("*.json"):
        try:
            data = json.loads(f.read_text(encoding="utf-8"))
            if not (data.get("raga") or "").strip():
                empty.append(int(f.stem))
        except Exception:
            pass
    return sorted(empty)


def scrape_worker(page_id: int, session: requests.Session) -> tuple[int, str, str]:
    url = BASE_URL.format(n=page_id)
    html_path = HTML_DIR / f"{page_id}.html"
    out_path = RAW_DIR / f"{page_id}.json"

    html_text = ""
    if html_path.exists():
        html_text = html_path.read_text(encoding="utf-8", errors="replace")
    else:
        try:
            resp = session.get(url, timeout=20)
            if resp.status_code == 404:
                return page_id, "skipped_404", ""
            if resp.status_code != 200:
                append_failed(page_id)
                return page_id, f"http_{resp.status_code}", ""
            html_text = resp.content.decode("utf-8", errors="replace")
            html_path.write_text(html_text, encoding="utf-8")
        except requests.exceptions.RequestException as exc:
            append_failed(page_id)
            return page_id, f"error_{exc}", ""

    krithi = parse_krithi_page(html_text, page_id)
    if krithi is None:
        return page_id, "skipped_no_content", ""

    out_path.write_text(json.dumps(krithi, ensure_ascii=False, indent=2), encoding="utf-8")
    return page_id, "success", krithi.get("name", "")


def scrape(
    start: int,
    end: int,
    workers: int = DEFAULT_WORKERS,
    force: bool = False,
    retry_failed: bool = False,
    missing_raga_only: bool = False,
) -> None:
    RAW_DIR.mkdir(parents=True, exist_ok=True)
    HTML_DIR.mkdir(parents=True, exist_ok=True)
    DATA_DIR.mkdir(parents=True, exist_ok=True)

    already_scraped = set() if force else load_already_scraped()
    previously_failed = load_failed()

    if retry_failed:
        ids_to_scrape = sorted(previously_failed - already_scraped)
        log.info("Retrying %d previously failed pages", len(ids_to_scrape))
        FAILED_LOG.write_text("")
    elif missing_raga_only:
        ids_to_scrape = [pid for pid in load_empty_raga() if start <= pid <= end]
        log.info(
            "Scraping %d pages with missing ragas between %d and %d",
            len(ids_to_scrape), start, end,
        )
    else:
        ids_to_scrape = [n for n in range(start, end + 1) if n not in already_scraped]
        log.info(
            "Scraping pages %d–%d (%d to scrape, %d already done, %d workers)",
            start, end, len(ids_to_scrape), len(already_scraped), workers,
        )

    if not ids_to_scrape:
        log.info("No pages to scrape.")
        return

    thread_local = threading.local()

    def get_session():
        if not hasattr(thread_local, "session"):
            s = requests.Session()
            s.headers.update(HEADERS)
            thread_local.session = s
        return thread_local.session

    def task(pid):
        sess = get_session()
        res = scrape_worker(pid, sess)
        time.sleep(random.uniform(DELAY_MIN, DELAY_MAX))
        return res

    success = skipped = failed = 0
    t0 = time.time()

    with ThreadPoolExecutor(max_workers=workers) as executor:
        for i, (pid, status, name) in enumerate(executor.map(task, ids_to_scrape), 1):
            if status == "success":
                success += 1
                if i % 25 == 0 or i == len(ids_to_scrape):
                    rate = i / max(0.001, time.time() - t0)
                    log.info(
                        "[%d/%d] (%.1f/s) Saved c%d — %s",
                        i, len(ids_to_scrape), rate, pid, name,
                    )
            elif status.startswith("skipped"):
                skipped += 1
            else:
                failed += 1
                log.warning("[%d/%d] Failed c%d: %s", i, len(ids_to_scrape), pid, status)

    elapsed = time.time() - t0
    log.info(
        "Done in %.1fs. success=%d  skipped=%d  failed=%d",
        elapsed, success, skipped, failed,
    )


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(description="Scrape karnatik.com composition pages.")
    parser.add_argument("--start", type=int, default=START_N, help=f"First page ID (default {START_N})")
    parser.add_argument("--end", type=int, default=END_N, help=f"Last page ID (default {END_N})")
    parser.add_argument("--workers", type=int, default=DEFAULT_WORKERS, help=f"Number of parallel workers (default {DEFAULT_WORKERS})")
    parser.add_argument("--force", action="store_true", help="Re-scrape and overwrite existing raw JSONs")
    parser.add_argument(
        "--retry-failed",
        action="store_true",
        help="Re-attempt all pages listed in data/failed.log instead of the range",
    )
    parser.add_argument(
        "--missing-raga",
        action="store_true",
        help="Re-scrape only pages whose saved raw JSON has an empty raga",
    )
    args = parser.parse_args()

    DATA_DIR.mkdir(parents=True, exist_ok=True)
    for handler in log.handlers[:]:
        if isinstance(handler, logging.FileHandler):
            log.removeHandler(handler)
    log.addHandler(logging.FileHandler(DATA_DIR / "scraper.log"))

    scrape(
        args.start,
        args.end,
        workers=args.workers,
        force=args.force,
        retry_failed=args.retry_failed,
        missing_raga_only=args.missing_raga,
    )


if __name__ == "__main__":
    main()
