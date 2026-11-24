# PDF Quality Report

**Checked:** 2026-11-24
**Renderer:** `marked` 15.0.12 and Google Chrome 157.0.8103.80

| Artifact | Pages | Tagged | Page size | Live links | Embedded Unicode fonts | Text extraction |
|---|---:|---:|---|---:|---|---|
| One-page research summary | 1 | Yes | US Letter | 4 | Passed | Passed |
| Public research report | 6 | Yes | US Letter | 4 | Passed | Passed |
| Technical research paper | 10 | Yes | US Letter | 3 | Passed | Passed |

Checks performed:

- correct PDF metadata titles;
- unencrypted PDF 1.4 output;
- page numbers from 1 through the final page;
- no browser timestamp/header or file URL;
- no Unicode replacement characters;
- embedded Arial, Georgia, and Menlo font subsets with Unicode mappings;
- extractable preprint status and independent-review disclosure;
- extractable *Morrissey*, `priorSupervisoryInvolvement`, and repaired-history
  theorem references;
- live annotations for the official source links; and
- visual inspection of first and final pages, including headings, code,
  notation, lists, margins, and page breaks.

The Markdown files are the controlling publication text if a rendering
discrepancy is later found. Tagged output and text extraction support review
accessibility, but this check is not an independent PDF/UA or WCAG conformance
certification.
