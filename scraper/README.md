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
- `--missing-raga`: Inspect existing `scraper/data/raw/*.json` and only fetch/re-parse pages where `raagam` is empty or missing.

### Dockerized Execution

A `Dockerfile` is provided for containerized execution without host Python environment dependencies:

```bash
docker build -t ss-scraper .
docker run -d --name ss-scraper-runner --restart=no \
  -v $(pwd)/data:/scraper/data \
  ss-scraper --missing-raga --start 1000 --end 20000
```

Raw JSON files are saved to `scraper/data/raw/<id>.json`.
