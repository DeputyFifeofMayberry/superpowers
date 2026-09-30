# Approved saved-search design

Status: design-approved by the human partner for this evaluation fixture.
Goal: save a named search to SQLite and reopen its exact query after process restart.
Existing code: app/search.py normalizes query text; tests/test_search.py uses unittest.
New interface: save_search(database_path: str, name: str, query: str) -> int;
load_search(database_path: str, search_id: int) -> tuple[str, str] | None.
Place these in app/saved_search.py. No external dependencies. Tests use temporary databases.
Acceptance: save name 'Release status', query 'release status', reopen database, verify both exact values.
Reject an empty normalized query with ValueError and persist no row. Missing ID returns None.
Duplicate names are permitted and get distinct IDs. No UI, network API or sharing in this fixture.
Run python -m unittest discover -s tests -v for regressions.
