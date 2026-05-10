# Shuddha Sangeetham — Claude Context

Offline Carnatic music reference app. Primary use case: a rasika in a concert hall, no internet, wants to find a krithi in under 5 seconds. Ships with ~20,000 krithis fully bundled — 100% offline from first install.

Full spec: `shuddha_sangeetham_spec.md` in repo root.

## Stack
- Flutter (Dart) — UI
- Riverpod — state management
- Drift — type-safe SQLite ORM with code generation
- SQLite FTS5 — full-text search with trigram tokenizer
- `build_runner` — code generation for Drift tables, DAOs, and data classes
- Package ID: `com.shuddhasangeetham.app`
- Min SDK: Android API 21 / iOS 13

## Key Directories
- `lib/data/` — Drift database, DAOs, models, seed data
- `lib/features/` — feature modules: `home/`, `browse/`, `krithi/`, `bookmarks/`, `profile/`, `main/`
- `lib/core/` — shared theme, utilities
- `scraper/` — Python scraper + normalize pipeline that builds the seed SQLite DB
- `test/` — unit tests

## Navigation (4 bottom tabs)
1. **Home** — prominent search bar (concert hall mode), featured krithis
2. **Browse** — full alphabetical krithi list, sort + filter
3. **Bookmarks** — locally saved krithis, offline always
4. **Profile** — dark mode toggle, text size, about/credits, delta sync trigger

**Krithi Detail Page** — name, composer, raga, tala, language, type; labelled lyric sections (pallavi / anupallavi / charanam); bookmark button; karnatik.com link.

## Data Models (Drift tables)
| Table | Purpose |
|---|---|
| `Krithi` | Core composition — name, composer_id, raga_id, tala_id, language, composition_type, pallavi, anupallavi, charanam, source_url |
| `Composer` | name, name_variants (JSON), era, biography |
| `Raga` | name, name_variants (JSON), arohana, avarohana, melakarta_number, parent_melakarta_id |
| `Tala` | name, name_variants, structure, aksharas_count |
| `Artist` | name, name_variants (JSON), instrument — v2 feature, schema ready |
| `SearchAlias` | entity_type + entity_id + alias — backbone of fuzzy spelling tolerance |
| `Concert` / `ConcertArtist` / `ConcertAttendee` | v2 performance log — schema present, UI deferred |
| `User` | v2 auth — schema present, no auth in v1 |

## Search Engine (Session 3 — complete)
Three methods in the search repository:
1. `quickSearch(query)` — FTS5 over name + raga + composer, target < 200ms
2. `lyricsSearch(query)` — FTS5 over pallavi/anupallavi/charanam, target < 500ms
3. `filterSearch(raga, composer, tala, language, type)` — combined filter queries

SearchAlias table seeded with curated spelling variants (Thyagaraja→Tyagaraja, Bhairawi→Bhairavi, etc.). FTS5 trigram tokenizer handles substring matching. Zero network calls.

## Session Progress
| Session | Feature | Status |
|---|---|---|
| 1 | Project scaffold — folder structure, pubspec, Drift schema, placeholder screens | ✅ Done |
| 2 | Python scraper + normalize pipeline | ✅ Done |
| 3 | SQLite FTS5 search engine + unit tests | ✅ Done |
| 4 | Home screen + search UI | ✅ Done |
| 5 | Browse screen | ✅ Done |
| 6 | Krithi Detail Page | ✅ Done |
| 7 | Bookmarks screen | ✅ Done |
| 8 | Settings / Profile screen | ✅ Done |
| 9 | Delta sync | ✅ Done |
| 10 | Admin CMS | ✅ Done |
| 11 | Polish + testing | ✅ Done |

## v1 Scope Constraints
- **No user accounts / auth in v1** — all features work as guest, bookmarks stored locally
- **No Performance Log UI in v1** — Concert/Artist tables in schema but deferred to v2
- **English only** — all content in transliterated English; architecture supports future scripts

## Pre-submission Checklist (Session 11 complete — pending manual steps)
- [ ] `dart run flutter_launcher_icons` — generate icon sizes
- [ ] `dart run flutter_native_splash:create` — generate native splash
- [ ] Test on low-end Android (2GB RAM) in release mode
- [ ] Capture screenshots for store listings (see `store_listing/`)
- [ ] Design feature graphic (1024×500px, brief in `store_listing/play_store_listing.md`)
- [ ] `flutter build appbundle --release` / `flutter build ipa --release`
- [ ] Send karnatik.com courtesy email

## Dependency Rule
Add all required packages in a single `pubspec.yaml` edit before running `build_runner`.

## Code Generation
Run after any Drift schema or model change:
```
dart run build_runner build --delete-conflicting-outputs
```

## UI Constraints
- Search bar is the most prominent element on Home
- Both light and dark mode fully supported from v1
- Large tap targets — one-hand usable for concert hall use
- Lyrics text: generous font size, good line height
- No heavy animations — must feel instant on mid-range Android (2GB RAM)
