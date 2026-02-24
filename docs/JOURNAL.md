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
