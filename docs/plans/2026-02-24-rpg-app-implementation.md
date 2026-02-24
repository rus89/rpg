# RPG app — implementation plan

> **For Claude:** When implementing this plan, use TDD per project rules (failing test first, then minimal code, then refactor). Follow CLAUDE.md and docs/DESIGN.md.

**Goal:** Ship a production-ready Flutter app for **mobile and web** that shows Serbia RPG open data (registered/active agricultural holdings by opština) with Home dashboard, opština dropdown and quick view, Map screen, Opština detail screen, and About (attribution + independent-developer disclaimer). Same codebase; responsive layout for phone and desktop. Data is obtained from data.gov.rs CSV resources, parsed, stored via a **storage abstraction** (SQLite on mobile, IndexedDB on web); UI reads from storage via Riverpod.

**Architecture:** Data layer first: discover/fetch CSVs → parse → store via **platform-agnostic storage interface** (SQLite impl for iOS/Android, IndexedDB impl for web). Riverpod providers expose snapshot list, national totals, top N opštine, per-opština data. UI: GoRouter with Home, Map, Detail, About; responsive (breakpoints / LayoutBuilder). Home shows dashboard + dropdown + quick view; Map shows tappable opštine → same Detail screen. Refresh on app start and/or pull-to-refresh. Serbian Latin only; loading/error/retry UX throughout.

**Tech stack:** Flutter (mobile + web targets), Riverpod, GoRouter, http for CSV fetch. Storage: abstraction interface; SQLite (drift or sqflite) on mobile; IndexedDB (e.g. idb_sqflite, or drift web backend) on web. Tests: flutter_test (unit + widget).

**References:** docs/DESIGN.md (full spec), CLAUDE.md (rules, TDD, naming, ABOUTME).

---

## Phase 1 — Project bootstrap and data layer

### Task 1: Flutter project and deps (mobile + web targets)

**Files:**
- Create: `pubspec.yaml` (Flutter app, Riverpod, GoRouter, http, drift or sqflite, path_provider; web-capable deps)
- Create: `lib/main.dart` (minimal runApp with MaterialApp placeholder)
- Create: `test/widget_test.dart` or `test/main_test.dart` (smoke test that app runs)

**Steps:**
1. Create Flutter project in repo root (or add `pubspec.yaml` and `lib/` if not using `flutter create`). **Enable web target**: `flutter create . --platforms=ios,android,web` or ensure `flutter config --enable-web` and project has web support. Add dependencies: `flutter_riverpod`, `go_router`, `http`, `drift` + `drift_flutter` (or `sqflite` + `path_provider`), `path_provider`.
2. Write a minimal test that runs the app (e.g. pumpWidget(MaterialApp(...)) and expect find.byType(MaterialApp)).
3. Run test: `flutter test test/main_test.dart` — ensure it passes. Run `flutter run -d chrome` (or `flutter run -d web-server`) to confirm web builds.
4. Commit: "chore: bootstrap Flutter app and deps (mobile + web)".

---

### Task 2: CSV URL discovery and fetch (with test)

**Files:**
- Create: `lib/data/csv_source.dart` — interface or class that returns list of snapshot labels + CSV URLs (v1: hardcoded list of known CSV URLs from data.gov.rs dataset page, or parse dataset page HTML).
- Create: `test/data/csv_source_test.dart` — tests that discovery returns at least one URL and that fetch returns non-empty CSV body for that URL.

**Steps:**
1. Write failing test: e.g. `expect(await source.snapshotUrls(), isNotEmpty)` and `expect(await source.fetchCsv(url), contains(','))`.
2. Run: `flutter test test/data/csv_source_test.dart` — expect FAIL (source not implemented).
3. Implement: Either (a) hardcoded list of 2–3 known CSV permalink URLs from data.gov.rs, or (b) HTTP get dataset page, parse HTML for resource links. Implement fetch via `http.get`, return response body as string.
4. Run test again — expect PASS. Handle encoding (UTF-8) if needed.
5. Commit: "feat(data): discover and fetch RPG CSV URLs".

**Note:** If CSV URLs use a different base (e.g. data.gov.rs vs another domain), discover correct URL format in this task and document in code or JOURNAL.md.

---

### Task 3: CSV parsing and domain models (TDD)

**Files:**
- Create: `lib/data/rpg_models.dart` — e.g. `RpgSnapshot` (id/date/label), `OpstinaRow` (opstinaName, totalRegistered, totalActive, or per-column counts for future chart). Exact fields depend on actual CSV columns (discover in Task 2 or by downloading one CSV manually).
- Create: `lib/data/csv_parser.dart` — parse CSV string → `List<OpstinaRow>` and snapshot date/label.
- Create: `test/data/csv_parser_test.dart` — test with a small inline CSV string (same column structure as real data); expect parsed rows and totals.

