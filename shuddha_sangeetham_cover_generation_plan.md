# Shuddha Sangeetham — Reusable Cover Generation System

## Objective

Create a repeatable system for generating the Shuddha Sangeetham Instagram/Reels cover using the existing SVG template.

The design should remain consistent while the following information changes from cover to cover:

- Artist photograph
- Song/title
- Ragam
- Krithi/composer
- Artist name
- Artist designation/title, when applicable

The long-term goal is to move from manual editing to a small, deterministic rendering service that can eventually run on our own server.

---

## Core Recommendation

Use **deterministic template rendering** for the actual graphic composition rather than asking an AI image generator to recreate the design every time.

AI image generation is useful for certain image-processing tasks, but it should not be responsible for exact typography, layout, logos, or repeated template composition.

This provides:

- Consistent layout
- Exact text
- Consistent branding
- Reproducible dimensions
- No accidental changes to the logo or decorative elements
- Reliable repeated generation
- Easier batch processing
- A clean path to server-side automation

---

## Template Structure

### Fixed elements

The master template should preserve:

- Black background
- Shuddha Sangeetham logo
- Shuddha Sangeetham branding
- Typography style
- Text positioning
- Peach accent colour
- Peach underline
- Artist-name ribbon
- Vintage microphone graphic
- Overall 9:16 composition
- Exact spacing and proportions

### Variable elements

The renderer should accept:

1. Song/title
2. Ragam
3. Krithi/composer
4. Artist photograph
5. Artist name
6. Artist designation/title

Example:

```json
{
  "title": "Entharo Mahanu Bhavulu",
  "ragam": "Sree",
  "krithi": "Tyagaraja",
  "artist": "KJ Yesudas",
  "designation": "Padma Vibhushan",
  "photo": "kjy.jpeg"
}
```

---

# Architecture

```text
                 MASTER TEMPLATE
                       |
        +--------------+--------------+
        |              |              |
   Artist photo    Text data     Artist title
        |              |              |
        +--------------+--------------+
                       |
                       v
                RENDER ENGINE
                       |
                       v
                 1080 x 1920 PNG
```

The master template remains unchanged.

The rendering engine inserts the variable content and produces the final cover.

---

# Artist Photograph Pipeline

Artist photographs will not necessarily have the same background, dimensions, or composition.

The recommended pipeline is:

```text
Input photograph
       |
       v
Background removal
       |
       v
Grayscale conversion
       |
       v
Contrast / tonal adjustment
       |
       v
Scale + crop + positioning
       |
       v
Template compositing
       |
       v
Final PNG
```

The objective is to reproduce the monochrome cutout appearance of the existing template.

Some photographs may still require manual adjustment because artist poses and framing can vary substantially.

---

# Why Not Use AI Image Generation for the Whole Cover?

The trial demonstrated that an image generator can understand and reproduce the general visual concept.

However, it is not ideal for regular production because it may:

- Alter typography
- Introduce spelling errors
- Change spacing
- Modify logos
- Change decorative elements
- Alter the artist's appearance
- Produce slightly different proportions between generations

For example, an exact designation such as:

**Padma Vibhushan**

must be rendered deterministically rather than relying on an image model to reproduce the text correctly.

Therefore:

> **AI should assist the workflow, not control the final graphic composition.**

---

# Where AI Fits

AI can still be useful for tasks where visual interpretation is helpful:

- Background removal
- Photograph enhancement
- Intelligent cropping
- Subject positioning
- Improving poor-quality source photographs
- Detecting the primary subject in a photograph
- Suggesting an appropriate crop

The actual template composition should remain deterministic.

This gives the system:

**AI where useful + deterministic software where precision matters.**

---

# Server Architecture

Once the renderer works locally, it can be deployed on our own server.

```text
                    YOUR SERVER
+----------------------------------------------+
|                                              |
|  Web Interface / API                         |
|          |                                   |
|          v                                   |
|  Cover Generation Service                    |
|          |                                   |
|          +-- Read master template           |
|          +-- Process artist photograph      |
|          +-- Insert text                    |
|          +-- Position / scale artist        |
|          +-- Render                          |
|          |                                   |
|          v                                   |
|       1080 x 1920 PNG                        |
|                                              |
+----------------------------------------------+
```

The service could eventually be accessed through a browser, for example:

```text
https://your-server/cover-generator
```

---

# Simple Web Interface

A basic interface could contain:

```text
Artist photo       [ Upload ]

Song               [                         ]

Ragam              [                         ]

Krithi             [                         ]

Artist             [                         ]

Designation        [                         ]

                   [ GENERATE ]
```

The user uploads the photograph, enters the metadata, and receives the finished PNG.

The interface should remain deliberately simple.

---

# API

