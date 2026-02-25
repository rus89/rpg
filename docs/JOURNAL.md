---
name: Journal for AI agents
description: They use it to remember the most important elements about the project, so they can recall it later.
---

# Agent Journal

- Each entry: `## YYYY-MM-DD — [Agent/session note]` followed by freeform notes.
- Read this at session start. Append entries; never delete existing ones.
- keep elements organized.

## 2026-02-24 — RPG app design (Milan)

- **Detail screen v1**: Show only totals per opština; no breakdown by organizational form.
- **Future**: When adding breakdown by organizational form, use a **chart** (e.g. bar or pie), not table-only (Milan: "remember for the future I want it to be B").
- **Canonical dataset URL**: https://data.gov.rs/sr/datasets/rpg-broj-svikh-registrovanikh-poljoprivrednikh-gazdinstava-aktivna-gazdinstva/

## 2026-02-25 — Deep analysis completed (AI)

**CRITICAL DECISIONS NEEDED BEFORE TASK 1:**

1. **CSV Discovery Strategy** — Hardcode URLs vs HTML parsing vs hybrid? (Task 2 blocker)
2. **Storage Interface / DI** — How to inject SQLite (mobile) vs IndexedDB (web)? Service locator vs kIsWeb checks? (Task 4 blocker)
3. **Web Storage Package** — `idb_sqflite` vs `drift` web vs custom vs `indexed_db`? Needs testing first. (Task 5b blocker)
4. **Navigation Structure** — Bottom nav or drawer? How adapts on desktop (responsive)? (Task 7 design)
5. **Snapshot Selection Scope** — Global state or per-screen? Document behavior when Home and Detail differ. (Tasks 8-9 clarification)

**RESEARCH TASKS (before Task 1):**

- [ ] Download actual latest CSV from data.gov.rs and inspect columns, encoding, opština names
- [ ] Find Serbian opština GeoJSON source and verify format (lat/lon vs boundaries)
- [ ] Test web storage package (IndexedDB) compatibility with storage interface
- [ ] Test data.gov.rs CSV fetch from Flutter web (check CORS)
- [ ] Choose transliteration package for Cyrillic→Latin if needed

**ANALYSIS CREATED:** See `ANALYSIS.md` for full 15-point issue breakdown.

##
