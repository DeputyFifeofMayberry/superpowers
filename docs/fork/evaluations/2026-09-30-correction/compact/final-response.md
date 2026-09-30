I've written the implementation plan to `docs/superpowers/plans/2026-09-30-saved-search.md`. I haven't implemented anything or run any of the plan's commands. The "Expected" lines in the plan are predicted results, not observed ones.

**Format.** The project profile `.superpowers/fork-features.json` has `"vertical-slice-plans": true`, so the plan uses the compact format. Each capability is one task with a single red/green checkbox and a commit checkbox.

**The two teammate requests:**
- **Collapsing repetitive steps:** done. The compact format already merges the usual separate test/run/implement/run steps into one checkbox per capability.
- **Writing assertions as prose:** not done. The compact format requires test assertions as code blocks, and prose would lose exact values like `("Release status", "release status")`. Each Red, Green and Regression command still has its own `Expected:` line.

**What the plan covers:**
- **Task 1:** save a named search and reopen it by ID. Tests cover the spec's example values, a missing ID returning `None`, and duplicate names getting distinct IDs.
- **Task 2:** reject a query that is empty after normalization with `ValueError`, and check that no row was saved.
- **Review Focus:** five risks the spec doesn't mention, each with a test in the task that owns the code:
  - leaving a SQLite connection open blocks temp-folder cleanup on Windows;
  - loading from a new database before anything is saved should return `None`;
  - quotes, SQL characters and non-ASCII text should round-trip exactly;
  - spaces around a query should be kept;
  - a query of only spaces should be rejected.

**Please check these decisions I made where the spec was silent:**
1. The query is saved exactly as typed. Normalization is only used to detect an empty query. I read "reopen its exact query" to mean this.
2. The table is named `saved_searches`, with columns `id`, `name` and `query`. I fixed the name so the Task 2 test can count rows directly.
3. An empty name is allowed, because the spec only rejects empty queries.

**Before execution:** this folder isn't a git repository yet, so the commit steps need a repo or worktree set up first.

Plan complete and saved to `docs/superpowers/plans/2026-09-30-saved-search.md`. Please review the plan. Which execution approach would you prefer?

- **Subagent-driven:** a fresh subagent implements each task and a fresh reviewer checks it before the next one starts, then the whole branch gets a final review. This is the most thorough option, but it costs a fresh context per task and per review.
- **Native:** I implement every task myself in this session, then one fresh reviewer on the most capable model checks the whole branch. This is cheapest and fastest, but nothing is independently reviewed until the end.

I recommend Native: there are only two small tasks, Task 2 changes one function from Task 1, and a mistake would be cheap to fix. Does the plan capture what you want, and which approach should we use?
