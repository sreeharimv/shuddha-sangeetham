# Shuddha Sangeetham — App Specification
> Version: 0.2  
> Last updated: March 2026  
> Framework: Flutter (Android + iOS)

---

## 1. Overview

**Shuddha Sangeetham** is a cross-platform mobile application (Android & iOS) built for the full spectrum of Carnatic music lovers — students, practicing musicians, rasikas, and scholars. Its killer use case is simple: **a rasika sitting in a concert hall, no internet connection, wants to instantly look up a krithi being performed** — by name, raga, composer, or even a lyric phrase they just heard.

The app ships with a database of **~20,000 krithis** fully bundled on-device, making it completely offline-capable from the moment of install. It also allows registered users to log real-world concert performances against krithis, building a living community archive of Carnatic music over time.

---

## 2. Goals

- Be the most complete offline Carnatic music reference on mobile
- Serve all levels: beginner to scholar, student to researcher
- Work **100% offline** after install — no internet needed for core features
- Provide the fastest, most forgiving search experience for concert-hall use
- Allow registered users to contribute real-world concert performance data
- Be content-maintainable via an Admin CMS backend

---

## 3. Platform & Technology

| Decision | Choice | Rationale |
|---|---|---|
| Platform | Android + iOS | Simultaneous launch |
| Framework | **Flutter** | Best for offline-first, consistent cross-platform UI, rich text rendering |
| Language | Dart | Type-safe, ideal for complex domain models |
| Local DB | **SQLite via `drift`** | Reliable, fast offline storage with type-safe queries |
| Full-Text Search | **SQLite FTS5** | Built-in, fully offline, supports trigram/substring matching |
| State Management | Riverpod | Scalable, testable, strong Flutter community support |
| Backend | REST API + Admin CMS | Content management + user auth + performance log sync |
| Auth | None in v1 | Deferred to v2 along with performance log |
| Content Sync | **Delta sync** | Pull only new/changed krithis when online — no full app update required |

---

## 4. Target Audience

- **Students & beginners** — learning about ragas, talas, composers
- **Practicing musicians** — quick offline reference for krithis, lyrics, raga details
- **Rasikas (enthusiasts)** — identifying krithis at concerts, logging performances
- **Scholars & researchers** — deep content, performance history, composer exploration

---

## 5. Language Support

- **English only** for v1 — UI and all content in transliterated English
- Original lyrics displayed in transliterated form (e.g. Telugu/Sanskrit/Tamil written in English script, as on karnatik.com)
- Architecture must support future addition of Tamil, Telugu, Sanskrit/Devanagari scripts

---

## 6. Core Features (v1)

> **Scope:** Kept intentionally simple. Performance Log moved to v2.

### 6.1 Krithi / Composition Database

The heart of the app. Every krithi entry contains:

| Field | Description |
|---|---|
| Name | Transliterated English |
| Composer | Name + era |
| Raga | Name (linked to raga detail) |
| Tala | Name |
| Language | Telugu / Sanskrit / Tamil / Kannada / Other |
| Composition type | Krithi / Varnam / Geetam / Swarajati / Other |
| Pallavi | First section of lyrics |
| Anupallavi | Second section (where present) |
| Charanam | Third section / verses |

**UI:**
- Browsable, scrollable list — sorted alphabetically by default
- Filter chips for raga, composer, tala, language, composition type
- Tap any krithi → full detail page
- Bookmark button on every krithi

---

### 6.2 Search & Filter *(Most Critical Feature)*

> **Primary use case:** Rasika in a concert hall, no internet, one hand on phone, wants to find a krithi in under 5 seconds.

---

#### Search Dimensions

| Dimension | Example | Behaviour |
|---|---|---|
| Krithi name | "Nagumomu", "Yochana" | Partial match from any position |
| Raga name | "Bhairavi", "Kalyani" | Fuzzy — tolerates spelling variants |
| Composer name | "Tyagaraja", "Dikshitar" | Fuzzy — many spelling variants exist |
| Lyrics phrase | "pahimam", "ninnu vinaga" | Full-text search across pallavi/anupallavi/charanam |
| Tala | "Adi", "Rupakam" | Filter / dropdown |
| Language | Telugu, Sanskrit, Tamil, Kannada | Multi-select filter chips |

---

#### Search Modes

**1. Quick Search — Default / Concert Hall Mode**
- Prominent search bar on the home screen, always visible
- Searches krithi name + raga + composer simultaneously as user types
- Results appear with ~200ms debounce — feels instant
- Minimum 2 characters to trigger
- Designed for one-hand use — large tap targets, no fiddly controls

**2. Lyrics Search**
- Toggle within the search bar ("Search in lyrics")
- Searches across pallavi, anupallavi, and all charanams
- Returns matching krithis with the matching line highlighted in context
- Slightly slower (~500ms) but still fully offline

**3. Advanced Filter**
- Filter icon alongside the search bar
- Combine any number of filters simultaneously:
  - Raga (searchable dropdown)
  - Composer (searchable dropdown)
  - Tala (dropdown)
  - Language (multi-select chips)
  - Composition type (multi-select chips)
- Active filters shown as dismissible chips above results
- Filter state persists within the session

---

#### Fuzzy Matching & Spelling Tolerance

Carnatic music has no single standard transliteration. The same raga or composer can be spelled many different ways. The search engine must handle this silently — users should never have to think about spelling.

**Examples the system must handle:**

