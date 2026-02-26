# RPG app — design and spec

Design and product specification for the Flutter app (mobile and web) that surfaces Serbia's RPG (Registar poljoprivrednih gazdinstava) open data.

---

## 1. Product overview and goals

**What we're building**  
A production-ready Flutter app for **mobile and web** that surfaces Serbia's RPG open data: number of registered and active agricultural holdings by municipality (opština). Same codebase, one UI: mobile-first and responsive for desktop browsers. Data comes from the [data.gov.rs RPG dataset](https://data.gov.rs/sr/datasets/rpg-broj-svikh-registrovanikh-poljoprivrednikh-gazdinstava-aktivna-gazdinstva/) (Uprava za agrarna plaćanja), published as quarterly CSV snapshots (e.g. 31.12.2025, 07.07.2025). The app is **Serbian, Latin only**, and **online-only** for v1 (no offline cache).

**Goals**  
Give citizens, farmers, policymakers, researchers, and the general public easy access to this open data — on their phone or in the browser. Many people in Serbia prefer a website over installing an app; the web build serves that use case. The app is an **independent, non-official** project: the author is not affiliated with the government or any state body; it's a learning and community project using open data. That and full data attribution are stated clearly on the **About** screen.

**Users**  
Multiple audiences: quick lookups ("how many holdings in my opština"), national/regional overview, and light exploration (map, snapshot date). The UI should support both "glance at one number" and "drill into one place."

**Out of scope for v1**  
Offline support; Cyrillic or English; breakdown by organizational form on the detail screen (planned later as a **chart**); table-only breakdown.

---

## 2. Screens and navigation

**Screens**

1. **Home** — Dashboard when nothing is selected: national summary (totals for Serbia, "as of [date]") and a short list (e.g. top 5 opštine by number of holdings). Opština **dropdown** on the same screen: choosing an opština shows a **quick view** (key numbers) on the home screen. A "Pogledaj sve" (or similar) action opens the opština **detail screen**.
2. **Map** — Separate screen: map of Serbia with tappable opštine. Tapping an opština opens the **same detail screen** as from the home dropdown.
3. **Opština detail** — Shows totals for the selected opština for the chosen snapshot. **Latest snapshot by default**; an optional control (e.g. on this screen) lets the user **switch snapshot date** for v1. No breakdown by organizational form in v1 (planned later as a chart).
4. **About (O aplikaciji / Izvor podataka)** — Full attribution: link to the dataset (canonical URL below), publisher (Uprava za agrarna plaćanja), license (Javni podaci). **Explicit disclaimer**: independent developer, not affiliated with government or any state body; app is a learning/community project using open data.

**Canonical dataset URL**  
https://data.gov.rs/sr/datasets/rpg-broj-svikh-registrovanikh-poljoprivrednikh-gazdinstava-aktivna-gazdinstva/

**Navigation**  
Exact structure is for the implementation plan (e.g. bottom nav: Home, Map, About; or Home + drawer with Map and About). Home and Map are primary; About is reachable from a menu or footer.

**Consistency**  
The detail screen is the single place for "full" opština data, whether the user arrived from the home dropdown or from the map.

---

## 3. Data and behaviour

**Data source**  
All figures come from the data.gov.rs RPG dataset. The dataset has multiple CSV resources, one per snapshot date (e.g. 31.12.2025, 07.07.2025), with columns for opština and counts (including "prema organizacionom obliku"). The app consumes these CSVs. How we obtain the files (catalog page, fixed list, or any future API) is an implementation detail; the product assumes we have snapshot-dated data per opština and national totals.

**Snapshot / date**  
Each CSV is one snapshot. **Default** everywhere is the **latest** snapshot (by resource date). For v1 there is an **optional** way to choose another snapshot (e.g. on the detail screen or a shared control), so dashboard, quick view, and detail can show "as of [date]". No time-series comparison in v1.

**What we show**

- **National**: Totals (registered and/or active holdings) for Serbia for the selected snapshot; "as of [date]".
- **Top list**: e.g. top 5 opštine by count (for the selected snapshot).
- **Quick view (home)**: Key numbers for the selected opština (same snapshot as rest of app).
- **Detail**: Totals for that opština, snapshot date visible, optional snapshot switcher. No organizational-form breakdown in v1.

**Online-only**  
No offline cache. Every load depends on network. We need clear **loading** and **error** states (no network, server error, empty data) and a way to **retry**. No "last cached" fallback for v1.

**Script**  
UI and copy in **Serbian Latin** only. If CSVs use Cyrillic headers or values, we parse and/or display them in Latin (transliterate or use a mapping as needed).

---

## 4. Data acquisition and storage

**No API**  
The dataset does not expose a REST API; only the dataset page and **downloadable CSV resources** (one CSV per snapshot). Each snapshot has a direct download URL (e.g. the 31.12.2025 CSV).

