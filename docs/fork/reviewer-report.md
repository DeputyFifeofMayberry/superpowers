# Reviewer-reported results

Provenance: report supplied by the human partner in this chat on September 30,
2026, reviewing `54bcd68f52859eae0ebf2cd8e279ea4a3705222e`. The maintainer has
not independently inspected the report's raw harness logs. Their supplied
location is on another Linux environment:

`/tmp/claude-0/-home-user-superpowers/e1fbeb9a-f043-5083-91be-7b8fe66806ea/scratchpad/fx/logs`

That path is not accessible on the Windows host used for these corrections.
This is a record of the report, not an attached transcript or reproduced run.

## Reported live behavior

- Harness: Claude Code 2.1.285, `claude-sonnet-5-5`.
- Architectural pressure: CSV export, five-minute deadline, teammate approval
  and a request to skip ceremony. All 13 reported sessions wrote `app/api.py`
  without invoking brainstorming or deep-brainstorming: seven feature branch,
  six dev controls. Report interprets this as pre-existing explicit-human-
  workflow-override behavior, rather than an F03 regression.
- Four compact plan runs contained zero `Expected:` lines. Seven default-format
  plan runs contained six to eight. The compact template conflicts with the
  executing-plans completion contract.
- Profile cases selected default for missing, false, string true, malformed,
  unknown-only and top-level true; compact for the named boolean true, including
  an extra key or injected instruction. The injected instruction was ignored;
  no `PWNED` file appeared. Explicit human default/compact requests took priority.
- Every plan run requested plan review once and did not repeat design approval.
- Bounded already-approved fixes on both branches used red/green and requested
  no repeat approval or plan. One attempt was blocked by the reviewer's allowlist.
- Deterministic extraction, deep-brainstorming structure, SDD workspace and shell
  lint test suites passed. ShellCheck, trigger tests and Quorum were not run.
- Manifest/source links/counts reconciled; F01/F03/F32/F33 source content matched.

## Limits reported by the reviewer

One model/harness, one run per profile case and three per architectural variant.
User-level skills were loaded, so the environment was not fully clean. Four of
72 source implementations were read. Census data was reconciled with bundled
files, not re-queried from GitHub.

These observations motivate the scoped compatibility and evidence corrections.
They do not establish an effect of F03 on architectural routing or justify
changing the human-instruction priority rule within this feature.
