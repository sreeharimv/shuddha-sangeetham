#!/usr/bin/env bash
# Run on the home server (accessed via ssh anjaneya).
# Set ADMIN_API_KEY and DB_PATH before starting.
export ADMIN_API_KEY="${ADMIN_API_KEY:-changeme}"
export DB_PATH="${DB_PATH:-../../scraper/data/shuddha.db}"
export PORT="${PORT:-8000}"

exec gunicorn -w 1 -b "0.0.0.0:${PORT}" app:app