**Flow**

1. **Discover** — Determine which CSV URLs exist (e.g. by parsing the dataset page or maintaining a list of known snapshot URLs).
2. **Fetch** — Download CSV(s) over HTTP.
3. **Parse** — Parse CSV content (opština, counts, organizational form columns as needed for future use).
4. **Store** — Write parsed data into a **local database** (e.g. SQLite via `drift` or `sqflite`).
5. **Read** — All app UI reads from the local DB: national totals, top N opštine, per-opština detail, snapshot list. Snapshot switching is "which snapshot to query" in the DB.

**Refresh**  
When to refresh from the source (on app start, pull-to-refresh, or both) is decided in the implementation plan. After first successful fetch and parse, the app can show data from the DB until the next refresh.

**Rationale**  
A local DB gives a single source of truth for the app, fast reads after first load, and a clear data layer; it also sets up optional offline/cache behaviour in a later iteration.

**Platform storage (mobile + web)**  
The app runs on **mobile** (iOS/Android) and **web**. Mobile can use SQLite (e.g. drift or sqflite). Flutter web does not support the same SQLite stack; persistence on web uses a different backend (e.g. **IndexedDB**). To keep one codebase, the **data layer is platform-agnostic**: define a **storage abstraction** (interface for "save snapshot + rows" and "read snapshot list, national totals, top N, per-opština"). Implement it with SQLite on mobile and with IndexedDB (or a package that wraps IndexedDB for the same API) on web. The repository and all UI depend only on this interface, so switching platform only swaps the implementation.

---

## 5. Non-functional and production aspects

**Production-ready** means the app is stable, testable, and suitable for real users and (if desired) store release: **tested** (unit and widget/integration where it matters, per project TDD rules), **clear error and loading UX** (no silent failures), **no obvious crashes or data corruption**, and **code** that matches project standards (Riverpod, naming, ABOUTME comments, etc.). Whether to publish to stores in v1 is a separate decision; the design does not block it.

**Performance**  
Data volume is small (one CSV per snapshot, on the order of hundreds of KB). Load and parse on demand (or after fetching the catalog) and avoid blocking the UI; show loading indicators until data is ready. No specific performance targets beyond "feels responsive."

**Accessibility**  
No specific a11y requirements in the spec beyond: use semantic widgets where appropriate, support reasonable text scaling, and ensure interactive elements (dropdown, map taps, buttons) are focusable and usable. Deeper a11y can be refined in implementation or a later iteration.

**Security and privacy**  
No login or personal data. The app only displays public open data and opens the dataset URL in the About screen. No analytics or tracking in scope unless added later; any such addition would need to be disclosed (e.g. in About or a privacy note).

**Attribution and disclaimer**  
The About screen is the single place for: canonical dataset link, publisher (Uprava za agrarna plaćanja), license (Javni podaci), and the explicit text that the app is by an independent developer, not affiliated with the government or any state body, and that the app is a learning/community project using open data.

**Platforms (mobile + web)**  
Ship the same Flutter app as a **mobile** build (iOS/Android) and a **web** build (deployable to any static host). Use responsive layout (e.g. breakpoints, `LayoutBuilder`) so screens work on small and large viewports; navigation and features are identical. Enable the web target from the start and test in the browser as the UI is built.

---

## 6. Visual design

**Base**  
Material 3 with **system fonts**. Default to a **light** theme so the app feels open and readable; dark theme optional. Use a **vibrant medium green** as the primary accent (not a dark green); reference: polished M3/dashboard-style Figma kits.

**Color and surfaces**  
- **Background**: Light (white or off-white); generous spacing (e.g. 16/24 px padding).
- **Accent**: Vibrant medium green for primary actions, app bar, selected state, and key section titles. Green is used **inside** cards (headers, buttons, icons), not as the card fill.
- **Cards**: White (or light surface variant), rounded corners, light elevation or subtle border so they sit clearly above the background. Section headers or key elements inside cards can use the accent green.

**Typography**  
- **Strong hierarchy**: Section titles are clearly larger and bolder (e.g. headlineSmall or titleLarge); body text smaller and regular weight; labels distinct. Section titles (e.g. "Nacionalni zbir", "Top 5 opština") may use the accent green.
- Use M3 type scale via `ThemeData.textTheme`; avoid subtle-only size differences so headings read as headings and body as body.

**Icons**  
- **Section icons**: Each dashboard block has a small icon (e.g. national summary, top 5 list, opština dropdown) so the home screen reads as a dashboard, not a document. Icons monochromatic (grey or accent green).
- **Navigation and actions**: Bottom nav and buttons use icons where it helps (already in place for nav); keep consistent.