Once useful, the renderer can expose an API such as:

```http
POST /api/covers
```

with data such as:

```json
{
  "song": "Entharo Mahanu Bhavulu",
  "ragam": "Sree",
  "krithi": "Tyagaraja",
  "artist": "KJ Yesudas",
  "designation": "Padma Vibhushan",
  "photo": "..."
}
```

This allows other systems to generate covers automatically.

For example:

```text
Song database
      |
      v
   Cover API
      |
      v
     PNG
      |
      +---- Facebook
      +---- Instagram
      +---- Website
      +---- Archive
```

---

# Batch Generation

If the number of covers grows, the renderer can accept a CSV/Excel file and a directory of photographs.

Example:

```csv
song,ragam,krithi,artist,designation,photo
Entharo Mahanu Bhavulu,Sree,Tyagaraja,KJ Yesudas,Padma Vibhushan,kjy.jpg
Song 2,Kalyani,Composer 2,Artist 2,,artist2.jpg
Song 3,Bhairavi,Composer 3,Artist 3,Padma Shri,artist3.jpg
```

The system could then generate all covers in one run.

This becomes particularly useful for preparing several days or weeks of content at once.

---

# Recommended Implementation Phases

## Phase 1 — Reproduce the Existing Template

Reverse-engineer the current SVG and identify the exact positions and dimensions of:

- Title
- Ragam
- Krithi
- Artist image
- Ribbon
- Artist name
- Designation

Build a renderer that reproduces the existing design as accurately as possible.

**Goal:** Generate a cover that visually matches the existing manually created template.

---

## Phase 2 — Make Content Configurable

Replace the hard-coded variable content with parameters:

- Song/title
- Ragam
- Krithi
- Artist
- Designation
- Photograph

**Goal:** Generate a new cover by changing only the input data.

---

## Phase 3 — Deploy on the Server

Create a small web interface around the renderer.

Workflow:

```text
Upload photo
     |
Enter metadata
     |
Generate
     |
Download/view PNG
```

The server becomes the central location for the template and rendering logic.

**Goal:** Make regular cover production easy without manually editing the SVG.

---

## Phase 4 — Add Automation Only When Needed

After the basic workflow is stable, consider:

- Batch generation
- API access
- Database integration
- Automatic image processing
- Automatic archiving
- Integration with the broader Shuddha Sangeetham content workflow

**Goal:** Reduce repetitive manual work without building unnecessary infrastructure too early.

---

# Recommended Technology Stack

The system should use a small, deterministic stack. The goal is reliable template rendering rather than a heavy AI application.

| Layer | Recommended technology | Purpose |
|---|---|---|
| Backend | Python + FastAPI | Web application and API |
| Template | SVG | Master visual template with precise positioning |
| SVG rendering | resvg | Deterministic SVG → PNG rendering |
| Image processing | Pillow | Resize, crop, grayscale, contrast, compositing |
| Background removal | rembg initially | Local AI-based artist-background removal |
| Data validation | Pydantic | Validate cover metadata |
| Frontend | HTML + HTMX initially | Simple upload/form/preview interface |
| Storage | Local filesystem initially | Source photos and generated covers |
| Database | SQLite initially | Cover metadata and generation history |
| Production database | PostgreSQL later, if needed | Larger-scale metadata/content storage |
| Deployment | Docker | Reproducible server deployment |
| Reverse proxy | Caddy or Nginx | HTTPS and routing |

## Recommended architecture

```text
                         Browser
                            |
                            v
                     +-------------+
                     |   FastAPI   |
                     +------+------+
                            |
              +-------------+-------------+
              |                           |
              v                           v
        Cover metadata             Artist photograph
              |                           |
              |                           v
              |                         rembg
              |                           |
              |                           v
              |                         Pillow
              |                           |
              +-------------+-------------+
                            |
                            v
                      SVG Template
                            |
                            v
                         resvg
                            |
                            v
                    1080 × 1920 PNG
                            |
                   +--------+--------+
                   |                 |
                   v                 v
                Storage          Database
```

## Why this stack

**Python + FastAPI** keeps the application and image-processing logic in one ecosystem and provides a straightforward API for future integrations.

**SVG** should remain the master template because it allows exact control over typography, positioning, branding, and decorative elements.

**resvg** should handle the final SVG-to-PNG rendering so the same template produces consistent output every time.

**Pillow** handles operations around the artist photograph: resizing, cropping, grayscale conversion, contrast adjustment, and compositing.

**rembg** can provide an initial local solution for removing photograph backgrounds. It should be treated as a replaceable processing component rather than a core dependency of the template system.

**HTML + HTMX** is sufficient for the first web interface. There is no need to introduce React or another large frontend framework until the application grows into a broader content-management system.

