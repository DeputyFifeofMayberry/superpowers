# Saved Search Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Save a named search to SQLite and reopen its exact query after process restart.

**Architecture:** A new module `app/saved_search.py` exposes `save_search` and `load_search`. Each call opens its own `sqlite3` connection, ensures the `saved_searches` table exists, and closes the connection before returning. Validation reuses `normalize_query` from `app/search.py`; the query is stored exactly as the caller passed it.

**Tech Stack:** Python 3 standard library only (`sqlite3`, `contextlib`), `unittest`.

**Spec:** `docs/superpowers/specs/approved.md`

**Format note:** `.superpowers/fork-features.json` sets `"vertical-slice-plans": true`, but the human partner explicitly requested the default separate TDD microstep format, which takes priority. Assertions are written as code, not prose, and steps are not collapsed.

## Global Constraints

- Interface, verbatim: `save_search(database_path: str, name: str, query: str) -> int`; `load_search(database_path: str, search_id: int) -> tuple[str, str] | None`.
- Both functions live in `app/saved_search.py`.
- No external dependencies.
- Tests use temporary databases (`tempfile.TemporaryDirectory`), never a fixed path.
- Reject an empty normalized query with `ValueError` and persist no row.
- Missing ID returns `None`.
- Duplicate names are permitted and get distinct IDs.
- No UI, network API or sharing.
- Regression command: `python -m unittest discover -s tests -v`, run from the project root.
- The workspace is not yet a git repository; the executor's workspace setup (superpowers:using-git-worktrees) must provide one before the first commit step.

## Review Focus

1. **Whitespace-only query (`"   "`)** — normalizes to empty, so it must raise `ValueError` and leave the row count unchanged, even when earlier rows exist. Test: Task 2 `test_whitespace_only_query_raises_and_persists_no_row`.
2. **Loading from a database file that has never been saved to** — a reasonable user expects `None`, not `sqlite3.OperationalError: no such table`. Test: Task 1 `test_load_before_any_save_returns_none`.
3. **Connections left open on Windows** — an unclosed connection locks the file and makes `TemporaryDirectory` cleanup raise `PermissionError`; every call must close its connection (`contextlib.closing`, not bare `with sqlite3.connect(...)`, which only commits). Test: every Task 1 test cleans up its temp dir; `test_round_trip_release_status` fails on Windows if a connection leaks.
4. **Query with surrounding whitespace, quotes or non-ASCII** — "exact query" means stored as given, not normalized, and parameterized SQL so `'` and `;` are data. Test: Task 1 `test_query_and_name_stored_exactly_as_given`.
5. **Real process restart** — a value cached in-process would pass a same-process test but lose data on restart. Test: Task 1 `test_survives_process_restart` loads via a fresh `python` subprocess.

---

### Task 1: Persist and reload saved searches

**Files:**
- Create: `app/saved_search.py`
- Test: `tests/test_saved_search.py`

