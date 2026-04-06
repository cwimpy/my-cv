# Programmatic Academic CV with Quarto and Typst

A data-driven academic CV that pulls publications directly from a BibTeX file, formats them in APSA style, and produces a clean PDF using [Quarto](https://quarto.org/) and [Typst](https://typst.app/).

For a full walkthrough of how this was built, see the [blog post](https://cwimpy.com/posts/2026-04-05-typst-cv/).

## Project Structure

```
my-cv/
├── my-cv.qmd           # Content and data (Quarto document)
├── cv-template.typ      # Design and layout (Typst template)
└── publications.bib     # Bibliography (BibTeX)
```

- **`my-cv.qmd`** -- CV content (employment, education, grants, etc.) written in Quarto with an R chunk that reads the BibTeX file and generates Typst data structures at render time.
- **`cv-template.typ`** -- Visual design including fonts, colors, spacing, and custom functions for CV entries, publication formatting, and section headings.
- **`publications.bib`** -- Single source of truth for all publications, shared across the CV, website, and papers.

## Key Features

- **Programmatic publications** -- An R chunk reads `publications.bib` via `RefManageR`, automatically formatting citations in APSA style with hanging indents, bold author highlighting, reverse numbering, and category grouping (Journal Articles, Book Chapters, Essays & Reviews).
- **Separation of content and design** -- The `.qmd` file holds the data; the `.typ` file handles all styling. Change fonts or colors in one place.
- **Fast rendering** -- Typst compiles in milliseconds. The full CV builds in about two seconds.
- **Automatic footer** -- Every page includes a revision date that updates on each render, name, and page count.

## Getting Started

Requires [Quarto](https://quarto.org/docs/get-started/) 1.4+ (for Typst support) and R with the `RefManageR` package.

```bash
git clone https://github.com/cwimpy/my-cv.git
cd my-cv
quarto render my-cv.qmd
```

Replace the content in `my-cv.qmd` and `publications.bib` with your own information, then re-render.
