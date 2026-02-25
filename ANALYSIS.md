# Deep Analysis: RPG App Repository

**Date:** 2026-02-25
**Branch:** `claude/analyze-repo-issues-AmCnS`

---

## Executive Summary

This is a **well-planned but pre-implementation** Flutter project. The repository contains comprehensive design and implementation documentation but **zero production code**. Several **critical issues** and **improvement areas** have been identified that will impact implementation success.

---

## Critical Issues

### 1. ⛔ **Missing Platform-Agnostic Storage Interface**
**Severity:** CRITICAL (Architectural blocking issue)
**Location:** Planned but not started (Task 4)

**Problem:**
- The design correctly identifies the need for a platform-agnostic storage interface to support both SQLite (mobile) and IndexedDB (web)
- However, the plan does NOT clearly specify:
  - How Riverpod will inject different storage implementations per platform
  - Whether to use `kIsWeb` platform checks or a service-locator pattern
  - How tests will override storage without hitting platform-specific libraries
  - Whether to use abstract classes, interfaces, or mixins

**Impact:** Starting implementation without this decision will lead to:
- Tight coupling between UI/data layer and platform-specific code
- Difficult testing (tests may fail on web or mobile due to imports)
- Risk of duplicating storage logic across platforms

**Action Required:** Before Task 1 starts, document:
1. Storage interface signature (exact Dart definition)
2. Concrete implementations for mobile (SQLite) and web (IndexedDB)
3. Platform detection and registration strategy in main.dart / bootstrap
4. How tests will use a fake/in-memory implementation

---

### 2. ⛔ **CSV Discovery Strategy Undefined**
**Severity:** CRITICAL (Data layer blocking)
**Location:** Task 2

**Problem:**
- Plan says: "v1: hardcoded list of known CSV URLs from data.gov.rs dataset page, or parse dataset page HTML"
- **No decision has been made** on which approach to use
- HTML parsing is fragile (changes to data.gov.rs structure break parsing)
- Hardcoding URLs limits flexibility but is stable
- No fallback or error recovery if URLs become invalid

**Impact:**
- If parsing approach chosen and breaks, app silently has no data
- If hardcoding chosen, maintaining URL list is manual and error-prone

**Action Required:** Milan must decide:
1. **Hardcoded list** (stable, manual maintenance)
2. **HTML parsing** (flexible, fragile)
3. **Hybrid** (hardcoded with fallback to parse)

Document the chosen approach and add to JOURNAL.md.

---

### 3. ⚠️ **Web Storage Implementation Unresolved**
**Severity:** HIGH (Scope creep risk)
**Location:** Task 5b

**Problem:**
- Plan mentions **four different approaches** for web storage:
  - `idb_sqflite` (may not fully implement the interface)
  - `drift` with web backend (adds complexity, different from mobile drift)
  - Custom IndexedDB wrapper
  - `indexed_db` package
- **No decision on which package to use**
- Different packages have different APIs and compatibility

**Impact:**
- Implementation phase will face integration issues
- May require redesigning storage interface mid-implementation
- Tests may discover breaking incompatibilities

**Action Required:** Before Task 1:
1. Test at least one web storage package to confirm API compatibility with mobile storage interface
2. Decide on the package and document in JOURNAL.md
3. Add proof-of-concept code to verify it works in tests

---

### 4. ⚠️ **No Offline Strategy Defined (Future Scope)**
**Severity:** MEDIUM (Future-proofing)
**Location:** Design section 4

**Problem:**
- Spec says "online-only for v1" but doesn't define how to evolve to offline
- Current storage abstraction assumes no offline cache
- If built naively, adding offline later requires major refactoring

**Impact:**
- Future iteration will require rewriting data layer
- Current implementation may hardcode "refresh on every load" in ways that prevent offline

**Action Required:** While building v1 storage layer:
1. Design the interface to be **offline-capable** (even if offline is disabled in v1)
2. Add a `lastUpdated` timestamp to snapshots
3. Document the "future offline" strategy in JOURNAL.md

