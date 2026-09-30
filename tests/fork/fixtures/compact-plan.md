# Fixture: Saved Searches Implementation Plan

This parser fixture describes illustrative paths and expected checks. It is
not an executable project plan and does not claim that the commands ran.

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans task-by-task.

**Goal:** Save a search and share it with a team.
**Architecture:** Persist and expose each capability through its API and UI.
**Tech Stack:** Illustrative Python application with pytest.
**Spec:** fixture-only approved requirements.

## Global Constraints

- Use existing member identity; never accept owner identity from the request.

## Review Focus

- Sharing without team membership must fail with permission denied.

### Task 1: Save a search

**Files:**
- Modify: `app/search.py`
- Test: `tests/test_saved_search.py`

**Interfaces:**
- Consumes: `current_member() -> Member`.
- Produces: `save_search(owner_id: str, query: str) -> SavedSearch`.

- [ ] **Deliver saving with regression evidence.**
  Acceptance: `test_saved_search_survives_reload` asserts restored query equals `release status`.
  Red: run `pytest tests/test_saved_search.py -q` before implementation; expect missing saved-search behavior.
  Implement: `save_search(owner_id: str, query: str) -> SavedSearch` in `app/search.py` and its existing UI caller.
  Green: run `pytest tests/test_saved_search.py -q`; expect all tests pass.
  Regression: run `pytest tests/test_search.py -q`; expect all tests pass.

- [ ] **Commit the verified capability.**
  Files: `app/search.py`, `tests/test_saved_search.py`. Message: `feat: save searches`.

```markdown
### Task 99: This code-fenced heading is not a real task
```

### Task 2: Share a search

**Files:**
- Modify: `app/team_search.py`
- Test: `tests/test_shared_search.py`

**Interfaces:**
- Consumes: Task 1's `save_search(owner_id: str, query: str) -> SavedSearch`.
- Produces: `share_search(search_id: str, team_id: str) -> SharedSearch`.

- [ ] **Deliver sharing with regression evidence.**
  Acceptance: `test_shared_search_visible_to_team` asserts the seeded search is present after reload;
  `test_nonmember_cannot_share` asserts permission denied and no persisted share.
  Red: run `pytest tests/test_shared_search.py -q` before implementation; expect missing sharing behavior.
  Implement: `share_search(search_id: str, team_id: str) -> SharedSearch` in `app/team_search.py`.
  Green: run `pytest tests/test_shared_search.py -q`; expect all tests pass.
  Regression: run `pytest tests/test_saved_search.py -q`; expect all tests pass.

- [ ] **Commit the verified capability.**
  Files: `app/team_search.py`, `tests/test_shared_search.py`. Message: `feat: share saved searches`.