**Steps:**
1. Document or infer CSV column structure (opština name, registered count, active count, etc.). Add a 2–3 line sample CSV in test.
2. Write failing test: parse sample CSV, expect list length and one row's values.
3. Run: `flutter test test/data/csv_parser_test.dart` — FAIL.
4. Implement parser (split lines, handle header, parse numbers; handle Cyrillic→Latin if needed for display).
5. Run test — PASS.
6. Commit: "feat(data): parse RPG CSV into domain models".

---

### Task 4: Storage abstraction and local DB — interface + SQLite (mobile) (TDD)

**Files:**
- Create: `lib/data/storage.dart` — **abstract interface** (e.g. `RpgStorage`): `saveSnapshot(snapshot, rows)`, `getSnapshotList()`, `getNationalTotals(snapshotId)`, `getTopOpstine(snapshotId, n)`, `getOpstina(snapshotId, opstinaName)`. No platform types in the interface.
- Create: `lib/data/local_db.dart` (or `database.dart`) — **SQLite implementation** of the interface: drift or sqflite with table(s) for snapshots (id, label, date, fetched_at) and holdings (snapshot_id, opstina_name, registered, active, or one row per org form if needed).
- Create: `lib/data/repository.dart` — repository that **depends on** `RpgStorage` (injected); exposes same API so Riverpod and sync use the repository; repository forwards to the storage impl. On mobile, inject SQLite-backed storage (use `kIsWeb` or platform check to choose impl later).
- Create: `test/data/repository_test.dart` — use a **fake or in-memory** storage impl (implement the interface with a simple map/list) so tests don't depend on SQLite or web. Save one snapshot with 2–3 rows; expect getSnapshotList, getNationalTotals, getTopOpstine, getOpstina to return correct values.

**Steps:**
1. Define the storage interface in `storage.dart`.
2. Write failing tests for repository (save + get) using a fake storage.
3. Run tests — FAIL.
4. Implement repository that delegates to storage; implement in-memory/fake storage for tests. Implement SQLite-backed storage in `local_db.dart` and wire it for mobile (platform check or separate registration).
5. Run tests — PASS.
6. Commit: "feat(data): storage abstraction and SQLite impl for mobile".

---

### Task 5: Sync pipeline (fetch → parse → save) and refresh trigger

**Files:**
- Modify: `lib/data/csv_source.dart` or new `lib/data/sync.dart` — `syncFromRemote()`: get snapshot URLs, for each URL fetch CSV, parse, save via repository. On first run or refresh, run sync.
- Create: `test/data/sync_test.dart` — mock or fake CSV source (return fixed string); run sync; assert repository has expected data (or snapshot list updated).

**Steps:**
1. Write failing test: after sync with mocked CSV content, repository contains snapshot and rows.
2. Implement sync: loop over URLs from csv_source, fetch, parse, save. Decide snapshot identity (e.g. by date from filename or first row).
3. Run test — PASS.
4. Commit: "feat(data): sync pipeline fetch-parse-save".

---

### Task 5b: Web storage implementation (IndexedDB)

**Files:**
- Create: `lib/data/storage_web.dart` (or `web_storage.dart`) — **implementation** of `RpgStorage` that uses IndexedDB on web. Use a package such as `idb_sqflite` (if compatible with our interface) or drift's web backend, or a thin IndexedDB wrapper that stores snapshot list and holdings (e.g. by snapshot id key). Same schema semantics as SQLite (snapshots + rows per opština).
- Wire in app: in `main.dart` or a bootstrap provider, when `kIsWeb` is true, register/provide the web storage impl instead of SQLite. Repository stays unchanged; only the concrete storage impl is swapped.

**Steps:**
1. Add dependency for web persistence (e.g. `idb_sqflite`, or drift with web, or `indexed_db` / similar).
2. Implement `RpgStorage` for web: open IndexedDB store(s), implement saveSnapshot (write snapshot + rows), getSnapshotList, getNationalTotals, getTopOpstine, getOpstina (read and aggregate as needed).
3. Register web storage when running on web; run `flutter run -d chrome`, trigger sync, and verify data persists and UI shows it after reload.
4. Commit: "feat(data): web storage impl (IndexedDB)".

---

### Task 6: Riverpod providers for data

**Files:**
- Create: `lib/providers/data_providers.dart` — AsyncValue providers: `snapshotListProvider`, `selectedSnapshotIdProvider` (StateProvider, default latest), `nationalTotalsProvider(snapshotId)`, `topOpstineProvider(snapshotId, n)`, `opstinaDetailProvider(snapshotId, opstinaName)`. A provider that triggers sync (e.g. `syncProvider` or call sync in app init / refresh).
- Wire sync: on app start (or when opening Home), call sync once; providers read from repository. Expose loading/error from sync and from repository reads.
- Create: `test/providers/data_providers_test.dart` — override repository with fake; expect providers yield expected data.