---

### 5. ⚠️ **GeoJSON / Map Geography Source Not Identified**
**Severity:** MEDIUM (UI blocking for Task 10)
**Location:** Task 10 (Map screen)

**Problem:**
- Plan says: "Choose one approach; document source of geography in code"
- **No source has been identified** for Serbian opština GeoJSON
- Options mentioned: GeoSrbija, open source, static list
- No links, no format verified

**Impact:**
- Task 10 implementation will be blocked until geography source is found and downloaded
- May discover GeoJSON is in Cyrillic or unexpected format

**Action Required:**
1. Before Task 1, find and download Serbian opština GeoJSON (or coordinate list)
2. Verify it matches opština names in CSV (exact spelling, case sensitivity)
3. Add download link to JOURNAL.md and code
4. Create a `data/geography.json` or similar with the source

---

### 6. ⚠️ **CSV Column Structure Not Fully Specified**
**Severity:** MEDIUM (Parser implementation blocking)
**Location:** Task 3

**Problem:**
- Plan says: "Exact fields depend on actual CSV columns (discover in Task 2)"
- **Actual CSV hasn't been downloaded and inspected**
- The spec mentions:
  - Opština name
  - Total registered
  - Total active
  - "Per-column counts for future chart" (organizational form breakdown)
- **Cyrillic vs Latin handling not tested**

**Impact:**
- Parser logic may be wrong (wrong column indices, wrong field names)
- Transliteration/encoding may fail on real data
- "Future chart" data fields may not be present or be differently named

**Action Required:** Before Task 2 completes:
1. Download the **actual latest CSV** from data.gov.rs
2. Inspect columns, sample rows, and encoding
3. Document actual column names and any Cyrillic/Latin handling needed
4. Add sample CSV (first 5 rows) to JOURNAL.md for reference

---

### 7. ⚠️ **Navigation Structure Underspecified**
**Severity:** MEDIUM (Router implementation risk)
**Location:** Task 7 / Design section 2

**Problem:**
- Design says: "bottom nav or drawer; exact structure is for the implementation plan"
- Plan doesn't specify which one to use
- This affects:
  - Screen composition (ShellRoute vs separate routes)
  - Responsive behavior on large screens (drawer becomes sidebar, bottom nav becomes top/side nav)
  - How detail screens fit into navigation

**Impact:**
- Router implementation will make assumptions that may conflict with responsive design later
- May require refactoring GoRouter structure in Task 15 (Web/responsive pass)

**Action Required:** Before Task 7:
1. Decide: **bottom nav or drawer**?
2. Decide: **How does it adapt on desktop** (wide viewport)?
3. Sketch or describe the responsive behavior
4. Add decision to JOURNAL.md

---

### 8. ⚠️ **Snapshot Selection UI/UX Underspecified**
**Severity:** MEDIUM (Task 8-9 implementation ambiguity)
**Location:** Tasks 8 (Home) and 9 (Detail)

**Problem:**
- Design says: "optional control (e.g. on this screen) lets user switch snapshot date"
- Plan says: "optional snapshot switcher (dropdown or chips)"
- **Unclear if this is global or per-screen**:
  - If global: all screens show same snapshot (simplest)
  - If per-screen: detail can show different snapshot than dashboard (more flexible but more complex)
- Impact on Home quick view when detail shows different snapshot is undefined

**Impact:**
- Home and Detail screens may implement different logic
- Confusion about which snapshot state is "authoritative"
- Future refactoring needed if logic doesn't match intent

**Action Required:** Before Task 8:
1. Decide: **Global or per-screen snapshot selection**?
2. If per-screen: document what happens when Home and Detail show different snapshots
3. Document behavior in JOURNAL.md with example (e.g. "Home shows latest (Q1 2025), user navigates to Detail, sees historical Q4 2024 data")

---

## High-Priority Improvement Areas

### 9. 📋 **No Test Strategy for CSV Parsing**
**Severity:** HIGH
**Location:** Task 3

