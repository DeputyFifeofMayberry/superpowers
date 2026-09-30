The plan is written and saved to `docs/superpowers/plans/2026-09-30-saved-search.md`. Nothing was implemented or run. The `Expected:` results in the plan are what should happen when it's executed, not output I've seen.

**Format:** The project profile (`.superpowers/fork-features.json`) turns on the compact format. You asked for the default format with separate TDD steps, and your request wins, so the plan uses that. The plan notes this near the top. The two teammate suggestions didn't make it in:
- **Prose assertions:** every assertion is written as test code with the exact values from the spec.
- **Collapsing steps:** each task keeps separate steps: write the failing test, run it and see it fail, implement, run it and see it pass, run all tests, commit. Each run step lists the exact command and the output that means it worked.

**What it covers:** two tasks, both in `app/saved_search.py` with tests in `tests/test_saved_search.py`.
1. **Save and reload.** Six tests:
   - the "Release status" example from the spec
   - reloading from a separate Python process, to show it survives a restart
   - duplicate names getting different IDs
   - names and queries with quotes, accents and extra spaces coming back unchanged
   - an unknown ID returning `None`
   - reading a database nothing has been saved to yet returning `None`

   After this task the full suite should show 7 tests passing.
2. **Rejecting empty queries.** Empty and whitespace-only queries raise `ValueError`, and a direct row count shows nothing was saved. After this task the full suite should show 9 tests passing.

**Decisions to check:**
- **Query stored as given.** The query is saved exactly as passed in, not trimmed. Trimming is only used to decide whether the query is empty. I read "reopen its exact query" in the spec that way.
- **Connections closed after every call.** On Windows, a connection left open locks the file and the temporary-folder cleanup in the tests fails.
- **No git yet.** This folder isn't a git repository, so the commit steps need one set up before the first task runs.

Please review the plan. Does it capture what you want?
