---
name: Journal for AI agents
description: They use it to remember the most important elements about the project, so they can recall it later.
---

# Agent Journal

- Each entry: `## YYYY-MM-DD — [Agent/session note]` followed by freeform notes.
- Read this at session start. Append entries; never delete existing ones.
- keep elements organized.

## 2026-02-24 — Task 2 CSV source (data.gov.rs)

- **CSV URLs**: Direct resource URLs return 404; use permalink URLs (/sr/datasets/r/<uuid>) which redirect to CSV.
- **CSV format**: Semicolon delimiter. Header includes Regija, NazivOpstineL, OrgOblik, broj gazdinstava, AktivnaGazdinstva. Encoding may need handling in parser (Task 3).

## 2026-02-24 — RPG app design (Milan)

- **Detail screen v1**: Show only totals per opština; no breakdown by organizational form.
- **Future**: When adding breakdown by organizational form, use a **chart** (e.g. bar or pie), not table-only (Milan: "remember for the future I want it to be B").
- **Canonical dataset URL**: https://data.gov.rs/sr/datasets/rpg-broj-svikh-registrovanikh-poljoprivrednikh-gazdinstava-aktivna-gazdinstva/

##

## 2026-02-25 — Serbian Latin encoding (č, ć, ž, š, đ)

- **data.gov.rs CSV**: Not valid UTF-8. Decode path: UTF-8 → Windows-1250 (allowInvalid) → Latin-2. decodeCsvBody() in csv_source.dart; enough_convert (windows, latin). If letters still wrong, trigger sync to re-fetch.

## 2026-02-26 — F4: Codebase renamed to English (opstina → municipality)

- **Branch**: `wip/f4-rename-codebase-to-english`. All code identifiers: `OpstinaRow` → `MunicipalityRow`, `opstinaName` → `municipalityName`, `getOpstina` / `getTopOpstine` / `getOpstinaNames` → `getMunicipality` / `getTopMunicipalities` / `getMunicipalityNames`. Route `/opstina` → `/municipality`. Files: `opstina_detail_screen` → `municipality_detail_screen`, `opstina_name_repair` → `municipality_name_repair`. Storage: Holdings table column `opstina_name` → `municipality_name` with Drift migration (schemaVersion 2, `customStatement` RENAME COLUMN). Serbian kept in UI strings only (e.g. "Opština", "Pregled", "Top 5 opština po aktivnim").

## 2026-02-26 — F5: Web app (storage init)

- **storage_web.dart**: Resolve worker and wasm URIs from `Uri.base` (base.resolve('sqlite3.wasm'), base.resolve('drift_worker.js')) so they load correctly regardless of document URL or deployment path. If web still fails, next suspects: CORS when fetching CSV from data.gov.rs (browser blocks cross-origin); then check browser console for worker/wasm load errors.

## 2026-02-26 — F6: UI design (theme + reusable widgets)

- **Reusable widgets**: `lib/widgets/data_card.dart` (DataCard with optional title/subtitle, 16px padding), `lib/widgets/section_header.dart` (SectionHeader with 8px bottom spacing). Home, Detail, and About refactored to use them for consistent data blocks and section titles.
- **Theme**: Added `listTileTheme` (contentPadding 16/8, shape rounded) to `appTheme` and `appDarkTheme` in `lib/app/theme.dart` for Map screen list tiles.
- **Screens**: Home (_NationalSummary, _TopMunicipalities, _QuickView) and Detail totals block use DataCard; About uses SectionHeader for "Izvor podataka" and "Napomena". No new features; layout and semantics unchanged for tests.