**Interfaces:**
- Consumes: nothing from earlier tasks (`app.search.normalize_query` is used in Task 2).
- Produces:
  - `save_search(database_path: str, name: str, query: str) -> int` — returns the new row's ID.
  - `load_search(database_path: str, search_id: int) -> tuple[str, str] | None` — returns `(name, query)` or `None`.
  - Private `_connect(database_path: str) -> sqlite3.Connection` — opens the connection and runs `CREATE TABLE IF NOT EXISTS saved_searches (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, query TEXT NOT NULL)`.
  - Table name `saved_searches` (Task 2's test counts its rows).

- [ ] **Step 1: Write the failing tests**

Create `tests/test_saved_search.py`:

```python
import os
import sqlite3
import subprocess
import sys
import tempfile
import unittest

from app.saved_search import load_search, save_search

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


class SavedSearchTest(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self._tmp.cleanup)
        self.db = os.path.join(self._tmp.name, "searches.db")

    def test_round_trip_release_status(self):
        search_id = save_search(self.db, "Release status", "release status")
        self.assertIsInstance(search_id, int)
        self.assertEqual(load_search(self.db, search_id), ("Release status", "release status"))

    def test_survives_process_restart(self):
        search_id = save_search(self.db, "Release status", "release status")
        script = (
            "import sys; from app.saved_search import load_search; "
            "print(repr(load_search(sys.argv[1], int(sys.argv[2]))))"
        )
        result = subprocess.run(
            [sys.executable, "-c", script, self.db, str(search_id)],
            cwd=PROJECT_ROOT, capture_output=True, text=True, check=True,
        )
        self.assertEqual(result.stdout.strip(), repr(("Release status", "release status")))

    def test_duplicate_names_get_distinct_ids(self):
        first = save_search(self.db, "Release status", "release status")
        second = save_search(self.db, "Release status", "release blockers")
        self.assertNotEqual(first, second)
        self.assertEqual(load_search(self.db, first), ("Release status", "release status"))
        self.assertEqual(load_search(self.db, second), ("Release status", "release blockers"))

    def test_query_and_name_stored_exactly_as_given(self):
        name = "O'Brien; DROP TABLE saved_searches; --"
        query = "  café \"status\" 'release'  "
        search_id = save_search(self.db, name, query)
        self.assertEqual(load_search(self.db, search_id), (name, query))

    def test_missing_id_returns_none(self):
        search_id = save_search(self.db, "Release status", "release status")
        self.assertIsNone(load_search(self.db, search_id + 1))

    def test_load_before_any_save_returns_none(self):
        self.assertIsNone(load_search(self.db, 1))


if __name__ == "__main__":
    unittest.main()
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `python -m unittest discover -s tests -p "test_saved_search.py" -v`
Expected: `ModuleNotFoundError: No module named 'app.saved_search'` and `FAILED (errors=1)`

- [ ] **Step 3: Implement `_connect`, `save_search` and `load_search` in `app/saved_search.py`**

Signatures and schema as in the Interfaces block. Wrap every connection in `contextlib.closing(...)` and commit inside `save_search`; use `?` placeholders for all values; return `cursor.lastrowid` from the insert; `load_search` selects `name, query` by `id` and returns the row as a tuple or `None`. Store `query` unmodified. No validation yet (Task 2).

- [ ] **Step 4: Run tests to verify they pass**

Run: `python -m unittest discover -s tests -p "test_saved_search.py" -v`
Expected: 6 tests, each `... ok`, ending `OK`, with no `PermissionError` or `ResourceWarning` from temp-dir cleanup.

- [ ] **Step 5: Run the full regression suite**

Run: `python -m unittest discover -s tests -v`
Expected: `Ran 7 tests` and `OK` (6 new + existing `test_trim`).

- [ ] **Step 6: Commit**

```bash
git add app/saved_search.py tests/test_saved_search.py
git commit -m "feat: persist and reload named saved searches in SQLite"
```

---

### Task 2: Reject empty normalized queries without persisting a row

**Files:**
- Modify: `app/saved_search.py` (`save_search`)
- Test: `tests/test_saved_search.py`

**Interfaces:**
- Consumes: `save_search`, `load_search`, table `saved_searches` from Task 1; `normalize_query(query: str) -> str` from `app/search.py`.
- Produces: `save_search` raises `ValueError` when `normalize_query(query) == ""`; signature unchanged.

- [ ] **Step 1: Write the failing tests**

Add to `SavedSearchTest` in `tests/test_saved_search.py`:

```python
    def _row_count(self):
        with sqlite3.connect(self.db) as conn:
            count = conn.execute("SELECT COUNT(*) FROM saved_searches").fetchone()[0]
        conn.close()
        return count

    def test_empty_query_raises_and_persists_no_row(self):
        existing = save_search(self.db, "Release status", "release status")
        with self.assertRaises(ValueError):
            save_search(self.db, "Empty", "")
        self.assertEqual(self._row_count(), 1)
        self.assertIsNone(load_search(self.db, existing + 1))

    def test_whitespace_only_query_raises_and_persists_no_row(self):
        existing = save_search(self.db, "Release status", "release status")
        with self.assertRaises(ValueError):
            save_search(self.db, "Blank", "   \t\n")
        self.assertEqual(self._row_count(), 1)
        self.assertIsNone(load_search(self.db, existing + 1))
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `python -m unittest discover -s tests -p "test_saved_search.py" -v`
Expected: `AssertionError: ValueError not raised` for both new tests, ending `FAILED (failures=2)`; the 6 Task 1 tests still `ok`.

- [ ] **Step 3: Add validation to `save_search` in `app/saved_search.py`**

Import `normalize_query` from `app.search`; if `normalize_query(query) == ""`, raise `ValueError` before opening a connection. Still store the original `query`, not the normalized value.

- [ ] **Step 4: Run tests to verify they pass**

Run: `python -m unittest discover -s tests -p "test_saved_search.py" -v`
Expected: 8 tests, each `... ok`, ending `OK`.

- [ ] **Step 5: Run the full regression suite**

Run: `python -m unittest discover -s tests -v`
Expected: `Ran 9 tests` and `OK`.

- [ ] **Step 6: Commit**

```bash
git add app/saved_search.py tests/test_saved_search.py
git commit -m "feat: reject empty normalized saved-search queries"
```