**Steps:**
1. Write failing test for at least one provider (e.g. snapshotListProvider returns list after fake repo has data).
2. Implement providers; ensure repository is injectable (Riverpod override for tests).
3. Run test — PASS.
4. Commit: "feat(providers): Riverpod data providers and sync trigger".

---

## Phase 2 — Navigation and screens

### Task 7: Routing (GoRouter) and shell

**Files:**
- Create: `lib/app/router.dart` — GoRouter with routes: `/` (Home), `/map` (Map), `/opstina/:id` or `/opstina?name=...&snapshotId=...` (Detail), `/about` (About). Use ShellRoute if bottom nav: shell with child routes.
- Modify: `lib/main.dart` — ProviderScope + MaterialApp.router(routerConfig: goRouter).
- Create: `test/app/router_test.dart` — test that initial route is Home and that navigating to /about shows About (or route config matches).

**Steps:**
1. Write failing test for route resolution (e.g. goRouter.routerDelegate.currentConfiguration matches expected).
2. Implement GoRouter with placeholder screens (each screen: Scaffold + AppBar + text).
3. Run test — PASS.
4. Commit: "feat(nav): GoRouter and placeholder screens".

---

### Task 8: Home screen — dashboard and dropdown

**Files:**
- Create: `lib/screens/home_screen.dart` — build from `snapshotListProvider`, `nationalTotalsProvider(selectedSnapshotId)`, `topOpstineProvider(selectedSnapshotId, 5)`. Show loading/error/retry. Dropdown to select opština (from full list: all opštine for selected snapshot). When opština selected: show quick view (key numbers). Button/link "Pogledaj sve" → navigate to Detail with opština + snapshot. Use **responsive layout** (e.g. `LayoutBuilder` or breakpoints) so the screen works on narrow (phone) and wide (desktop) viewports.
- Create: `lib/providers/opstina_list_provider.dart` or extend data_providers — provider that returns list of opština names for selected snapshot (for dropdown).
- Test: `test/screens/home_screen_test.dart` — pump with overrides: mock snapshot list and national totals; expect dashboard text and dropdown present; tap "Pogledaj sve" and verify go_router navigation.

**Steps:**
1. TDD: write widget test (overridden providers, expect summary and dropdown).
2. Implement Home: national summary, top 5 list, dropdown (opština list), quick view when selected, "Pogledaj sve" → Detail.
3. Run test — PASS.
4. Commit: "feat(ui): Home screen dashboard and opština dropdown".

---

### Task 9: Opština detail screen

**Files:**
- Create: `lib/screens/opstina_detail_screen.dart` — reads opština name and snapshotId from route params/query; uses `opstinaDetailProvider(snapshotId, name)`. Shows totals, "as of [date]". Snapshot switcher (dropdown or chips) to change selected snapshot for this screen (or use global selectedSnapshotId). Back button.
- Test: `test/screens/opstina_detail_screen_test.dart` — override provider with fake data; expect totals and snapshot label.

**Steps:**
1. TDD: widget test for detail screen with overridden provider.
2. Implement detail screen + snapshot switcher.
3. Run test — PASS.
4. Commit: "feat(ui): Opština detail screen with snapshot switcher".

---

### Task 10: Map screen (opštine tappable → Detail)

**Files:**
- Create: `lib/screens/map_screen.dart` — map of Serbia. Options: (a) Use a GeoJSON of opština boundaries (e.g. from GeoSrbija or open source) + flutter_map or similar to render and tap; (b) List of opštine with coordinates (center points) and markers; tap marker → navigate to Detail. Choose one approach; document source of geography in code.
- Wire: tap opština → GoRouter to Detail with opština name + snapshotId.
- Test: `test/screens/map_screen_test.dart` — pump MapScreen, tap one opština (or first marker), verify navigation to Detail with correct params.

**Steps:**
1. Research: find GeoJSON or coordinate list for Serbian opštine (e.g. data.gov.rs, GeoSrbija, or static list). Add dependency (e.g. flutter_map, latlong2) if needed.
2. TDD: widget test for map screen and tap → navigation.
3. Implement map + tap → Detail.
4. Run test — PASS.
5. Commit: "feat(ui): Map screen with tappable opštine".

---

### Task 11: About screen (attribution + disclaimer)

