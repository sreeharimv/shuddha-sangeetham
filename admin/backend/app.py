#!/usr/bin/env python3
"""
Shuddha Sangeetham — Admin CMS REST API

Serves:
  /api/sync          — delta sync endpoint consumed by Flutter app
  /api/krithis       — CRUD for krithis
  /api/ragas         — CRUD for ragas
  /api/composers     — CRUD for composers
  /api/talas         — CRUD for talas
  /api/import        — bulk JSON import
  /api/scraper/run   — trigger the scraper on the host machine
  /api/sync-log      — view scrape/sync history

Authentication: API key via X-Admin-Key header (non-public endpoints).

Usage:
    pip install -r requirements.txt
    export ADMIN_API_KEY=changeme
    export DB_PATH=/path/to/shuddha.db      # defaults to ../../scraper/data/shuddha.db
    python app.py
"""

import json
import logging
import os
import sqlite3
import subprocess
import threading
from datetime import datetime, timezone
from functools import wraps
from pathlib import Path

from flask import Flask, abort, g, jsonify, request
from flask_cors import CORS

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

ADMIN_API_KEY = os.environ.get("ADMIN_API_KEY", "changeme")
_here = Path(__file__).parent
DB_PATH = Path(os.environ.get("DB_PATH", str(_here / "../../scraper/data/shuddha.db")))
SYNC_LOG_PATH = _here / "sync_log.json"
SCRAPER_DIR = _here / "../../scraper"

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
log = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)  # GitHub Pages frontend is a different origin

# ---------------------------------------------------------------------------
# DB helpers
# ---------------------------------------------------------------------------


def get_db() -> sqlite3.Connection:
    if "db" not in g:
        g.db = sqlite3.connect(str(DB_PATH))
        g.db.row_factory = sqlite3.Row
        g.db.execute("PRAGMA journal_mode=WAL")
        g.db.execute("PRAGMA foreign_keys=ON")
    return g.db


@app.teardown_appcontext
def close_db(_exc):
    db = g.pop("db", None)
    if db:
        db.close()


def rows_to_list(rows) -> list[dict]:
    return [dict(r) for r in rows]


# ---------------------------------------------------------------------------
# Auth decorator
# ---------------------------------------------------------------------------