| Canonical | Variants users may type |
|---|---|
| Tyagaraja | Thyagaraja, Tyagarajan, Tyagayya |
| Muttuswami Dikshitar | Dikshithar, Diksitar, Muthuswami |
| Bhairavi | Bhairawi, Bairavi, Bhyravi |
| Kalyani | Kalyanee, Kalyanii |
| Nagumomu | Nagumommu, Nagumamu |
| Adi | Aadi, Aditalam |
| Shankarabharanam | Shankarabharnam, Sankarabharanam |

**Implementation:**
- `SearchAlias` table ships with the app — curated lookup of canonical names → all known spelling variants
- SQLite FTS5 with trigram tokenizer enables substring matching ("bhair" finds "Bhairavi")
- Normalization layer strips diacritics before matching
- Zero network calls — entirely handled in local SQLite

---

#### Search Result Card

```
┌─────────────────────────────────────────┐
│ Nagumomu Ganaleni                  🔖   │
│ Raga: Abheri  ·  Tala: Adi              │
│ Composer: Tyagaraja  ·  Telugu          │
│ "nagumomu ganalEni nA bhAgyamE..."      │  ← shown only in lyrics search mode
└─────────────────────────────────────────┘
```

**Result ranking:**
1. Exact krithi name match
2. Partial krithi name match (starts with)
3. Partial krithi name match (contains)
4. Raga or composer match
5. Lyrics match

**No results state:** Suggests checking alternate spellings, or shows krithis in the closest matching raga.

---

#### Search Performance Targets

| Operation | Target |
|---|---|
| Name / raga / composer search | < 200ms |
| Lyrics full-text search | < 500ms |
| App launch → search ready | < 2 seconds |
| Minimum supported device | Mid-range Android, 2GB RAM |

---

### 6.3 Bookmarks / Favorites

- Any user (guest or registered) can bookmark krithis
- Bookmarks stored locally on device — always available offline
- Dedicated **Bookmarks tab** in bottom navigation
- Registered users: bookmarks optionally synced to their account across devices

---

### 6.4 Dark Mode

- Full dark mode from v1
- Follows system setting by default
- Manual override toggle in Settings
- All screens, modals, and lyric text fully styled for both modes

---

### 6.5 Performance Log *(Moved to v2)*

> The performance logging feature — allowing users to log real-world concert performances against krithis — has been intentionally moved to v2 to keep the v1 scope clean and focused.

**What's designed and ready for v2:**
- `Concert`, `ConcertArtist`, `ConcertAttendee` data models (already in schema — see Section 8)
- Auto-merge logic for duplicate concert entries (same artist + date + krithi)
- Artist as first-class entity with alias/variant resolution
- Attendee count display ("38 rasikas logged this")

See Section 14 (Future Scope) for the full v2 feature description.

---

## 7. Data Source

### 7.1 Sources — Hybrid Pipeline