**Files:**
- Create: `lib/screens/about_screen.dart` — Title "O aplikaciji" / "Izvor podataka". Paragraph: data from data.gov.rs, dataset link (canonical URL), publisher (Uprava za agrarna plaćanja), license (Javni podaci). Separate paragraph: independent developer, not affiliated with government or any state body; learning/community project using open data. Use link_launcher for dataset URL.
- Test: `test/screens/about_screen_test.dart` — expect find.text with substring of disclaimer and find.byType(Link) or tap and verify URL.

**Steps:**
1. TDD: widget test for About content (attribution + disclaimer text).
2. Implement About screen with all required text and link.
3. Run test — PASS.
4. Commit: "feat(ui): About screen attribution and disclaimer".

---

### Task 12: Loading, error, retry UX

**Files:**
- Modify: Home (and any screen that depends on sync): when sync fails or repository empty, show error message + Retry button. Retry triggers sync again. Loading: show progress indicator until data is ready.
- Optional: pull-to-refresh on Home (and Map?) to trigger sync.
- Test: in existing tests or new test — override to simulate error state; expect error widget and Retry; on Retry, expect sync called again.

**Steps:**
1. Add or extend test for error + retry.
2. Implement loading/error/retry on Home (and sync trigger on app start).
3. Run tests — PASS.
4. Commit: "feat(ui): loading, error, retry for data".

---

## Phase 3 — Polish and production readiness

### Task 13: ABOUTME and code standards pass

**Files:** All `lib/**/*.dart` and `test/**/*.dart`.

**Steps:**
1. Ensure every code file starts with 2-line comment: `// ABOUTME: ...` (what the file does). Match project naming (no implementation-detail or temporal names). No stray comments about "new" or "refactored".
2. Run linter: `flutter analyze`.
3. Fix any violations.
4. Commit: "chore: ABOUTME and lint pass".

---

### Task 14: Integration test (optional but recommended)

**Files:**
- Create: `integration_test/app_test.dart` — launch app, wait for Home (or loading then Home), tap dropdown, select first opština, tap "Pogledaj sve", expect Detail screen. Use real (or test) backend if possible; or use fake providers for deterministic integration test.

**Steps:**
1. Write integration test that runs one happy path (Home → select opština → Detail).
2. Run: `flutter test integration_test/app_test.dart` (or `flutter drive` if needed).
3. Commit: "test: integration test happy path".

---

### Task 15: Web target and responsive layout pass

**Files:**
- All screens and shell (router shell, Home, Map, Detail, About): ensure layout adapts to width (e.g. `LayoutBuilder`, or responsive padding/columns). No hard-coded mobile-only assumptions (e.g. bottom nav can be sidebar on wide; or keep bottom nav but ensure content doesn't overflow).
- Run: `flutter run -d chrome` (or `flutter run -d web-server`); test full flow in browser (sync, dashboard, dropdown, Detail, Map, About). Fix any web-specific issues (e.g. CORS if fetching tiles/GeoJSON from external URLs; link_launcher for web).

**Steps:**
1. Run app on web; click through all screens and verify data and navigation.
2. Adjust layout where needed for desktop viewport; ensure map and tables/charts (if any) are usable on large screens.
3. Commit: "feat(web): responsive layout and web target verification".

---

### Task 16: README and run instructions

**Files:**
- Create or update: `README.md` — one paragraph what the app is (mobile and web); how to run (`flutter pub get`, `flutter run` for device, `flutter run -d chrome` for web); link to design (docs/DESIGN.md) and data source (canonical URL). No status/deliverables list.

**Steps:**
1. Add README with run instructions (including web) and design link.
2. Commit: "docs: README and run instructions".

---

## Execution summary

- **Phase 1 (Tasks 1–6 + 5b):** Bootstrap (mobile + web targets), CSV discovery/fetch, parse, **storage abstraction + SQLite (mobile)** + **web storage (IndexedDB)**, sync, Riverpod. All tests for data layer.
- **Phase 2 (Tasks 7–12):** Router, Home, Detail, Map, About, loading/error/retry (responsive layout in screens).
- **Phase 3 (Tasks 13–16):** Lint/ABOUTME, integration test, **web target and responsive pass**, README.

**Order:** Execute in task order; each task ends with tests passing and a commit. If a task uncovers CSV structure or URL differences, document in JOURNAL.md and adjust subsequent tasks (e.g. parser or DB columns) accordingly.

---

**Plan saved to:** `docs/plans/2026-02-24-rpg-app-implementation.md`

Two execution options:

1. **Subagent-driven (this session)** — I dispatch a subagent per task (or batch of small tasks), review between steps, fast iteration.
2. **Parallel session (separate)** — You open a new session (e.g. in a worktree), use executing-plans skill, and run through the plan task-by-task with checkpoints.

Which approach do you want, Milan?
