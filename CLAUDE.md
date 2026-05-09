# Shuddha Sangeetham — Claude Context

Offline Carnatic music reference app built with Flutter + Drift (SQLite ORM).

## Stack
- Flutter (Dart) — UI and state management via Riverpod
- Drift — type-safe SQLite ORM with code generation
- SQLite FTS5 — full-text search for compositions
- `build_runner` — code generation for Drift DAOs and models

## Key Directories
- `lib/data/` — Drift database, DAOs, models, seed data
- `lib/features/` — feature-based UI modules
- `lib/core/` — shared utilities and theme
- `scraper/` — Python scraper that builds the seed SQLite DB
- `test/` — unit tests

## Dependency Rule
When adding dependencies, add all required packages in a single pubspec.yaml edit before running build_runner.

## Code Generation
Run after any Drift schema or model change:
```
dart run build_runner build --delete-conflicting-outputs
```
