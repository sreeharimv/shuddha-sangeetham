# Shuddha Sangeetham — Admin CMS

Two components:

| Component | Path | Hosting |
|-----------|------|---------|
| Backend REST API | `backend/` | Home server via `ssh anjaneya` |
| Frontend SPA | `frontend/` | GitHub Pages |

---

## Backend Setup (home server)

```bash
cd admin/backend
pip install -r requirements.txt

export ADMIN_API_KEY=your-secret-key
export DB_PATH=/path/to/scraper/data/shuddha.db   # defaults to ../../scraper/data/shuddha.db
export PORT=8000

bash start.sh    # runs gunicorn on 0.0.0.0:8000
```

Expose via SSH tunnel from laptop:
```bash
ssh -N -L 8000:localhost:8000 anjaneya
```

Then the frontend (on GitHub Pages) connects to `http://localhost:8000`.

---

## Frontend Setup (GitHub Pages)

Push `admin/frontend/` to a `gh-pages` branch or configure GitHub Pages to serve the `admin/frontend/` folder.

The login screen asks for:
- **Backend URL** — `http://localhost:8000` (when using SSH tunnel) or public URL if exposed
- **API Key** — the `ADMIN_API_KEY` set on the server

---

## API Endpoints

### Public (no auth)
| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/sync?since=<ISO8601>` | Delta sync — consumed by Flutter app |

### Admin (requires `X-Admin-Key` header)
| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/stats` | Dashboard counts |
| GET/POST | `/api/krithis` | List / create krithis |
| GET/PUT/DELETE | `/api/krithis/<id>` | Read / update / delete |
| GET/POST | `/api/ragas` | List / create ragas |
| GET/PUT/DELETE | `/api/ragas/<id>` | Read / update / delete |
| GET/POST | `/api/composers` | List / create composers |
| GET/PUT/DELETE | `/api/composers/<id>` | Read / update / delete |
| GET/POST | `/api/talas` | List / create talas |
| GET/PUT/DELETE | `/api/talas/<id>` | Read / update / delete |
| POST | `/api/import` | Bulk JSON import |
| POST | `/api/scraper/run` | Trigger scraper (background) |
| GET | `/api/scraper/status` | Is scraper running? |
| GET | `/api/sync-log` | Last 200 scrape/import events |