**National total (hero block)**  
- The national summary is a **prominent hero block**: large numbers (registered / active), short label, and an icon. It is the visual anchor of the dashboard — one clear "headline" block, not just another card of text.

**Charts where they make sense**  
- **Top 5 opštine**: A **bar chart** (horizontal or vertical) for the five opštine and their active (or registered) count makes sense and gives a quick visual comparison. Include it on the home dashboard.
- **National total**: No chart; the hero block with big numbers is enough. Optional later: a tiny "registered vs active" proportion if useful.
- **Opština detail**: Totals only in v1; no chart. Future iteration: breakdown by organizational form as a chart (see §7).

**Implementation**  
One app-wide `ThemeData` (light default; optional `darkTheme`); screens use semantic text styles and theme colors. Add hero block and section icons to the home screen; add a bar chart for the top 5 list. No new app flows; same structure, clearer hierarchy and dashboard feel.

### 6.1 Visual design: current gaps and recommendations

Analysis of the current UI (theme, Home, Map, Detail, About) against §6 and “polished dashboard” intent — concrete changes that would make the app feel nicer for the end user.

**Hero block (national summary)** — **chosen: full hero treatment**  
- **Gap**: Same card style as other sections; numbers use `headlineMedium` and sit inline with labels, so the block doesn’t read as the main anchor.  
- **Decision**: Make it the clear focal point. Use `displaySmall` or `headlineLarge` for the two totals (registered / active), each on its own line with a short label above. Add more vertical padding (e.g. 20–24 px). Add a very subtle primary-tinted top border or soft gradient so it reads as “hero” rather than “first card”.

**App bar** — **chosen: green app bar**  
- **Gap**: Default M3 app bar (surface, no strong identity).  
- **Decision**: Use `backgroundColor: colorScheme.primary` and `foregroundColor: colorScheme.onPrimary` app-wide so the app has a clear green identity. Apply in `AppBarTheme` in `lib/app/theme.dart` (and dark theme equivalent).

**Section hierarchy and SectionHeader**  
- **Gap**: `SectionHeader` uses `titleMedium` only; DESIGN §6 says section titles “may use the accent green”. About screen sections don’t use green.  
- **Recommendation**: Use `colorScheme.primary` and `titleLarge` (or `headlineSmall`) for `SectionHeader` so “Izvor podataka” / “Napomena” match the dashboard feel. Keep `DataCard` titles in primary as they already are.

**Spacing and rhythm**  
- **Gap**: 16/24 is good; sections can still feel a bit tight on small screens.  
- **Recommendation**: Use 24 px between major sections consistently; consider 32 px before “Izaberi opštinu” to separate “dashboard blocks” from “selection”. Max content width (e.g. 800 px) for wide layout is already in place — keep it.

**Top 5 and chart**  
- **Gap**: Bar chart and list are correct; axis labels truncate long names (e.g. 8 chars + “.”).  
- **Recommendation**: Keep chart; optionally show full name in a tooltip or in the list below. Ensure chart uses `colorScheme.primary` and that list items use `bodyMedium` so hierarchy is clear.

**Municipality dropdown and quick view**  
- **Gap**: Dropdown and quick view are clear; quick view is a second card with two lines + button.  
- **Recommendation**: Optionally use a small location icon or primary-colored “Pogledaj sve” (already an ElevatedButton) so the CTA is obvious. No structural change required.

**Detail screen**  
- **Gap**: Single card with “Registrovano: X” and “Aktivno: Y” in `bodyLarge` — reads like a form, not a summary.  
- **Recommendation**: Treat as a small “detail hero”: same numbers in `titleLarge` or `headlineSmall`, one per line with a short label; optional small icon (e.g. agriculture or location_city) in the card header. Snapshot switcher can stay as-is above the card.

**Map screen**  
- **Gap**: Plain `ListView` of `ListTile`s; no section title or visual tie-in to the rest of the app.  
- **Recommendation**: Add a short `SectionHeader` (e.g. “Opštine”) or a subdued subtitle (“Izaberi opštinu za pregled”) at the top. Style list tiles to match theme (padding, shape); selectedItemColor for bottom nav if not already set.

**About screen**  
- **Gap**: Plain text and one link; no cards.  
- **Recommendation**: Use two `DataCard`s (or Card + padding): one for “Izvor podataka” + link, one for “Napomena” + disclaimer. Same 16 px padding and 12 px radius as rest of app so About feels part of the same system.

**Bottom navigation**  
- **Gap**: Default M3 bottom nav.  
- **Recommendation**: Set `selectedItemColor: colorScheme.primary` and `unselectedItemColor: colorScheme.onSurfaceVariant` (or equivalent) so selected tab is clearly green and consistent with the rest of the theme.

