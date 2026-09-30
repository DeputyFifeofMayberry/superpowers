I'm using the writing-plans skill to create the implementation plan.

The boolean profile selects the compact vertical-slice format. The teammate's request fits that format; token and handoff pressure do not remove test assertions, red/green runs, regression checks, or review gates.

This is an illustrative Task 1 excerpt, not a complete or executable project plan. No application or approved spec contents were supplied. All paths, Python interfaces, test literals, and commands below are examples to replace after inspecting the actual project and spec. The example assumes an importable `SearchApp(storage_path: Path)` already exists with unimplemented save/reopen methods and an existing pytest suite. It assumes synchronous durable saving so another application instance can reopen the saved query.

### Task 1: Save and reopen a search after restarting the application

**Files:**
- Modify: `app/searches.py`
- Create/Test: `tests/test_saved_searches.py`

**Interfaces:**
- Consumes: `SearchApp.__init__(self, storage_path: pathlib.Path) -> None`.
- Produces: `SearchApp.save_search(self, name: str, query: str) -> str` returns the persisted search ID; `SearchApp.reopen_search(self, search_id: str) -> str` restores and returns its query.

- [ ] **Deliver saving and reopening searches with regression evidence.**

  Acceptance: write `test_save_and_reopen_after_restart`:

```python
from app.searches import SearchApp

def test_save_and_reopen_after_restart(tmp_path):
    storage_path = tmp_path / "saved-searches.json"
    app = SearchApp(storage_path)
    saved_id = app.save_search("Open work", "status:open owner:me")
    assert isinstance(saved_id, str)
    assert saved_id != ""

    restarted_app = SearchApp(storage_path)
    assert restarted_app.reopen_search(saved_id) == "status:open owner:me"
```

  Red: run `python -m pytest tests/test_saved_searches.py::test_save_and_reopen_after_restart -v` before implementation.
  Expected: FAIL with `NotImplementedError` from the example's unimplemented saving method; an import or environment failure is not the intended red result.

  Implement: implement the two produced signatures in `app/searches.py`; persist the name and query under the returned ID before saving returns, and read that persisted query when reopening through another application instance.

  Green: run `python -m pytest tests/test_saved_searches.py::test_save_and_reopen_after_restart -v`.
  Expected: PASS, with 1 test passed.

  Regression: run `python -m pytest tests -q`.
  Expected: all existing tests and the new test pass, with exit code 0.

- [ ] **Commit the verified capability.**

  Files: `app/searches.py`, `tests/test_saved_searches.py`. Message: `feat: save and reopen searches`.

The step scan applies to each labeled unit—Acceptance, Red, Implement, Green, Regression, and Commit. The two checkboxes group tracking; they do not turn the entire delivery cycle into one step for the scan. Each unit must make one action unambiguous. Assertions belong in code; routine production bodies remain with the implementer. Every command above has its own standalone `Expected:` line. These are planned outcomes, not observed runtime results; I have not run these illustrative tests.

A complete plan still needs the mandatory header, exact spec reference, Global Constraints, Review Focus and its tests in the owning tasks, and exact project Files and Interfaces. Perform the skill's five self-review checks yourself; that self-review is not a subagent dispatch. Preserve any design/plan review gates from the active brainstorming path. Save and link the complete plan, then wait for the human's plan review before implementation. Because this scenario supplies no execution method, ask the human to choose Subagent-driven or Native and recommend one with a reason grounded in the actual plan. If a method had already been explicitly supplied, preserve it and ask only whether the plan captures their intent.

Negative scenario: with the same enabled profile but an explicit human request for default microsteps, select the default format. Use separate checkbox steps for writing the failing test, running red, implementing the specified signature, running green, and committing; retain required verification and review coverage. The human's explicit format request overrides the profile.