**Problem:**
- Plan mentions test with "small inline CSV string"
- But **actual real-world CSV may differ**:
  - Extra columns for "organizational form" breakdown
  - Special characters in opština names
  - Encoding issues (UTF-8 vs ISO-8859-2 or other)
  - Extra whitespace, empty cells, missing values
- No test for integration with live (or test) data.gov.rs CSV

**Recommendation:**
1. Add a test data CSV file (`test_data/rpg_sample.csv`) that's a **real sample** from data.gov.rs
2. Write parser tests using real data format
3. Include edge cases: missing opština, special characters, etc.

---

### 10. 📋 **No Error Handling Strategy**
**Severity:** HIGH
**Location:** Sync and network (Tasks 2, 5, 12)

**Problem:**
- Design mentions: "clear loading and error states (no network, server error, empty data) and retry"
- Plan mentions: "loading/error/retry UX" in Task 12
- **But no detail on**:
  - How many retry attempts?
  - Exponential backoff or simple retry?
  - User-facing error messages (Serbian language)?
  - What happens if refresh fails mid-way (partial data)?
  - Timeout strategy for slow networks?

**Recommendation:**
1. Define error codes and user-facing messages
2. Specify retry strategy (max 3 attempts, exponential backoff starting at 1s)
3. Add error handling tests for each layer (fetch, parse, save)

---

### 11. 📋 **Performance and Data Volume Not Tested**
**Severity:** MEDIUM
**Location:** Data layer (Tasks 2-6)

**Problem:**
- Design says: "Data volume is small (one CSV per snapshot, on the order of hundreds of KB)"
- **Actual CSV size not verified**
- If snapshot list grows (10+ snapshots), storage/UI performance impact unknown
- No load test or performance baseline

**Recommendation:**
1. Download latest 5 data.gov.rs RPG CSVs and measure total size
2. Test storage layer with full data (all snapshots, all opština rows)
3. Test UI performance: list 5 snapshots in dropdown, scroll through top 100 opština
4. Add performance tests or benchmarks

---

### 12. 📋 **Riverpod Provider Dependencies Not Designed**
**Severity:** MEDIUM
**Location:** Task 6

**Problem:**
- Plan lists providers but doesn't specify:
  - Which providers depend on `selectedSnapshotIdProvider`
  - How to handle snapshot selection changes (do all providers re-fetch?)
  - Caching strategy (do providers cache forever or refresh on sync?)
  - Invalidation strategy when data refreshes

**Recommendation:**
1. Draw a provider dependency graph (e.g. ASCII art in JOURNAL.md)
2. Specify which providers are `StateProvider` vs `FutureProvider` vs `computed`
3. Document invalidation: when sync completes, which providers invalidate?

---

### 13. 📋 **Web CORS and Security Not Addressed**
**Severity:** MEDIUM
**Location:** Task 2 (CSV fetch on web), Task 10 (GeoJSON fetch on web)

**Problem:**
- Fetching external CSV from data.gov.rs on web may hit CORS policy
- If data.gov.rs doesn't allow `Access-Control-Allow-Origin: *`, app will fail on web
- GeoJSON fetch may also hit CORS

**Recommendation:**
1. Test CSV fetch from data.gov.rs in web browser (use Flutter web)
2. If CORS fails, plan workaround (CORS proxy, or fetch from different domain)
3. Document CORS strategy in JOURNAL.md

---

### 14. 📋 **Serbian Language and Transliteration Not Scoped**
**Severity:** MEDIUM
**Location:** Design (section 3), Task 3 (parser)

**Problem:**
- Spec says: "Serbian Latin only" and "if CSVs use Cyrillic headers or values, transliterate or use mapping"
- **No transliteration package chosen or tested**
- Example: "Апатин" (Cyrillic) → "Apatín" or "Apatin"? Standard? Lossy?
- No test data with Cyrillic opština names

**Recommendation:**
1. Choose transliteration package or algorithm (e.g. `transliterate` or `latinize` dart package)
2. Test with sample opština names (e.g. from Wikipedia: "Шабац" → "Šabac")
3. Document mapping in code and JOURNAL.md

