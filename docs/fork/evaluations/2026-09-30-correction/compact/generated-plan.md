# Saved Search Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Save a named search to SQLite and reopen its exact query after process restart.

**Architecture:** A new module `app/saved_search.py` exposes two functions. Each call opens its own `sqlite3` connection, creates the table if needed, and closes the connection before returning, so a later call behaves like a fresh process. Validation reuses the existing `app.search.normalize_query`. The query is stored verbatim; normalization is used only to decide whether a query is empty.

**Tech Stack:** Python 3 standard library (`sqlite3`, `unittest`, `tempfile`).

**Spec:** `docs/superpowers/specs/approved.md`

## Global Constraints

- Interface: `save_search(database_path: str, name: str, query: str) -> int` and `load_search(database_path: str, search_id: int) -> tuple[str, str] | None`, both in `app/saved_search.py`.
- No external dependencies.
- Tests use temporary databases.
- No UI, network API or sharing.
- Regression command: `python -m unittest discover -s tests -v`.
- Schema (a plan decision, pinned so tests can check persistence): `CREATE TABLE IF NOT EXISTS saved_searches (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, query TEXT NOT NULL)`.

## Review Focus

1. **Windows file locking.** A connection left open blocks `TemporaryDirectory` cleanup with `PermissionError`. Every call must close its connection. This is pinned by every Task 1 and Task 2 test through `addCleanup(self._tmp.cleanup)`.
2. **`load_search` on a fresh database, before any save.** Expected: returns `None`, not `sqlite3.OperationalError: no such table`. Pinned by Task 1 `test_fresh_database_missing_id_returns_none`.
3. **Quotes, SQL metacharacters and non-ASCII text in the name or query.** Expected: they round-trip exactly, which requires parameterized SQL. Pinned by Task 1 `test_special_characters_and_whitespace_round_trip`.
4. **Whitespace around a non-empty query.** Expected: the stored query stays exactly as given, not trimmed ("reopen its exact query"). Pinned by the same Task 1 test.
5. **Whitespace-only query (`"   "`, `"\t\n"`).** Its normalized form is empty, so it must raise `ValueError` and leave no row. Pinned by Task 2 `test_empty_normalized_query_rejected_without_row`.

---

### Task 1: Save a named search and reopen it by ID

**Files:**
- Create: `app/saved_search.py`
- Test: `tests/test_saved_search.py` (create)

**Interfaces:**
- Consumes: nothing from earlier tasks.
- Produces: `save_search(database_path: str, name: str, query: str) -> int` and `load_search(database_path: str, search_id: int) -> tuple[str, str] | None` in `app/saved_search.py`. Both use the `saved_searches` table from Global Constraints.

- [ ] **Deliver save/reopen with regression evidence.**
  Acceptance: create `tests/test_saved_search.py`:
```python
import os
import sqlite3
import tempfile
import unittest

from app.saved_search import load_search, save_search


class SavedSearchTest(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self._tmp.cleanup)  # PermissionError on Windows if a connection is left open
        self.db = os.path.join(self._tmp.name, "searches.db")

    def test_save_and_reopen_exact_values(self):
        search_id = save_search(self.db, "Release status", "release status")
        self.assertIsInstance(search_id, int)
        self.assertEqual(load_search(self.db, search_id), ("Release status", "release status"))

    def test_missing_id_returns_none(self):
        search_id = save_search(self.db, "Release status", "release status")
        self.assertIsNone(load_search(self.db, search_id + 1))

    def test_fresh_database_missing_id_returns_none(self):
        self.assertIsNone(load_search(self.db, 1))

    def test_duplicate_names_get_distinct_ids(self):
        first = save_search(self.db, "Release status", "release status")
        second = save_search(self.db, "Release status", "release notes")
        self.assertNotEqual(first, second)
        self.assertEqual(load_search(self.db, first), ("Release status", "release status"))
        self.assertEqual(load_search(self.db, second), ("Release status", "release notes"))

    def test_special_characters_and_whitespace_round_trip(self):
        name = "Ünïcode 'quoted'; DROP TABLE saved_searches;--"
        query = '  O\'Brien "release" %_  '
        search_id = save_search(self.db, name, query)
        self.assertEqual(load_search(self.db, search_id), (name, query))
```
  Red: run `python -m unittest discover -s tests -p "test_saved_search.py" -v` before creating `app/saved_search.py`.
  Expected: `ImportError: Failed to import test module: test_saved_search` caused by `ModuleNotFoundError: No module named 'app.saved_search'`, ending in `FAILED (errors=1)`.
  Implement: in `app/saved_search.py`, write `save_search(database_path: str, name: str, query: str) -> int` and `load_search(database_path: str, search_id: int) -> tuple[str, str] | None`. Each function opens `sqlite3.connect(database_path)` and wraps it in `contextlib.closing`, because `with conn:` only commits and does not close. Each runs the Global Constraints `CREATE TABLE IF NOT EXISTS` first and uses `?` placeholders only. `save_search` commits and returns `cursor.lastrowid`. `load_search` returns `(name, query)` or `None`. Do not trim the stored query.
  Green: run `python -m unittest discover -s tests -p "test_saved_search.py" -v`.
  Expected: `Ran 5 tests`, `OK`.
  Regression: run `python -m unittest discover -s tests -v`.
  Expected: `Ran 6 tests`, `OK` (includes existing `test_trim`).

- [ ] **Commit the verified capability.**
  Files: `app/saved_search.py`, `tests/test_saved_search.py`. Message: `feat: save and reopen named searches in SQLite`.

### Task 2: Reject empty queries without persisting a row

**Files:**
- Modify: `app/saved_search.py` (`save_search`)
- Test: `tests/test_saved_search.py` (add to `SavedSearchTest`)

**Interfaces:**
- Consumes: `save_search` from Task 1; `normalize_query(query: str) -> str` from `app/search.py:1-2`; the `saved_searches` table.
- Produces: `save_search` raises `ValueError` when `normalize_query(query) == ""`. Its signature is unchanged.

- [ ] **Deliver empty-query rejection with regression evidence.**
  Acceptance: add to `SavedSearchTest`:
```python
    def test_empty_normalized_query_rejected_without_row(self):
        save_search(self.db, "Release status", "release status")
        for query in ("", "   ", "\t\n"):
            with self.subTest(query=query):
                with self.assertRaises(ValueError):
                    save_search(self.db, "Empty", query)
        conn = sqlite3.connect(self.db)
        try:
            count = conn.execute("SELECT COUNT(*) FROM saved_searches").fetchone()[0]
        finally:
            conn.close()
        self.assertEqual(count, 1)
```
  Red: run `python -m unittest discover -s tests -p "test_saved_search.py" -v`.
  Expected: `test_empty_normalized_query_rejected_without_row` fails with `AssertionError: ValueError not raised` (three subtests), ending in `FAILED (failures=3)`. The other 5 tests pass.
  Implement: at the top of `save_search`, before connecting, `if not normalize_query(query): raise ValueError("query must not be empty")`. Import `normalize_query` from `app.search`. Keep storing the original `query`.
  Green: run `python -m unittest discover -s tests -p "test_saved_search.py" -v`.
  Expected: `Ran 6 tests`, `OK`.
  Regression: run `python -m unittest discover -s tests -v`.
  Expected: `Ran 7 tests`, `OK`.

- [ ] **Commit the verified capability.**
  Files: `app/saved_search.py`, `tests/test_saved_search.py`. Message: `feat: reject empty saved-search queries`.
