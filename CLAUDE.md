# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal data journalism and civic tech portfolio repository ("blackboard" - "un po' di sfogo del KAOS"). It contains various data visualization projects, geospatial analysis, automated news scraping, and static HTML sites. The repository is deployed via GitHub Pages (gh-pages branch).

## Key Tools and Dependencies

The repository relies on several command-line data processing tools:

- **mlr** / **mlrgo**: Miller, for tabular data processing (binaries in `bin/`)
- **scrape**: HTML scraping tool (binary in `bin/`)
- **yq** / **xq**: YAML/XML query tools (installed via pip)
- **quarto**: Document rendering system for generating slides/reports
- **duckdb**: For table operations (use `duckdb -c` CLI)
- Standard tools: `curl`, `jq`, bash

## Project Structure

### pk/news/
Automated news scraping and slide generation from Planetek RSS feed.

**Main script**: `pk/news/script/news.sh`

**Workflow**:
1. Fetches RSS feed from planetek.it
2. Converts XML to JSON using `xq`
3. Scrapes metadata (title, description, image, date) from each article
4. Stores in TSV format (`output/lista_full.tsv`)
5. Generates Quarto slides (`slide/slide.qmd`)
6. Renders to HTML using `quarto render`
7. Output goes to `pk/news/output/index.html`

**GitHub Action**: `.github/workflows/pk_news.yml` runs daily at 4:05 AM UTC

### data/
Geospatial datasets:
- `edifici.geojson`: Building footprints
- `flatgeobuf/`: FlatGeobuf format spatial data

### html/
Static HTML visualizations and map viewers:
- `fgb/`: FlatGeobuf viewers
- `kml/`: KML tile viewers
- Various embed examples for Flickr, KMZ, etc.

### bc/
Simple Mapbox-based map visualization with GeoJSON data

### scriptorivm/
Portfolio site based on Start Bootstrap Freelancer theme (Italian and English versions)

### presentazioni/
Presentation materials using reveal.js

## Common Workflows

### Running the pk/news scraper locally

```bash
cd pk/news/script/
chmod +x news.sh
./news.sh
```

Requirements: Ensure `~/bin` contains `mlr`, `mlrgo`, `scrape`, and that `quarto` and `yq` are installed.

### Working with geospatial data

Use `duckdb` with spatial extension:

```bash
duckdb -c "INSTALL spatial; LOAD spatial; SELECT * FROM ST_Read('data/edifici.geojson') LIMIT 5;"
```

For FlatGeobuf files:

```bash
duckdb -c "INSTALL spatial; LOAD spatial; DESCRIBE SELECT * FROM ST_Read('data/flatgeobuf/GEOSTAT_grid_POP_1K_IT_2011.fgb');"
```

## Data Processing Patterns

### Shell script pattern (pk/news/news.sh)

All scripts follow bash strict mode:
```bash
set -x  # debug mode
set -e  # exit on error
set -u  # exit on undefined variable
set -o pipefail  # exit on pipe failure
```

### Miller (mlr/mlrgo) usage

- Convert formats: `mlrgo --ixtab --otsv --ips "\t" clean-whitespace`
- Remove duplicates: `mlrgo -I -N --tsv uniq -a`
- Sort and limit: `mlrgo --tsv sort -r <field> then head -n 20`

### XML/JSON processing

- XML to JSON: `xq . < file.xml > file.json`
- Extract from JSON: `jq -r '.rss.channel.item[].link'`

### Web scraping

- XPath extraction: `scrape -e "//meta[@property='og:title']/@content" < page.html`

## Deployment

The repository uses GitHub Pages on the `gh-pages` branch. Content in `html/`, `bc/`, `scriptorivm/`, and `pk/news/output/` is served directly.

Automated deployments happen via GitHub Actions which commit and push changes automatically.

## Notes

- This is a personal workspace with mixed Italian/English content
- Many subdirectories (`trash/`, `pedonalizzazioni_tribunali/`, `viabilitapalermo/`) contain archived or specialized projects
- The repository emphasizes data pipeline automation using shell scripts and CLI tools rather than programming languages