**Loading and error states**  
- **Gap**: Centered text + “Pokušaj ponovo” is correct; can feel stark.  
- **Recommendation**: Keep text and button; optionally wrap in a Card with padding so the error block has the same visual language as data blocks. No need for illustrations in v1.

**Summary**  
- **Decided**: Green app bar; hero block with full treatment (bigger numbers, more padding, subtle primary tint).  
- **Remaining recommendations**: SectionHeader in primary + larger style, detail screen numbers promoted, bottom nav selected color, About in cards, map section title; optional tooltip for top 5, error state in Card.

Figma-to-code rules for this project are in `.cursor/rules/figma-design-system.mdc` so any Figma-driven UI follows the same tokens and components.

### 6.2 Implementation plan (visual design)

Ordered steps to implement §6 and §6.1. Adjust this list as needed before coding.

1. **Theme: app bar**  
   In `lib/app/theme.dart`, set `AppBarTheme` for light (and dark) theme: `backgroundColor: colorScheme.primary`, `foregroundColor: colorScheme.onPrimary`, `iconTheme: IconTheme(color: colorScheme.onPrimary)`, `titleTextStyle` using `colorScheme.onPrimary`. Ensure all screens use the same app bar (no overrides unless needed for a specific screen).

2. **Theme: bottom navigation**  
   In `lib/app/theme.dart`, set `BottomNavigationBarThemeData`: `selectedItemColor: colorScheme.primary`, `unselectedItemColor: colorScheme.onSurfaceVariant` (or `onSurface` with reduced opacity).

3. **Theme: SectionHeader**  
   In `lib/widgets/section_header.dart`, use `colorScheme.primary` and `textTheme.titleLarge` (or `headlineSmall`) for the section title so About and any other screen using `SectionHeader` get the accent and hierarchy.

4. **Home: hero block**  
   In `lib/screens/home_screen.dart`, refactor `_NationalSummary` (or the `DataCard` that wraps it) so that: (a) the two totals use `displaySmall` or `headlineLarge`, each on its own line with label above; (b) inner padding is 20–24 px; (c) the card has a subtle primary-tinted top border or a very soft primary gradient at the top so it reads as the hero. Keep the existing icon and “Nacionalni zbir” / “Od: …” subtitle.

5. **Detail screen: numbers as summary**  
   In `lib/screens/municipality_detail_screen.dart`, show “Registrovano” and “Aktivno” with numbers in `titleLarge` or `headlineSmall`, one per line with label above; optionally add a small icon in the card header.

6. **About screen: cards**  
   In `lib/screens/about_screen.dart`, wrap “Izvor podataka” + link in one `DataCard` (or `Card` with same padding/radius), and “Napomena” + disclaimer in another. Use `SectionHeader` or card title for the two section titles.

7. **Map screen: section title**  
   In `lib/screens/map_screen.dart`, add a `SectionHeader` (e.g. “Opštine”) or short subtitle at the top of the list. Optionally adjust list tile padding/shape to match theme.

8. **Optional / later**  
   - Error state: wrap centered error text + “Pokušaj ponovo” in a `Card` with padding on Home/Map where applicable.  
   - Top 5: tooltip or full municipality name in list (chart labels can stay truncated).  
   - Quick view: no change unless you want a small icon next to “Pogledaj sve”.

**Dependencies**: (1) and (2) are theme-only. (3) is a single widget. (4)–(7) are screen-level and can be done in any order after theme and SectionHeader; (4) is the most visible. Adjust order or split steps if you prefer (e.g. “hero” in two commits: typography first, then tint/border).

---

## 7. Spec summary and implementation plan scope

The implementation plan should cover at least:

- **Data layer**: Discovering/fetching CSV URLs, parsing, **storage abstraction** (interface + SQLite impl for mobile, IndexedDB or equivalent impl for web), refresh strategy, Riverpod providers for reading from storage.
- **Screens**: Home (dashboard, dropdown, quick view), Map (opština boundaries or equivalent, tap → detail), Opština detail (totals, snapshot switcher), About (attribution + disclaimer).
- **Navigation**: Bottom nav or drawer (Home, Map, About).
- **Loading, error, retry**: UX and state handling for no network, server errors, empty data.
- **Tests**: TDD per project rules; tests for parsing, DB access, and critical UI flows.
- **Map**: Source of opština geography (e.g. GeoJSON or other) and how to make opštine tappable; same detail screen as from home.
- **Web**: Enable web target; run and test in browser; ensure responsive layout (no mobile-only assumptions). Storage on web via the same abstraction (IndexedDB-backed impl).
- **Visual design**: Custom Material 3 theme (colors, typography, component styles, spacing) inspired by community M3 Figma designs; system fonts; applied app-wide so the UI looks polished and consistent (see §6).

Future iteration (not v1): breakdown by organizational form on detail screen, presented as a **chart** (e.g. bar or pie), not table-only.