**SQLite** is sufficient initially for recording cover metadata and generation history. PostgreSQL can be introduced later if the system expands.

**Docker** makes the renderer portable between development and the production server.

## Template engineering

The current SVG should be converted once into a proper reusable template.

The fixed artwork should remain as vector elements, while variable content should become actual template fields for:

- Song/title
- Ragam
- Krithi/composer
- Artist
- Designation
- Artist image

The current design uses vectorized text rather than normal SVG text elements. Rebuilding the variable text portions as real text/template elements will make the system substantially easier to maintain.

## Keep AI separate from composition

The final graphic should be deterministic.

```text
                    COVER SERVICE
                         |
              +----------+----------+
              |                     |
              v                     v
       Deterministic layer     Optional AI layer
              |                     |
       SVG rendering          Background removal
       Text rendering         Crop assistance
       Exact composition      Photo enhancement
       Branding              Subject positioning
              |                     |
              +----------+----------+
                         |
                         v
                      Final PNG
```

AI can assist with the photograph, but it should not generate the final poster. This prevents spelling errors, layout drift, logo changes, and inconsistent typography.

---

# Server Deployment

The first production deployment can remain a single Dockerized application.

```text
docker-compose.yml

services:

  cover-generator:
      FastAPI
      Pillow
      rembg
      resvg

  caddy:
      HTTPS
      reverse proxy
```

Avoid introducing Kubernetes, Redis, microservices, or other infrastructure until there is a demonstrated need for them.

The same application should be runnable:

```text
Developer PC
     ↓
Test server
     ↓
Production server
```

without redesigning the system.

---

# API Design

Once the basic renderer is stable, expose a simple API:

```http
POST /api/covers
GET  /api/covers/{id}
GET  /api/covers/{id}/image
```

A request can contain:

```json
{
  "song": "Entharo Mahanu Bhavulu",
  "ragam": "Sree",
  "krithi": "Tyagaraja",
  "artist": "KJ Yesudas",
  "designation": "Padma Vibhushan"
}
```

The photograph can be supplied as an uploaded file.

This makes the renderer usable by other Shuddha Sangeetham systems later.

---

# Batch Generation

Once individual generation works reliably, support a CSV/Excel-driven batch workflow.

```text
covers.csv
photos/
    artist1.jpg
    artist2.jpg
    artist3.jpg
```

Example:

```csv
song,ragam,krithi,artist,designation,photo
Entharo Mahanu Bhavulu,Sree,Tyagaraja,KJ Yesudas,Padma Vibhushan,kjy.jpg
Song 2,Kalyani,Composer 2,Artist 2,,artist2.jpg
Song 3,Bhairavi,Composer 3,Artist 3,Padma Shri,artist3.jpg
```

The renderer can then generate an entire batch in one operation.

---

# Implementation Phases

## Phase 1 — Exact Template Reproduction

Reverse-engineer the existing SVG and identify the exact coordinates, dimensions, fonts, and artwork for:

- Title
- Ragam
- Krithi
- Artist image
- Ribbon
- Artist name
- Designation

Build a renderer that reproduces the current design accurately.

**Goal:** Generate a cover that matches the existing manually created template.

## Phase 2 — Configurable Content

Replace hard-coded variable content with parameters:

- Song/title
- Ragam
- Krithi
- Artist
- Designation
- Photograph

**Goal:** Generate a new cover by changing only the input data.

## Phase 3 — Server Interface

Deploy the renderer as a Dockerized FastAPI application with a simple HTML/HTMX interface.

Workflow:

```text
Upload photo
     |
Enter metadata
     |
Generate
     |
Preview / save PNG
```

**Goal:** Make regular cover production easy without manually editing the SVG.

## Phase 4 — Automation

Only after the basic workflow is stable, add features that prove useful:

- Batch generation
- API access
- Database integration
- Automatic image processing
- Cover archive
- Integration with the broader Shuddha Sangeetham content workflow
- Automated publishing, if appropriate

**Goal:** Reduce repetitive work without building unnecessary infrastructure too early.

---

# Long-Term Workflow

The eventual workflow could become:

```text
Song / artist information
          |
          v
    Content database
          |
          +----------------+
          |                |
          v                v
    Cover renderer     Other content
          |
          v
       Cover PNG
          |
     +----+----+
     |    |    |
     v    v    v
    FB   IG  Archive
```

This makes the cover generator a reusable component of the Shuddha Sangeetham content infrastructure rather than a one-off graphic-editing tool.

---

# Guiding Principle

Do not build the complete automation platform first.

Build in this order:

1. **Exact template reproduction**
2. **Configurable content**
3. **Simple server interface**
4. **Batch/API automation if justified**

This keeps the implementation manageable while preserving a clear path toward full automation.
