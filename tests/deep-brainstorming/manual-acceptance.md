# deep-brainstorming — Manual Acceptance

Behavior scenarios for `skills/deep-brainstorming` and the architectural
handoff in `skills/brainstorming`. The automated pieces are
`test-skill-structure.sh` (structure) and `test-trigger.sh` (routing rates).
Everything else is judged from transcripts.

## How to run

Use a scratch copy of the fixture project that `test-trigger.sh` builds
(`cli.sh`, `src/report.js`, `src/settings.js`, `src/sales.json`, one commit),
and load this checkout as the plugin:

```bash
claude --plugin-dir /path/to/superpowers
```

Headless multi-turn runs work too: `claude -p "<msg>" --plugin-dir …
--output-format stream-json --verbose`, then `claude -p "<reply>" --resume
<session_id> …` for each later turn. When you drive nested sessions from
inside a Claude Code session, drop the parent-session variables that
`test-trigger.sh` lists in `UNSET_PARENT`. Otherwise the child inherits the
parent's session id.

## Scenarios

| # | Prompt / action | Pass criteria |
|---|---|---|
| A | "Let's add CSV export to the reports page" | deep-brainstorming engages. Code is read before the first question. The first question is exactly one, with options and a recommendation. A record is created in `docs/superpowers/specs/`. No other files change. |
| B | An idea where a key fact is answerable from the repo | The agent states the fact with `path:line` evidence instead of asking. |
| C | An idea that depends on an external fact ("post each month's sales report to our team's Slack channel automatically") | The agent checks official docs. Evidence entries carry the URL and access date, and the question cites them. |
| D | Reply "that sounds good" to a question or scope summary | writing-plans is not invoked. Design approval is requested separately. |
| E | A preference question (naming, UX, delivery choice) | Labeled "your call", with a recommendation. Not decided for your human partner. |
| F | After each topic | A checkpoint line with open and high-impact counts appears. Low-impact items move to Assumptions. |
| G | New session: `/superpowers:deep-brainstorming <record path>`, or naming the topic on an earlier-dated record | The agent summarizes status and resumes at the highest-impact open question. It does not re-ask decisions or create a second record. |
| H | Approve the design, approve the plan, then send "Yes." | writing-plans runs with the record as Spec, and the plan is saved. The agent asks for plan review and stops at `plan-approved`. A later "Yes." does not start execution. |
| I | "Add a --verbose flag to cli.sh" | Bounded path in brainstorming. deep-brainstorming is not invoked. |
| J | Plan mode: "Plan how we'd add a per-item sales breakdown page to this app." | deep-brainstorming engages before any plan is written. |
| K | `git status` / `git log` after a full run | Only the record and plan files are new, with no new commits. |
| L | A request that already states outcome, scope, constraints and acceptance criteria | deep-brainstorming engages (no jump to TDD). The design is proposed within 3 or fewer questions. |
| M | Mid-discussion: "Keep it light and move to the design." | The next message presents the design, with remaining questions listed as Assumptions. |
| N | Spike: "Can we pull the monthly totals out of the report HTML with a one-line shell command? Quick and dirty is fine…" | No deep-brainstorming and no file writes, same as before this change. |
| O | Start a new idea while an unfinished record exists, then drop it | The unfinished record is listed in one line with a resume offer. The dropped idea is set to `abandoned`, and the agent asks about deletion. |

## Results — 2026-09-30

Environment: Claude Code 2.1.285, headless (`claude -p` with `--resume` for
later turns), fixture project above, plugin loaded with `--plugin-dir`.
Baseline = `origin/dev` at `b1f8774`. Branch = `feature/deep-brainstorming`.

### Routing (`test-trigger.sh --reps 3`, clean nested sessions)

| Case | Prompt | Baseline (`dev`) | Branch |
|---|---|---|---|
| positive | "Let's make a react todo list" | brainstorming 3/3, deep 0/3 | deep-brainstorming 3/3 |
| borderline | "add dark mode to the settings page" | 0/3 (classified bounded) | 3/3 |
| borderline | "add CSV export to the reports page" | 0/3 (classified bounded) | 3/3 |
| borderline | fully specified CSV export request | 0/3 | 3/3, plus 4/4 in a separate run and 4/4 via the multi-turn driver |
| negative | "Add a --verbose flag to cli.sh" | brainstorming 3/3 | brainstorming 3/3, deep 0/3 |

### Scenarios

| # | Result | Evidence |
|---|---|---|
| A | PASS | Code was read, then one question with three options and a recommendation. Record created, and nothing else was written. |
| B | PASS | Findings cited as `[E1] src/report.js:4-19`, with no questions about what the code shows. |
| C | FAIL, then PASS | The first run stated Slack and GitHub Actions facts from memory. Investigate now requires official docs for external-system facts, and a Red Flag was added. On rerun it fetched the Slack webhook and `chat.postMessage` docs and the GitHub schedule docs, recorded as E4–E6 with URLs and access dates. |
| D | PASS | "That sounds good" was recorded as a decision with no writing-plans. "That section looks right" on the written design produced a request to approve the whole file. |
| E | PASS | "This is your call" / "Your call" appeared on delivery and trigger choices. |
| F | PASS | A checkpoint line ended every discussion message. Defaults moved to Assumptions. |
| G | PASS | Explicit path: status summarized and resumed. Topic only, on a record dated 2026-09-01: matched by topic, with no duplicate created. |
| H | FAIL, then PASS | The first run stopped at `plan-approved` but offered "say when to begin", and a later "Yes." started executing-plans. The handoff now ends with the paths and "ask me to execute `<plan>`", and a Red Flag was added. On rerun, "Yes." after plan approval did not execute. |
| I | PASS | See routing, negative. |
| J | PASS | Plan mode: brainstorming, then deep-brainstorming, with an Explore helper for research and one question with a recommendation. |
| K | PASS | No commits in any run. After the H fix, only `docs/` is new. |
| L | FAIL, then PASS | 2 of 5 early runs said "your spec covers what I need, so I'm skipping brainstorming" and started TDD. The description now uses the repo's "You MUST use this" form and names that case. Result: 11/11 reached deep-brainstorming, and the design appeared after 2 and 3 questions in two multi-turn runs. |
| M | PASS | "Keep it light" produced the full design in the next message, with 5 remaining questions listed as Assumptions. |
| N | PASS | Branch 4/4 and baseline 1/1: no skills invoked and no writes. |
| O | PASS | The other unfinished record was listed with a resume offer. The dropped idea was set to `abandoned`, with a deletion question. |

Runs for A, B, D–H, J, K, M and O were made before nested sessions were
isolated from the parent session's environment. The extra directory those
sessions inherited contained no instruction files, and the routing table,
L and N were rerun clean.