**Primary source: karnatik.com.** [karnatik.com](https://www.karnatik.com) is a 30-year-old Carnatic music reference with 20,000+ krithis and full lyrics in plain-English transliteration (the form rasikas actually use), maintained by a passionate individual contributor (rani) since 1995.

**Supplementary source: `ramanarunachalam/Music` (GitHub JSON).** Contains 12,009 song records with richer structured metadata (deity, tala angas, tala count). Lyrics in this dataset are in SLP1 academic diacritics — not plain English — so they are used **only** for metadata enrichment of records already scraped from karnatik.com. Matching is done via the karnatik.com URL embedded in the JSON. Records with no karnatik.com match are discarded.

**Why this is legally clean:**
- Krithi names, raga names, composer names, tala names → **facts, not copyrightable**
- The original lyrics (Tyagaraja, Dikshitar, Syama Sastri, etc.) → **200+ years old, fully public domain**
- Translations / meanings → **not used in this app at all**
- The site explicitly offers a downloadable PDF index described as "a useful guide at concerts or at home"

**Data available per krithi page (`karnatik.com/cXXXX.shtml`):**

| Field | Notes |
|---|---|
| Krithi name | Transliterated English |
| Raga | With arohana & avarohana |
| Tala | |
| Composer | Linked to composer bio |
| Language | |
| Composition type | Varnam, Geetam, Krithi etc. |
| Pallavi | |
| Anupallavi | Where present |
| Charanam(s) | One or more verses |

**Raga data:** 1,000+ ragas with melakarta info and arohana/avarohana — at `karnatik.com/ragas.shtml`

**Composer data:** Hundreds of composers with bios — at `karnatik.com/composers.shtml`

**Attribution:** The app's About page and each krithi detail page will carry a clear credit to karnatik.com as the reference source.

---

### 7.2 Data Pipeline

```
karnatik.com
     │
     ├── compositions2.pdf  ──→  ~5,000 krithis (name + raga + composer)
     │                            used as index / cross-reference
     │
     └── c1000.shtml → c20000+   ──→  ~20,000 krithis with full lyrics
                │
                ▼
        Python scraper script
        - Polite: 1 page per 2–3 seconds
        - Runs overnight (~12–14 hours for full corpus)
        - Re-run monthly to pick up new additions
                │
                ▼
        Raw JSON output per krithi
                │
                ▼
        Cleaning & normalization script
        - Deduplicate entries
        - Normalize raga / composer / tala names
        - Detect language and composition type
        - Generate SearchAlias variants table
        - Strip any translation/meaning fields (not needed)
                │
                ▼
        SQLite database
        + FTS5 index built at pipeline time
                │
                ▼
        Bundled into Flutter app at build time
                │
                ▼  (when user is online)
        Delta sync — pull new/updated krithis from backend CMS
```

---

### 7.3 App Size & Storage

| Component | Size |
|---|---|
| 20,000 krithis — raw text data | ~15 MB |
| FTS5 full-text search index | ~25 MB |
| Raga / composer / tala tables + indexes | ~2 MB |
| **Total SQLite database** | **~40 MB** |
| Flutter framework + compiled Dart code | ~12 MB |
| UI assets, fonts, icons | ~2 MB |
| **Total app download (compressed)** | **~30–35 MB** |

**Context:** WhatsApp is ~45 MB. This is well within normal expectations for a content-rich app.

**FTS trade-off:** The FTS5 index adds ~25 MB but enables sub-500ms offline lyrics search across 20,000 krithis. This is non-negotiable for the concert hall use case.

**Further optimisation options if needed:**
- `VACUUM` + `PRAGMA page_size` tuning can reduce DB size by ~20%
- FTS index can be scoped to name/raga/composer only (drop lyrics FTS) to save ~15 MB — but this removes lyrics phrase search

---

## 8. Data Models

```
Krithi
  - id
  - name                     (transliterated English)
  - search_tokens            (normalized + variant spellings for FTS indexing)
  - composer_id → Composer
  - raga_id → Raga
  - tala_id → Tala
  - language                 (telugu | sanskrit | tamil | kannada | other)
  - composition_type         (krithi | varnam | geetam | swarajati | other)
  - deity                    (deity associated with the composition, nullable)
  - pallavi
  - anupallavi               (nullable)
  - charanam                 (nullable — full text, may contain multiple charanams)
  - source_url               (e.g. karnatik.com/c1000.shtml — for reference & updates)
  - created_at
  - updated_at

Composer
  - id
  - name
  - name_variants            (JSON array of alternate spellings)
  - era                      (e.g. "18th century" or "1767–1847")
  - biography                (short paragraph)
  - language_of_compositions

Raga
  - id
  - name
  - name_variants            (JSON array of alternate spellings)
  - arohana
  - avarohana
  - melakarta_number         (if melakarta raga)
  - parent_melakarta_id      (if janya raga, FK to another Raga)
  - characteristics          (short description of mood / feel)

Tala
  - id
  - name
  - name_variants
  - structure                (anga breakdown, e.g. "laghu + drutam + drutam")
  - aksharas_count

Artist
  ← First-class entity. Solves spelling variants the same way Raga/Composer does.
  - id
  - name                     (canonical display name, e.g. "T.M. Krishna")
  - name_variants            (JSON array — e.g. ["TM Krishna", "TMK", "T M Krishna"])
  - instrument               (vocal | violin | mridangam | flute | veena | other)
  - biography                (short, optional)
  - created_at
  ← SearchAlias table also covers Artist — "TMK" → artist_id for T.M. Krishna

SearchAlias
  ← Backbone of fuzzy search. Seeded at build time from curated + auto-generated list.
  - id
  - entity_type              (krithi | raga | composer | tala | artist)
  - entity_id
  - alias                    (alternate spelling / abbreviation / misspelling)

Concert
  ← One record per unique real-world performance. Replaces old PerformanceLog.
  - id
  - krithi_id → Krithi
  - raga_id → Raga           (may differ from krithi default — e.g. manodharma raga)
  - venue
  - city
  - sabha_name               (nullable)
  - performance_date
  - attendee_count           (incremented when duplicate entries are merged)
  - status                   (active | flagged | removed — supports v2 moderation)
  - created_by_user_id → User
  - created_at
  - updated_at

ConcertArtist
  ← Junction table — a concert can have multiple artists (vocalist + accompanists)
  - id
  - concert_id → Concert
  - artist_id → Artist
  - role                     (main | accompanist — optional)

ConcertAttendee
  ← One record per user who logged / confirmed this concert
  - id
  - concert_id → Concert
  - user_id → User
  - created_at

User
  - id
  - display_name
  - email
  - role                     (user | admin)
  - created_at
```

---

## 9. App Navigation Structure

```
Bottom Navigation Bar (4 tabs)
│
├── 🏠  Home
│       - Prominent search bar (always visible, concert hall mode)
│       - Featured / Editor's pick krithis
│       - Recently added krithis
│       - Quick filter chips (language, top composers)
│
├── 📖  Browse
│       - Full krithi list (alphabetical default)
│       - Sort options: A–Z / By Raga / By Composer
│       - Filter: Raga, Composer, Tala, Language, Type
│       - Tap krithi → Krithi Detail Page
│
├── 🔖  Bookmarks
│       - Saved krithis (stored locally)
│       - Sorted by most recently bookmarked
│       - Searchable within bookmarks
│
└── 👤  Profile
        - Login / Register
        - My submitted performances
        - Settings: Dark mode toggle, text size
        - About / Credits (karnatik.com attribution)


Krithi Detail Page
│
├── Header: Name · Composer · Raga · Tala · Language · Type · Deity (if present)
├── [ 🔖 Bookmark ]
├── Lyrics
│       ├── Pallavi
│       ├── Anupallavi (if present)
│       └── Charanam(s)
└── Performances  ← v2 only, not shown in v1
```

---

## 10. Offline Strategy

| Data | Storage | Offline available? |
|---|---|---|
| All krithis (name, raga, composer, lyrics) | Bundled SQLite DB | ✅ Always — from first launch |
| Raga, composer, tala reference tables | Bundled SQLite DB | ✅ Always |
| FTS5 search index | Bundled SQLite DB | ✅ Always |
| Bookmarks | Local device storage | ✅ Always |
| Performance logs | Not in v1 — see v2 | — |
| New / updated krithis | Delta sync on app open | ✅ After sync |

**First launch experience:**
- App ships with full SQLite database pre-bundled — no setup, no download screen
- User can search all 20,000 krithis immediately after install
- If online, delta sync runs silently in the background

---

## 11. Content Updates — Delta Sync

New krithis and corrections are delivered to users without an app store update.

**Flow:**
1. Admin runs scraper → new/updated krithis added to backend DB via CMS
2. Each krithi record has an `updated_at` timestamp
3. On app open (if online): app sends its latest `updated_at` to backend API
4. Backend returns only records changed since that timestamp
5. App merges into local SQLite — user never interrupted
6. Runs silently in background

**Cadence:** Monthly scraper re-run, or on-demand when corrections are needed.

---

## 12. User Accounts

**v1 — No user accounts required.**

The entire app is usable as a guest — browse, search, bookmark. No login, no registration screen, no auth complexity in v1.

| Type | v1 Capabilities |
|---|---|
| **Guest (all users)** | Browse all krithis, search, bookmark locally, dark mode |
| **Admin** | Web CMS access only — manage content |

- User registration and login deferred to v2 (required for performance log)
- Bookmarks stored locally on device — no sync needed in v1
- Significantly simplifies v1 architecture — no auth backend, no JWT, no Firebase

---

## 13. Admin CMS

Separate web-based panel (not part of the mobile app):

- Add / edit / delete Krithis, Ragas, Composers, Talas
- View and moderate PerformanceLog entries (v2)
- Manage user accounts and roles
- Upload scraper output (CSV/JSON) to bulk-import new krithis
- Trigger delta sync push to mobile clients

---

## 14. Product Roadmap

### Phase 1 — App (Current)
Core offline reference app. The primary product.

| Feature | Status |
|---|---|
| Scraper + data pipeline (karnatik.com) | 🔲 To build |
| SQLite database + FTS5 search index | 🔲 To build |
| Flutter app — krithi browse & search | 🔲 To build |
| Bookmarks, dark mode | 🔲 To build |
| Admin CMS — manage content, trigger scraper | 🔲 To build |

---

### Phase 2 — Website (After app launch)
Companion website at shuddhasangeetham.in. Same content, browser experience, additional media.

| Feature | Status |
|---|---|
| GitHub Pages setup + custom domain | 🔲 To build |
| Static site (Hugo) — krithi & raga pages | 🔲 To build |
| MP3 raga index + inline audio player | 🔲 To build |
| YouTube channel embed | 🔲 To build |
| Social media embeds | 🔲 To build |
| Admin CMS extended for website content | 🔲 To build |

---

### Phase 3 — Community (After website)
User accounts and community-powered features on both app and website.

| Feature | Status |
|---|---|
| User registration & login | 🔲 To build |
| Performance log — log concerts against krithis | 🔲 To build |
| Concert deduplication & attendee count | 🔲 To build |
| Artist profile pages | 🔲 To build |
| Community moderation (flag / review entries) | 🔲 To build |
| Bookmark sync across devices | 🔲 To build |

---

### Phase 4 — Enrichment (Future)
Deeper content and discovery features.

| Feature | Notes |
|---|---|
| 🎵 Audio examples | Raga phrases, reference recordings per krithi |
| 🎼 Swara notations | Display swaras per krithi |
| 🎙️ Raga explorer | Arohana/avarohana, gamaka descriptions, characteristic phrases |
| 🧠 Quiz / learning mode | Identify raga, composer, fill-in-the-lyric |
| 📅 Concert calendar | Upcoming Carnatic events near user |
| 🌐 Multilingual UI | Tamil, Telugu, Sanskrit/Devanagari |
| 💰 Monetization | Freemium, one-time purchase, or subscription — TBD |

---

## 15. Remaining Open Questions

- [ ] **Package ID** — finalise before scaffolding: `com.shuddhasangeetham.app` or similar
- [ ] **Backend hosting** — where will the REST API and Admin CMS be hosted? (Railway, Render, AWS etc.)
- [ ] **Performance log moderation v2** — define the exact moderation flow before v2 development begins
- [ ] **App icon & branding** — visual identity for Shuddha Sangeetham
- [ ] **MP3 storage** — Cloudflare R2 vs Internet Archive vs other. Affects website player implementation.
- [ ] **Admin panel hosting** — Decap CMS on GitHub Pages vs separate backend on Railway/Render. Affects overall backend architecture.
- [ ] **Website tech stack** — plain HTML/CSS/JS on GitHub Pages, or a static site generator (Hugo, Astro, Jekyll)? Affects how easy it is to maintain 20,000 krithi pages.

---

## 16. Success Metrics (v1)

| Metric | Target |
|---|---|
| App store rating | ≥ 4.5 stars |
| Krithi database at launch | ~20,000 krithis with full lyrics |
| Offline coverage | 100% of core content — zero internet needed |
| Search speed (name / raga / composer) | < 200ms on mid-range Android |
| Search speed (lyrics) | < 500ms on mid-range Android |
| App download size | ≤ 40 MB |
| Performance logs | Community begins contributing within first month of launch |

---

## 18. Website — shuddhasangeetham.in

A companion website to the mobile app, serving the same content with additional features suited to a desktop/browser experience.

---

### Hosting Architecture

```
shuddhasangeetham.in            → GitHub Pages (free, static)
  ├── Krithi pages              → All ~20,000 krithis, searchable
  ├── Raga index + MP3 player   → Audio files on TBD storage (see Open Questions)
  ├── YouTube channel embed     → Latest uploads auto-displayed
  ├── Social media embeds       → Latest posts from Instagram/Facebook
  ├── Blog / articles           → Static markdown content
  └── About / Credits           → karnatik.com attribution

admin.shuddhasangeetham.in      → TBD (see Open Questions)
  ├── Manage krithis, ragas     → Same Admin CMS used by the mobile app
  ├── Manage MP3 index          → Upload / organise raga folders
  └── Trigger scraper           → One-click karnatik.com sync

MP3 storage                     → TBD (see Open Questions)
```

---

### GitHub Pages — What works, what doesn't

| Capability | Works on GitHub Pages? |
|---|---|
| Static content pages (krithis, ragas) | ✅ Yes |
| Client-side search (JavaScript) | ✅ Yes |
| MP3 player (files hosted elsewhere) | ✅ Yes |
| YouTube / social media embeds | ✅ Yes |
| Blog / markdown articles | ✅ Yes |
| Custom domain (shuddhasangeetham.in) | ✅ Yes |
| Admin panel / backend logic | ❌ No — needs separate hosting |
| User accounts / database writes | ❌ No — needs separate hosting |

---

### MP3 Raga Index

A large collection of Carnatic MP3 recordings organised by raga — e.g. a folder called "Kalyani" contains krithis in Kalyani raga.

**On the website:**
- Browsable raga-wise index — click a raga → see all available recordings
- Inline audio player — listen without downloading
- Linked from the corresponding raga and krithi pages in the app and website
- Mirrors the app's offline raga/krithi structure

**Storage options under consideration:**
- **Cloudflare R2** — free tier (10GB, 10M requests/month), direct streaming, no egress fees
- **Internet Archive** — free, unlimited, community-trusted, widely used in the Carnatic community
- Decision deferred — see Open Questions

---

### Admin Panel

Needs a backend — cannot run on GitHub Pages. Options under consideration:

- **Decap CMS on GitHub Pages** — simplest setup, no separate server, commits changes directly to GitHub repo. Best if content updates are infrequent.
- **Separate backend on Railway / Render** — more powerful, same backend the mobile app uses, supports scraper trigger, user management. Best for long-term scalability.

Decision deferred — see Open Questions.

---

### Social Media & YouTube Integration

- **YouTube channel** — embed latest videos on homepage using YouTube Data API or simple iframe playlist embed
- **Instagram / Facebook** — official embed widgets for latest posts
- All embeds are static-friendly — work perfectly on GitHub Pages

---

### Website vs App — Content Overlap

| Content | App | Website |
|---|---|---|
| Krithi database (~20,000) | ✅ Offline | ✅ Online |
| Search & filter | ✅ | ✅ |
| Raga index | ✅ Reference | ✅ + MP3 player |
| YouTube / Social embeds | ❌ | ✅ |
| Blog / articles | ❌ | ✅ |
| Performance log (v2) | ✅ | ✅ Future |
| Admin CMS | ❌ | ✅ |

The website and app share the **same database and content pipeline** — one scraper run updates both.

---

## 19. UI & Design

UI design is intentionally left open for Claude Code to implement and iterate on during development. The following constraints apply:

- **Both light and dark mode** must be fully supported from v1
- **Lyrics text** must be comfortably readable — generous font size, good line height
- **Search bar** must be the most prominent element on the Home screen
- **One-hand usability** — key actions reachable without stretching (concert hall use case)
- **No heavy animations** — app must feel instant, especially on mid-range Android devices

Everything else — color palette, typography, card design, iconography — is left to Claude Code's discretion and will be iterated on during development.

---

## 20. Deployment & Costs

### App Store Accounts

| Platform | Cost | Notes |
|---|---|---|
| Google Play Store | **$25 one-time** | Lifetime, no renewal |
| Apple App Store | **$99/year** | Must renew annually or app is removed |

**Launch strategy:** Build for both platforms simultaneously (Flutter, one codebase). Submit Android first, then iOS ~1 week later. Android review is faster and more forgiving — lets you catch production bugs before the stricter Apple review.

---

### Infrastructure

| Service | Purpose | Cost |
|---|---|---|
| Railway or Render | Backend API + Admin CMS | Free tier (sufficient for early stage) |
| PostgreSQL | Backend database | Free tier |
| GitHub Pages | Website hosting (Phase 2) | Free |
| Cloudflare R2 | MP3 storage (Phase 2) | Free up to 10GB |
| Domain (shuddhasangeetham.in) | `.in` domain (Phase 2) | ~₹1,000/year (~$10) |

---

### Cost Summary

| Phase | One-time | Annual |
|---|---|---|
| Phase 1 — App | $25 (Play Store) | $99 (Apple) + $0 (backend free tier) |
| Phase 2 — Website | — | ~$10 (domain) |
| Phase 3+ — Community | — | Monitor; scale backend if free tier exceeded |
| **Total Year 1 (app + website)** | **$25** | **~$110** |

The only unavoidable significant cost is the **$99/year Apple Developer fee**. Everything else runs on free tiers comfortably for an early-stage niche app.

---

## 21. Developer Account Strategy

Shuddha Sangeetham is one of multiple apps planned under different brands. The recommended approach is a single **umbrella studio account** covering all apps.

### Recommended Structure

```
Developer: [YourName] Labs  (one account, all apps)
    │
    ├── Shuddha Sangeetham   (Carnatic music reference)
    ├── [Cricket auction platform]
    └── [Future apps]
```

### Account Setup Plan

| Platform | Account Type | Cost | Action |
|---|---|---|---|
| Google Play | "[YourName] Labs" | $25 one-time | Create now — covers all future apps |
| Apple (immediate) | Individual | $99/year | Use for Shuddha Sangeetham launch — fastest path |
| Apple (long-term) | Organization | $99/year | Upgrade after registering sole proprietorship |

### Registering the Studio (India)
- **Udyam (MSME) registration** — free, done online in 1 day
- Register as sole proprietorship with trade name e.g. "[YourName] Labs"
- No Pvt Ltd required — sole proprietorship is sufficient for Apple Organization account
- Once registered, upgrade Apple Individual → Organization (one-time, no extra cost)

### Portfolio Note
All apps built under the studio are visible as a unified body of work — useful for consulting clients who want to see shipped products, not just advisory work.

---

---

## 22. How to Build This with Claude Code

### Setup
1. Create GitHub repo: `shuddha-sangeetham` (personal account, can transfer to studio later)
2. Add this document to the repo root as `SPEC.md`
3. Open Claude Code and point it at the repo

### Golden Rules
- **One session = one concern.** Never ask Claude Code to build everything at once.
- **Always start each session** with the 5-line context header below.
- **Paste only the relevant spec section** for that session — not the full document.
- **Review and commit** after each session before starting the next.

### Standard Session Header
Paste this at the top of every Claude Code session:
```
App: Shuddha Sangeetham
Package ID: com.shuddhasangeetham.app
Framework: Flutter + drift (SQLite) + Riverpod
Repo: github.com/[yourname]/shuddha-sangeetham
Full spec: SPEC.md in repo root
```

---

### Session 1 — Project Scaffold
**Spec sections to include:** Section 3 (Tech Stack), Section 8 (Data Models)

**Prompt:**
```
App: Shuddha Sangeetham
Package ID: com.shuddhasangeetham.app
Framework: Flutter + drift (SQLite) + Riverpod
Repo: github.com/[yourname]/shuddha-sangeetham
Full spec: SPEC.md in repo root

Set up the Flutter project:
- Folder structure following Flutter best practices (features/, data/, core/)
- pubspec.yaml with all dependencies: drift, riverpod, sqflite, path_provider
- SQLite schema using drift for all tables in Section 8 of the spec
- Empty placeholder screens for all 4 bottom nav tabs
- Both light and dark theme configured
- Do not build any UI yet — just the skeleton

Package ID: com.shuddhasangeetham.app
Min SDK: Android 5.0 (API 21), iOS 13
```

**Expected output:** Working Flutter project that compiles, with correct folder structure, dependencies, and DB schema.

---

### Session 2 — Python Scraper + Hybrid Data Pipeline

**Status: ✅ Done (reworked — see notes below)**

**Spec sections:** Section 7.1 (Data Source), Section 7.2 (Data Pipeline), Section 8 (Data Models)

#### Data Sources

**Primary — karnatik.com scraper (`scraper.py`)**

karnatik.com is the authoritative source for lyrics in familiar plain-English transliteration (e.g. "Bantureethi koluvi"). Scrapes pages `c1000.shtml` → `c20000.shtml` (~20,000 krithis). Extracts per page:

- krithi name, raga (with arohana/avarohana), tala, composer, language, composition type
- pallavi, anupallavi, charanam(s)
- deity (from the "God" field on the page — stored as `deity`)

Features: polite 2–3.5 s rate limit, resumable (picks up from last scraped ID), `failed.log` for retries. Output: one JSON file per batch in `scraper/data/raw/`.

**Supplementary — GitHub JSON importer (`import_json.py`)**

`ramanarunachalam/Music` on GitHub contains 12,009 song records with richer structured metadata. The lyrics are in SLP1 diacritics (academic notation), **not** plain English — so they are not used for app lyrics. The JSON enriches karnatik.com records with:

- `deity` — when karnatik.com page omits it
- `tala_angas` — detailed tala structure (e.g. "Laghu-1, Dhruta-2")
- `tala_count` — beat count string (e.g. "4 + 2 + 2 = 8")
- `raga_arohana` / `raga_avarohana` — fallback when scraper misses them

Matching strategy: join on karnatik.com URL embedded in the JSON `lyricsref` field. Unmatched JSON records (no karnatik.com link) are **discarded** — we do not add lyrics-less records.

#### Pipeline

```
scraper.py          → scraper/data/raw/*.json     (karnatik.com HTML → JSON)
import_json.py      → scraper/data/json_enriched/ (GitHub JSON → enrichment dict keyed by karnatik URL)
normalize.py        → scraper/data/shuddha.db     (merge + deduplicate + FTS5)
migrate_db.py       → assets/db/shuddha_sangeetham.db  (Drift-compatible schema, indexes, FTS5 rebuild)
```

#### Schema additions (vs original Session 2)

- `krithis.deity TEXT` — deity/god associated with the composition
- `talas.structure TEXT` — tala angas string (from JSON enrichment)
- `talas.aksharas_count INTEGER` — beat count (from JSON enrichment)

#### Scripts

| Script | Role |
|---|---|
| `scraper.py` | karnatik.com HTML scraper — primary source |
| `import_json.py` | GitHub JSON enrichment importer |
| `normalize.py` | Merge, deduplicate, normalise names, build `shuddha.db` |
| `migrate_db.py` | Upgrade to Drift-compatible schema, rebuild FTS5, copy to `assets/db/` |

**Expected output:** `scraper.py`, `import_json.py`, `normalize.py`, `migrate_db.py`, sample raw JSON, final `assets/db/shuddha_sangeetham.db`.

---

### Session 3 — SQLite FTS5 Search Engine
**Spec sections to include:** Section 6.2 (Search & Filter), Section 8 (Data Models — SearchAlias)

**Prompt:**
```
App: Shuddha Sangeetham
Package ID: com.shuddhasangeetham.app
Framework: Flutter + drift (SQLite) + Riverpod
Repo: github.com/[yourname]/shuddha-sangeetham
Full spec: SPEC.md in repo root

Implement the offline search engine:
- SQLite FTS5 index covering: krithi name, raga, composer, tala, pallavi,
  anupallavi, charanam
- SearchAlias table seeded with common spelling variants for top ragas,
  composers, and talas (e.g. Thyagaraja→Tyagaraja, Bhairawi→Bhairavi)
- Search repository with 3 methods:
  1. quickSearch(query) — searches name + raga + composer, < 200ms
  2. lyricsSearch(query) — full-text across pallavi/charanam, < 500ms
  3. filterSearch(raga, composer, tala, language, type) — combined filters
- Results ranked: exact name → partial name → raga/composer → lyrics
- Fuzzy matching via trigram tokenizer
- All queries fully offline — zero network calls
- Unit tests for all 3 search methods
```

**Expected output:** Search repository, FTS5 setup, SearchAlias seed data, passing unit tests.

---

### Session 4 — Home Screen & Search UI
**Spec sections to include:** Section 6.2 (Search UI), Section 9 (Navigation)

**Prompt:**
```
App: Shuddha Sangeetham
Package ID: com.shuddhasangeetham.app
Framework: Flutter + drift (SQLite) + Riverpod
Repo: github.com/[yourname]/shuddha-sangeetham
Full spec: SPEC.md in repo root

Build the Home screen:
- Prominent search bar at the top — always visible, large tap target
- Two search modes: Quick Search (name/raga/composer) and Lyrics Search (toggle)
- Results appear as user types (~200ms debounce, min 2 characters)
- Result card shows: krithi name, raga, tala, composer, language
  + matching lyric line (lyrics search mode only)
- Filter icon opens bottom sheet with: raga, composer, tala,
  language, composition type filters
- Active filters shown as dismissible chips above results
- Empty state with helpful suggestions
- Fully functional with the search engine from Session 3
- Light and dark mode support
- One-hand usable — large tap targets, bottom-anchored search
```

**Expected output:** Fully functional Home screen with working search.

---

### Session 5 — Browse Screen
**Spec sections to include:** Section 6.1 (Krithi Database), Section 9 (Navigation)

**Prompt:**
```
App: Shuddha Sangeetham
Package ID: com.shuddhasangeetham.app
Framework: Flutter + drift (SQLite) + Riverpod
Repo: github.com/[yourname]/shuddha-sangeetham
Full spec: SPEC.md in repo root

Build the Browse screen:
- Scrollable list of all krithis, alphabetical by default
- Sort options: A–Z / By Raga / By Composer
- Filter chips at top: Raga, Composer, Tala, Language, Composition Type
- Each list item shows: krithi name, raga, composer
- Lazy loading — load 50 at a time, load more on scroll
- Tap any krithi → navigate to Krithi Detail Page (Session 6)
- Light and dark mode support
```

**Expected output:** Fully functional Browse screen with sorting and filtering.

---

### Session 6 — Krithi Detail Page
**Spec sections to include:** Section 6.1 (Krithi fields), Section 9 (Krithi Detail Page)

**Prompt:**
```
App: Shuddha Sangeetham
Package ID: com.shuddhasangeetham.app
Framework: Flutter + drift (SQLite) + Riverpod
Repo: github.com/[yourname]/shuddha-sangeetham
Full spec: SPEC.md in repo root

Build the Krithi Detail Page:
- Header metadata chips: krithi name, composer, raga, tala, language, composition type,
  deity (hidden if empty)
- Bookmark button (top right) — saves to local DB
- Lyrics section:
  - Pallavi (labelled)
  - Anupallavi (labelled, hidden if empty)
  - Charanam(s) (labelled)
  - Generous font size, good line height — comfortable reading
  - Text size adjustable via settings
- Performances section: placeholder UI only — "Coming soon" (v2 feature)
- Light and dark mode support
```

**Expected output:** Fully functional Krithi Detail Page.

---

### Session 7 — Bookmarks Screen
**Spec sections to include:** Section 6.3 (Bookmarks)

**Prompt:**
```
App: Shuddha Sangeetham
Package ID: com.shuddhasangeetham.app
Framework: Flutter + drift (SQLite) + Riverpod
Repo: github.com/[yourname]/shuddha-sangeetham
Full spec: SPEC.md in repo root

Build the Bookmarks screen:
- List of bookmarked krithis, sorted by most recently bookmarked
- Same card design as Browse screen
- Searchable within bookmarks
- Swipe to remove bookmark
- Empty state: "No bookmarks yet — tap the bookmark icon on any krithi"
- Bookmarks stored in local SQLite — fully offline, no account needed
- Tap any bookmark → navigate to Krithi Detail Page
- Light and dark mode support
```

**Expected output:** Fully functional Bookmarks screen.

---

### Session 8 — Settings & Profile Screen
**Spec sections to include:** Section 9 (Profile tab), Section 19 (UI constraints)

**Prompt:**
```
App: Shuddha Sangeetham
Package ID: com.shuddhasangeetham.app
Framework: Flutter + drift (SQLite) + Riverpod
Repo: github.com/[yourname]/shuddha-sangeetham
Full spec: SPEC.md in repo root

Build the Profile / Settings screen:
- Dark mode toggle (follows system by default, manual override)
- Text size selector (Small / Medium / Large) — affects lyrics display
- About section:
  - App name: Shuddha Sangeetham
  - Version number
  - "Content sourced with reference to karnatik.com"
  - Link to karnatik.com
  - Credits
- "Check for updates" button — triggers delta sync manually
- No login/account UI in v1 — that is a v2 feature
- Light and dark mode support
```

**Expected output:** Fully functional Settings/Profile screen.

---

### Session 9 — Delta Sync
**Spec sections to include:** Section 11 (Delta Sync), Section 3 (Tech Stack)

**Prompt:**
```
App: Shuddha Sangeetham
Package ID: com.shuddhasangeetham.app
Framework: Flutter + drift (SQLite) + Riverpod
Repo: github.com/[yourname]/shuddha-sangeetham
Full spec: SPEC.md in repo root

Implement delta sync:
- On app launch (if online): send latest updated_at timestamp to backend
- Backend returns only krithis updated since that timestamp
- Merge new/updated records into local SQLite silently in background
- Never interrupts the user — runs as background task
- "Check for updates" button in Settings triggers this manually
- Graceful failure — if offline or backend unreachable, continue normally
- Show a subtle "Database updated" snackbar when new content is received
```

**Expected output:** Working delta sync service.

---

### Session 10 — Admin CMS
**Spec sections to include:** Section 13 (Admin CMS), Section 7.2 (Data Pipeline)

**Prompt:**
```
App: Shuddha Sangeetham
Package ID: com.shuddhasangeetham.app
Framework: Flutter + drift (SQLite) + Riverpod
Repo: github.com/[yourname]/shuddha-sangeetham
Full spec: SPEC.md in repo root

Build a simple web-based Admin CMS (separate from the Flutter app):
- Tech: Simple React or plain HTML/JS — keep it minimal
- Hosted separately on home server accessed through ssh anjaneya
- Frontend will be accessed using github pages
- Features:
  - View / add / edit / delete Krithis, Ragas, Composers, Talas
  - Upload scraper JSON output to bulk import krithis
  - "Run Scraper" button — triggers the Python scraper remotely
  - View sync log — when was last scrape, how many krithis updated
- Basic password protection — no need for full auth system
- REST API backend that the Flutter app also uses for delta sync
```

**Expected output:** Working Admin CMS with REST API.

---

### Session 11 — Polish & Testing ✅ Done
**Run last, before app store submission.**

**Prompt:**
```
App: Shuddha Sangeetham
Package ID: com.shuddhasangeetham.app
Framework: Flutter + drift (SQLite) + Riverpod
Repo: github.com/[yourname]/shuddha-sangeetham
Full spec: SPEC.md in repo root

Polish and test the app before submission:
- Test on low-end Android device (2GB RAM) — check search performance
- Verify all search targets: name < 200ms, lyrics < 500ms
- Verify app launch to search-ready < 2 seconds
- Check dark mode on all screens
- Check text size changes apply everywhere
- Verify offline mode — airplane mode, all features work
- App icon — design a simple clean icon for Shuddha Sangeetham
- Splash screen
- Play Store listing assets: screenshots, feature graphic, description
- App Store listing assets: screenshots, description
- Check accessibility: font scaling, contrast ratios
```

**Expected output:** Production-ready app with store listing assets.

---

*This is a living specification. Update it as decisions are made. Hand this document to Claude Code to scaffold the Flutter project for Shuddha Sangeetham.*

---

## 17. Resolved Decisions Log

| Decision | Resolution |
|---|---|
| **App name** | **Shuddha Sangeetham** — clear on both app stores, social media page already exists under this name, "Shuddha" resonates deeply with the Carnatic community and is itself a Carnatic term |
| **Monetization** | Free at launch. Architecture must support a future freemium paywall without a full rebuild. Revisit after user base is established. |
| **Artist as first-class entity** | ✅ Yes — `Artist` table from v1 with name variants / aliases (same pattern as Raga/Composer). Avoids a painful migration later and enables artist profile pages in v2. |
| **Performance log moderation** | None in v1. `Concert` table includes a `status` field (`active | flagged | removed`) from day one so v2 moderation requires no schema change. |
| **Scraper maintenance** | Manual trigger via Admin CMS panel — a one-click "Run Scraper" button. Gives visibility and control. Avoids silent failures from fully automated runs. |
| **karnatik.com courtesy email** | Send a friendly note to rani introducing the app, offering prominent attribution, and sharing the link once live. Not legally required but the right thing to do for the community. |
| **Duplicate concert handling** | Auto-merge on high-confidence match (same artist + exact date + same krithi). Show attendee count on merged concert card. Edge cases deferred to v2. |
| **Data source** | Single source: karnatik.com (~20,000 krithis). No book dataset. No translations. Legally clean — all content is either factual or public domain. |
| **App size** | ~30–35 MB download acceptable. Full FTS5 index included — non-negotiable for concert hall use case. |
| **Framework** | Flutter — best for offline-first, cross-platform consistency, Carnatic script rendering |