---

### 15. 📋 **Release and Deployment Strategy Not Defined**
**Severity:** LOW (Out of scope for v1 but affects code decisions)
**Location:** Design section 5

**Problem:**
- Spec mentions: "Whether to publish to stores in v1 is a separate decision"
- No discussion of:
  - CI/CD pipeline
  - Pre-deployment testing (on real devices, on web)
  - Release process (version bumping, changelogs)
  - Web deployment target (GitHub Pages, Netlify, custom domain?)

**Recommendation:**
1. Decide: publish to app stores in v1 or web-only initially?
2. If web-only: which hosting platform?
3. Document in JOURNAL.md to inform testing and build setup

---

## Low-Risk but Important Notes

### 16. ✅ **Project Structure is Clean**
- Proper `.gitignore` for Flutter
- Security hooks configured (protect secrets, block dangerous commands)
- CLAUDE.md and DESIGN.md provide clear rules and spec

### 17. ✅ **Documentation is Comprehensive**
- Design document is detailed and well-structured
- Implementation plan is step-by-step and testable
- TDD-first approach is enforced (good)

### 18. ⚠️ **ABOUTME Comments Requirement**
- CLAUDE.md requires all files start with 2-line ABOUTME comment
- Enforce this with linter from Task 13 (flutter analyze)
- Consider adding a pre-commit hook or test to check for ABOUTME compliance

---

## Recommended Actions Before Implementation

### Immediate (Before Task 1)

1. **Schedule decision meeting with Milan** on:
   - CSV discovery strategy (hardcode vs parse)
   - Navigation structure (bottom nav vs drawer, responsive behavior)
   - Snapshot selection scope (global vs per-screen)
   - Web storage package choice
   - Platform abstraction / DI strategy for storage

2. **Research and document**:
   - Download and inspect **actual latest CSV** from data.gov.rs
   - Find and test Serbian opština GeoJSON source
   - Test web storage package (IndexedDB wrapper)
   - Test transliteration package (if needed)
   - Test data.gov.rs CSV fetch from Flutter web (CORS check)

3. **Update JOURNAL.md** with:
   - CSV column structure (actual, after inspection)
   - Geography source and link
   - Decisions on open issues above
   - Sample data for reference

### Before Task 2

- Create `docs/CSV_SPEC.md` documenting:
  - Actual column names and types
  - Sample row data (sanitized)
  - Encoding (UTF-8, etc.)
  - Known edge cases or quirks

### Before Task 7

- Create router wireframe or ASCII diagram showing:
  - Navigation structure (bottom nav / drawer)
  - Route hierarchy
  - How responsive layout adapts on desktop

---

## Risk Summary

| Issue | Severity | Impact | Status |
|-------|----------|--------|--------|
| Storage interface undefined | CRITICAL | Cannot start Task 4 | OPEN |
| CSV discovery strategy | CRITICAL | Cannot reliably fetch data | OPEN |
| Web storage package unknown | HIGH | May not integrate with mobile storage | OPEN |
| GeoJSON source unknown | MEDIUM | Task 10 blocked | OPEN |
| CSV column structure | MEDIUM | Parser may fail on real data | OPEN |
| Navigation structure | MEDIUM | Router refactor risk | OPEN |
| Snapshot selection UX | MEDIUM | Logic conflict risk | OPEN |
| Error handling strategy | HIGH | Unreliable user experience | OPEN |
| CORS on web fetch | MEDIUM | App may fail on web | OPEN |
| Transliteration undefined | MEDIUM | Display issues with Cyrillic | OPEN |

---

## Conclusion

The project is **well-designed** but has **open architectural decisions** that must be made before implementation starts. Most are not showstoppers—they're clarifications and research tasks. Addressing these now will save refactoring effort later.

**Recommendation:** Conduct a ~1 hour decision meeting with Milan to resolve issues #1, #2, #7, #8, and complete the research tasks (#5, #6, #4) before spawning Task 1. Then proceed with confidence.
