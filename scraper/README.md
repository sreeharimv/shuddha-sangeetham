# Karnatik.com Scraper & Pipeline

Tools to scrape, normalize, and migrate Carnatic composition metadata from karnatik.com.

## Scraper Usage

```bash
cd scraper
python3 scraper.py [--start N] [--end M] [--missing-raga]
```

### Options

- `--start <id>`: Start page id (default: 1)
- `--end <id>`: End page id (default: 20000)
- `--workers <n>`: Number of concurrent scrape threads (default: 1)
- `--force`: Re-scrape and overwrite existing raw files
- `--missing-raga`: Inspect existing `scraper/data/raw/*.json` and only fetch/re-parse pages where `raagam` is empty or missing.

Raw HTML is cached to `scraper/data/html/<id>.html` and parsed JSON files to `scraper/data/raw/<id>.json`.

## Catalog Batch Cleaning

```bash
python3 clean_catalog.py data/raw
```

Applies:
- Canonical raga, composer, and tala standardization
- Strips diacritics and mid-word ITRANS uppercase
- Separates mashed charanams into cleanly numbered stanzas
- Strips leaked commentary, meanings, and footer links

### Dockerized Execution

A `Dockerfile` is provided for containerized execution without host Python environment dependencies:

```bash
docker build -t ss-scraper .
docker run -d --name ss-scraper-runner --restart=no \
  -v $(pwd)/data:/scraper/data \
  ss-scraper --missing-raga --start 1000 --end 20000
```

Raw JSON files are saved to `scraper/data/raw/<id>.json`.
