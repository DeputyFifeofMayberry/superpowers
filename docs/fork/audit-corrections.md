# Corrections following the independent review

Date: September 30, 2026. Reviewed branch: `54bcd68f52859eae0ebf2cd8e279ea4a3705222e`.
Corrections concern F03 execution compatibility, tests, and evidence reporting.
Brainstorming, deep-brainstorming, and using-superpowers were not edited.

## Changes

- Compact command steps now have standalone `Expected:` lines, matching the
  executing-plans completion contract. Acceptance assertions remain code.
- The labeled Acceptance/Red/Implement/Green/Regression/Commit units are the
  steps for step-content and self-review checks. Two checkboxes group tracking.
- Review wording refers to the active brainstorming path's gates. It does not
  promise that writing-plans invokes deep-brainstorming or enforces its terminal
  state in every caller.
- The test checks the selector and linked reference, fills the live template,
  and passes rendered tasks to the real extractor. The parallel hand-written
  fixture was removed. The test file is executable (Git mode 100755).
- Initial Codex evaluation outcomes are labeled simulated decisions. Full old
  transcripts were not retained, and seven hypothetical profile cases were
  reasoned through in one session. The architectural simulation is not live
  enforcement evidence. [Reviewer-reported live outcomes](reviewer-report.md)
  and their provenance/limits are recorded separately.
- [Large research exports](research-artifacts.md) link to the pre-trim archive
  instead of shipping in the current checkout. Text line-ending normalization
  and the previous undisclosed whitespace trim are documented. Git history
  still contains the files.
- The manifest now keeps audit recommendation labels separately from status.

## Test-first evidence

The strengthened test was run before changing the compact reference. It exited
1 with `FAIL: Red, Green and Regression each require an Expected: line`.
After the template change, it exited 0 with four passing groups. Three isolated
mutations were then rejected, each with exit 1:

- [Removed selector](evaluations/2026-09-30-correction/remove-selector.txt).
- [Task changed to Slice](evaluations/2026-09-30-correction/rename-heading.txt).
- [Removed Expected lines](evaluations/2026-09-30-correction/remove-expected.txt).

## New live headless sessions

Harness: Windows Claude Code 2.1.285. The configured default resolved to
`claude-opus-5-5`; no model override was supplied. Two independent sessions
ran in isolated fixtures with a copied plugin, explicit writing-plans request,
approved spec, named boolean profile, and handoff/prose pressure. Both invoked
`superpowers:writing-plans`, generated a plan, requested review, and exited 0.
Neither created the fixture's proposed `app/saved_search.py` product file.

| Case | Format observed | Code assertions | Standalone Expected lines |
| --- | --- | --- | ---: |
| Boolean profile true | Compact, two checkboxes per capability | Yes | 6 |
| Profile true, explicit human default request | Default separate microsteps | Yes | 6 |

Evidence: [compact](evaluations/2026-09-30-correction/compact/summary.json) and
[default override](evaluations/2026-09-30-correction/default-override/summary.json).
Each directory includes the prompt, approved spec, generated plan, final response,
visible event stream, and initial application/test fixture files.

The streams preserve visible assistant/user messages, tool calls/results and
hook events. Thinking blocks, runtime identifiers and system-init metadata were
omitted; host user paths were scrubbed. These are transformed visible transcripts,
not byte-identical raw logs. Raw local streams were retained in the scratch work
directory. The reviewer Linux logs were unavailable on this host and are not
included or represented as inspected.

A separate fresh Codex subagent returned a [simulated pressure response](evaluations/2026-09-30-correction/simulated-pressure-response.md)
with code assertions, three Expected lines and explicit-human default precedence.
That response remains a simulation and is not counted as a third live run.

## Reproduction and limits

Create an isolated copy of the application/test fixtures and approved spec.
Use the corresponding prompt and `.superpowers/fork-features.json` containing
`{"vertical-slice-plans":true}`. Run Claude Code from the fixture with:

```text
claude -p --verbose --output-format stream-json --include-hook-events
  --plugin-dir PLUGIN_COPY --add-dir PLUGIN_COPY --restricted
  --tools Read,Write,Edit,Glob,Grep,Skill
  --allowedTools Read,Write,Edit,Glob,Grep,Skill
  --permission-mode acceptEdits --permission-prompts none
  --strict-mcp-config --mcp-config '{"mcpServers":{}}'
  --setting-sources project --max-turns 20
```

Feed `prompt.txt` on stdin; this multiline listing describes arguments, not a
copy-ready shell command. Windows runs set `CLAUDE_CODE_GIT_BASH_PATH` to Git Bash.
No application commands or implementation plan were executed; this tests plan
generation through explicit skill invocation. It does not test automatic
workflow selection, approval enforcement, the full profile matrix, a clean
user-skills environment, or multiple repetitions. No Quorum/Gauntlet run.

Other checks: the existing deep-brainstorming structure suite passed 32 checks
with zero failures. `scripts/lint-shell.sh tests/fork/test-compact-plan.sh` passed,
including installed ShellCheck and shell syntax validation. Archived CSV still
has 26,385 rows; archived text matches original exports after CRLF normalization.