def require_admin(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        key = request.headers.get("X-Admin-Key", "")
        if key != ADMIN_API_KEY:
            abort(401)
        return f(*args, **kwargs)

    return wrapper


# ---------------------------------------------------------------------------
# Sync log helpers
# ---------------------------------------------------------------------------


def _read_sync_log() -> list[dict]:
    if not SYNC_LOG_PATH.exists():
        return []
    with open(SYNC_LOG_PATH) as f:
        return json.load(f)


def _append_sync_log(entry: dict):
    entries = _read_sync_log()
    entries.insert(0, entry)
    entries = entries[:200]  # keep last 200 entries
    with open(SYNC_LOG_PATH, "w") as f:
        json.dump(entries, f, indent=2)


# ---------------------------------------------------------------------------
# Public: delta sync endpoint (consumed by Flutter app, no admin key needed)
# ---------------------------------------------------------------------------


@app.get("/api/sync")
def delta_sync():
    since_str = request.args.get("since", "1970-01-01T00:00:00.000Z")
    db = get_db()
    rows = db.execute(
        """
        SELECT k.id, k.name, k.composer_id, k.raga_id, k.tala_id,
               k.language, k.composition_type, k.pallavi, k.anupallavi,
               k.charanam, k.source_url, k.search_tokens,
               k.updated_at
          FROM krithis k
         WHERE k.updated_at > ?
         ORDER BY k.updated_at ASC
         LIMIT 1000
        """,
        (since_str,),
    ).fetchall()
    return jsonify({"krithis": rows_to_list(rows), "count": len(rows)})


# ---------------------------------------------------------------------------
# Krithis CRUD
# ---------------------------------------------------------------------------


@app.get("/api/krithis")
@require_admin
def list_krithis():
    page = int(request.args.get("page", 1))
    per_page = min(int(request.args.get("per_page", 50)), 200)
    q = request.args.get("q", "").strip()
    offset = (page - 1) * per_page
    db = get_db()
    if q:
        rows = db.execute(
            """
            SELECT k.id, k.name, k.language, k.composition_type,
                   c.name AS composer_name, r.name AS raga_name, t.name AS tala_name,
                   k.updated_at
              FROM krithis k
              LEFT JOIN composers c ON c.id = k.composer_id
              LEFT JOIN ragas r ON r.id = k.raga_id
              LEFT JOIN talas t ON t.id = k.tala_id
             WHERE k.name LIKE ? OR c.name LIKE ? OR r.name LIKE ?
             ORDER BY k.name
             LIMIT ? OFFSET ?
            """,
            (f"%{q}%", f"%{q}%", f"%{q}%", per_page, offset),
        ).fetchall()
        total = db.execute(
            """
            SELECT COUNT(*) FROM krithis k
              LEFT JOIN composers c ON c.id = k.composer_id
              LEFT JOIN ragas r ON r.id = k.raga_id
             WHERE k.name LIKE ? OR c.name LIKE ? OR r.name LIKE ?
            """,
            (f"%{q}%", f"%{q}%", f"%{q}%"),
        ).fetchone()[0]
    else:
        rows = db.execute(
            """
            SELECT k.id, k.name, k.language, k.composition_type,
                   c.name AS composer_name, r.name AS raga_name, t.name AS tala_name,
                   k.updated_at
              FROM krithis k
              LEFT JOIN composers c ON c.id = k.composer_id
              LEFT JOIN ragas r ON r.id = k.raga_id
              LEFT JOIN talas t ON t.id = k.tala_id
             ORDER BY k.name
             LIMIT ? OFFSET ?
            """,
            (per_page, offset),
        ).fetchall()
        total = db.execute("SELECT COUNT(*) FROM krithis").fetchone()[0]
    return jsonify({"items": rows_to_list(rows), "total": total, "page": page, "per_page": per_page})


@app.get("/api/krithis/<int:kid>")
@require_admin
def get_krithi(kid: int):
    db = get_db()
    row = db.execute("SELECT * FROM krithis WHERE id = ?", (kid,)).fetchone()
    if not row:
        abort(404)
    return jsonify(dict(row))


@app.post("/api/krithis")
@require_admin
def create_krithi():
    data = request.get_json(force=True)
    now = datetime.now(timezone.utc).isoformat()
    db = get_db()
    cur = db.execute(
        """
        INSERT INTO krithis (name, composer_id, raga_id, tala_id, language,
                             composition_type, pallavi, anupallavi, charanam,
                             source_url, updated_at)
        VALUES (:name,:composer_id,:raga_id,:tala_id,:language,
                :composition_type,:pallavi,:anupallavi,:charanam,
                :source_url,:updated_at)
        """,
        {**data, "updated_at": now},
    )
    db.commit()
    return jsonify({"id": cur.lastrowid}), 201


@app.put("/api/krithis/<int:kid>")
@require_admin
def update_krithi(kid: int):
    data = request.get_json(force=True)
    now = datetime.now(timezone.utc).isoformat()
    db = get_db()
    db.execute(
        """
        UPDATE krithis
           SET name=:name, composer_id=:composer_id, raga_id=:raga_id,
               tala_id=:tala_id, language=:language,
               composition_type=:composition_type, pallavi=:pallavi,
               anupallavi=:anupallavi, charanam=:charanam,
               source_url=:source_url, updated_at=:updated_at
         WHERE id=:id
        """,
        {**data, "id": kid, "updated_at": now},
    )
    db.commit()
    return jsonify({"ok": True})


@app.delete("/api/krithis/<int:kid>")
@require_admin
def delete_krithi(kid: int):
    db = get_db()
    db.execute("DELETE FROM krithis WHERE id = ?", (kid,))
    db.commit()
    return jsonify({"ok": True})


# ---------------------------------------------------------------------------
# Ragas CRUD
# ---------------------------------------------------------------------------


@app.get("/api/ragas")
@require_admin
def list_ragas():
    q = request.args.get("q", "").strip()
    db = get_db()
    if q:
        rows = db.execute(
            "SELECT * FROM ragas WHERE name LIKE ? ORDER BY name LIMIT 200",
            (f"%{q}%",),
        ).fetchall()
    else:
        rows = db.execute("SELECT * FROM ragas ORDER BY name LIMIT 500").fetchall()
    return jsonify(rows_to_list(rows))


@app.get("/api/ragas/<int:rid>")
@require_admin
def get_raga(rid: int):
    row = get_db().execute("SELECT * FROM ragas WHERE id = ?", (rid,)).fetchone()
    if not row:
        abort(404)
    return jsonify(dict(row))


@app.post("/api/ragas")
@require_admin
def create_raga():
    data = request.get_json(force=True)
    db = get_db()
    cur = db.execute(
        """INSERT INTO ragas (name, arohana, avarohana, melakarta_number, parent_melakarta_id)
           VALUES (:name,:arohana,:avarohana,:melakarta_number,:parent_melakarta_id)""",
        data,
    )
    db.commit()
    return jsonify({"id": cur.lastrowid}), 201


@app.put("/api/ragas/<int:rid>")
@require_admin
def update_raga(rid: int):
    data = request.get_json(force=True)
    db = get_db()
    db.execute(
        """UPDATE ragas SET name=:name, arohana=:arohana, avarohana=:avarohana,
              melakarta_number=:melakarta_number, parent_melakarta_id=:parent_melakarta_id
            WHERE id=:id""",
        {**data, "id": rid},
    )
    db.commit()
    return jsonify({"ok": True})


@app.delete("/api/ragas/<int:rid>")
@require_admin
def delete_raga(rid: int):
    db = get_db()
    db.execute("DELETE FROM ragas WHERE id = ?", (rid,))
    db.commit()
    return jsonify({"ok": True})


# ---------------------------------------------------------------------------
# Composers CRUD
# ---------------------------------------------------------------------------


@app.get("/api/composers")
@require_admin
def list_composers():
    q = request.args.get("q", "").strip()
    db = get_db()
    if q:
        rows = db.execute(
            "SELECT * FROM composers WHERE name LIKE ? ORDER BY name LIMIT 200",
            (f"%{q}%",),
        ).fetchall()
    else:
        rows = db.execute("SELECT * FROM composers ORDER BY name LIMIT 500").fetchall()
    return jsonify(rows_to_list(rows))


@app.get("/api/composers/<int:cid>")
@require_admin
def get_composer(cid: int):
    row = get_db().execute("SELECT * FROM composers WHERE id = ?", (cid,)).fetchone()
    if not row:
        abort(404)
    return jsonify(dict(row))


@app.post("/api/composers")
@require_admin
def create_composer():
    data = request.get_json(force=True)
    db = get_db()
    cur = db.execute(
        "INSERT INTO composers (name, era, biography) VALUES (:name,:era,:biography)",
        data,
    )
    db.commit()
    return jsonify({"id": cur.lastrowid}), 201


@app.put("/api/composers/<int:cid>")
@require_admin
def update_composer(cid: int):
    data = request.get_json(force=True)
    db = get_db()
    db.execute(
        "UPDATE composers SET name=:name, era=:era, biography=:biography WHERE id=:id",
        {**data, "id": cid},
    )
    db.commit()
    return jsonify({"ok": True})


@app.delete("/api/composers/<int:cid>")
@require_admin
def delete_composer(cid: int):
    db = get_db()
    db.execute("DELETE FROM composers WHERE id = ?", (cid,))
    db.commit()
    return jsonify({"ok": True})


# ---------------------------------------------------------------------------
# Talas CRUD
# ---------------------------------------------------------------------------


@app.get("/api/talas")
@require_admin
def list_talas():
    rows = get_db().execute("SELECT * FROM talas ORDER BY name").fetchall()
    return jsonify(rows_to_list(rows))


@app.get("/api/talas/<int:tid>")
@require_admin
def get_tala(tid: int):
    row = get_db().execute("SELECT * FROM talas WHERE id = ?", (tid,)).fetchone()
    if not row:
        abort(404)
    return jsonify(dict(row))


@app.post("/api/talas")
@require_admin
def create_tala():
    data = request.get_json(force=True)
    db = get_db()
    cur = db.execute(
        "INSERT INTO talas (name, structure, aksharas_count) VALUES (:name,:structure,:aksharas_count)",
        data,
    )
    db.commit()
    return jsonify({"id": cur.lastrowid}), 201


@app.put("/api/talas/<int:tid>")
@require_admin
def update_tala(tid: int):
    data = request.get_json(force=True)
    db = get_db()
    db.execute(
        "UPDATE talas SET name=:name, structure=:structure, aksharas_count=:aksharas_count WHERE id=:id",
        {**data, "id": tid},
    )
    db.commit()
    return jsonify({"ok": True})


@app.delete("/api/talas/<int:tid>")
@require_admin
def delete_tala(tid: int):
    db = get_db()
    db.execute("DELETE FROM talas WHERE id = ?", (tid,))
    db.commit()
    return jsonify({"ok": True})


# ---------------------------------------------------------------------------
# Bulk JSON import
# ---------------------------------------------------------------------------


@app.post("/api/import")
@require_admin
def bulk_import():
    """
    Accepts a JSON array of raw krithi objects (scraped output format).
    Each item: { name, composer, raga, tala, language, composition_type,
                 pallavi, anupallavi?, charanam?, source_url? }
    Composer/raga/tala are resolved by name; created if missing.
    """
    records = request.get_json(force=True)
    if not isinstance(records, list):
        abort(400)

    db = get_db()
    now = datetime.now(timezone.utc).isoformat()
    inserted = 0
    updated = 0

    def _resolve_or_create(table: str, name: str) -> int:
        row = db.execute(f"SELECT id FROM {table} WHERE name = ?", (name,)).fetchone()
        if row:
            return row[0]
        cur = db.execute(f"INSERT INTO {table} (name) VALUES (?)", (name,))
        return cur.lastrowid

    for rec in records:
        composer_id = _resolve_or_create("composers", rec.get("composer", "Unknown"))
        raga_id = _resolve_or_create("ragas", rec.get("raga", "Unknown"))
        tala_id = _resolve_or_create("talas", rec.get("tala", "Unknown"))

        existing = db.execute(
            "SELECT id FROM krithis WHERE name = ? AND composer_id = ? AND raga_id = ?",
            (rec["name"], composer_id, raga_id),
        ).fetchone()

        if existing:
            db.execute(
                """UPDATE krithis SET pallavi=?, anupallavi=?, charanam=?,
                          language=?, composition_type=?, source_url=?, updated_at=?
                    WHERE id=?""",
                (
                    rec.get("pallavi", ""),
                    rec.get("anupallavi"),
                    rec.get("charanam"),
                    rec.get("language", ""),
                    rec.get("composition_type", "Krithi"),
                    rec.get("source_url"),
                    now,
                    existing[0],
                ),
            )
            updated += 1
        else:
            db.execute(
                """INSERT INTO krithis (name, composer_id, raga_id, tala_id,
                          language, composition_type, pallavi, anupallavi,
                          charanam, source_url, updated_at)
                   VALUES (?,?,?,?,?,?,?,?,?,?,?)""",
                (
                    rec["name"],
                    composer_id,
                    raga_id,
                    tala_id,
                    rec.get("language", ""),
                    rec.get("composition_type", "Krithi"),
                    rec.get("pallavi", ""),
                    rec.get("anupallavi"),
                    rec.get("charanam"),
                    rec.get("source_url"),
                    now,
                ),
            )
            inserted += 1

    db.commit()

    entry = {
        "type": "import",
        "timestamp": now,
        "inserted": inserted,
        "updated": updated,
        "total": len(records),
    }
    _append_sync_log(entry)

    return jsonify(entry), 201


# ---------------------------------------------------------------------------
# Scraper trigger (runs in background thread)
# ---------------------------------------------------------------------------

_scraper_lock = threading.Lock()
_scraper_running = False


@app.post("/api/scraper/run")
@require_admin
def run_scraper():
    global _scraper_running
    if not _scraper_lock.acquire(blocking=False):
        return jsonify({"ok": False, "error": "scraper already running"}), 409
    _scraper_running = True

    def _run():
        global _scraper_running
        try:
            start = datetime.now(timezone.utc).isoformat()
            log.info("Starting scraper…")
            result = subprocess.run(
                ["python", "scraper.py", "--start", "1000", "--end", "1010"],
                cwd=str(SCRAPER_DIR),
                capture_output=True,
                text=True,
                timeout=3600 * 14,  # 14-hour cap
            )
            end = datetime.now(timezone.utc).isoformat()
            entry = {
                "type": "scraper",
                "started_at": start,
                "finished_at": end,
                "returncode": result.returncode,
                "stdout_tail": result.stdout[-2000:],
                "stderr_tail": result.stderr[-2000:],
            }
            _append_sync_log(entry)
            log.info("Scraper finished rc=%s", result.returncode)
        except Exception as exc:
            log.exception("Scraper error: %s", exc)
            _append_sync_log(
                {"type": "scraper_error", "timestamp": datetime.now(timezone.utc).isoformat(), "error": str(exc)}
            )
        finally:
            _scraper_running = False
            _scraper_lock.release()

    threading.Thread(target=_run, daemon=True).start()
    return jsonify({"ok": True, "message": "scraper started in background"})


@app.get("/api/scraper/status")
@require_admin
def scraper_status():
    return jsonify({"running": _scraper_running})


# ---------------------------------------------------------------------------
# Sync log
# ---------------------------------------------------------------------------


@app.get("/api/sync-log")
@require_admin
def sync_log():
    limit = min(int(request.args.get("limit", 50)), 200)
    return jsonify(_read_sync_log()[:limit])


# ---------------------------------------------------------------------------
# Stats
# ---------------------------------------------------------------------------


@app.get("/api/stats")
@require_admin
def stats():
    db = get_db()
    return jsonify(
        {
            "krithis": db.execute("SELECT COUNT(*) FROM krithis").fetchone()[0],
            "ragas": db.execute("SELECT COUNT(*) FROM ragas").fetchone()[0],
            "composers": db.execute("SELECT COUNT(*) FROM composers").fetchone()[0],
            "talas": db.execute("SELECT COUNT(*) FROM talas").fetchone()[0],
            "scraper_running": _scraper_running,
        }
    )


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    app.run(host="0.0.0.0", port=port, debug=False)
