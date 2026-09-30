# Plan: `deep-brainstorming` skill (DeputyFifeofMayberry/superpowers)

## Context

Existing `brainstorming` auto-fires before creative work and, for architectural work, moves fairly quickly from a few questions to a spec and `writing-plans`. You want feature planning to be a slower, collaborative discovery process: the agent investigates before asking, challenges assumptions, keeps a resumable Markdown record, gets explicit design approval, reuses `writing-plans`, reviews the plan with you, and stops before implementation. It should engage automatically whenever a feature is being planned.

Decisions made in this planning session:

| Decision | Choice |
|---|---|
| Invocation | **Auto-detected** (changed from manual-only at your direction). Also invocable directly as `/superpowers:deep-brainstorming <idea or record path>` for resume |
| Coexistence | `brainstorming` stays the auto-fired router; its **architectural path hands off to `deep-brainstorming`**. Spike and bounded paths unchanged |
| Trigger scope | Planning/designing/building a new feature or subsystem, and any time the agent would enter plan mode (existing `using-superpowers` rule already routes plan mode through `brainstorming`) |
| Record vs spec | **One living file**: `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md` is the record and becomes the spec `writing-plans` reads |
| Commits | **Never auto-commit**; skill writes files and reports paths |
| Tests | Structural shell test + **headless trigger test** + manual acceptance script |
| Base branch | **`origin/dev`** (changed from `main` at your direction) |

Repo facts this plan relies on (verified 2026-09-30):
- `origin/dev` = `b1f8774`, 20 commits ahead of `main`; none touch the files this plan edits. Working tree clean on `claude/hopeful-mendel-djlfa2`; `feature/deep-brainstorming` does not exist locally or on origin.
- `brainstorming`'s description ("You MUST use this before any creative work") is the proven auto-trigger; `using-superpowers` says "Before entering plan mode … invoke the brainstorming skill first." Routing through `brainstorming` avoids two competing descriptions and needs no `using-superpowers` edit.
- Plugin skills are namespaced (`/superpowers:<name>`). `$ARGUMENTS`/`$N` in a skill body are substituted; with no placeholder Claude Code appends `ARGUMENTS: <text>`. Compaction re-attaches only the first 5,000 tokens of an invoked skill (code.claude.com/docs/en/skills) → hard rules at the top; the record on disk is the durable state.
- `skills/` is auto-discovered by the Claude, Codex, Cursor, Kimi manifests and the OpenCode/Pi/Hermes loaders; `.muse-plugin/plugin.json` lists every skill explicitly, so the new skill must be added there or the handoff breaks on Muse.
- `skills/brainstorming/visual-companion.md` uses script paths relative to `skills/brainstorming/`.
- Test patterns to copy: `tests/diagnosing-superpowers/test-skill-structure.sh` (structure) and `tests/explicit-skill-requests/run-test.sh` (`claude -p --plugin-dir … --output-format stream-json`, grep `"skill":"…"`).

## Behavior

**Entry:**
- Auto: `brainstorming` classifies the request as architectural → announces the path → invokes `superpowers:deep-brainstorming`. When in doubt between bounded and architectural, `brainstorming` already takes the heavier path.
- Direct: the model may invoke it from its description; your human partner may type `/superpowers:deep-brainstorming <idea | record path>`.

**Hard rules (top of SKILL.md):**
1. No implementation: no product code, scaffolding, dependency installs, or execution skills. Terminal state = approved plan.
2. No `writing-plans` before explicit approval of the written design. Approval of an idea or scope is not design approval.
3. Never commit. Write/update the record and report its path.
4. Investigate before asking: never ask what the codebase, docs, or an authoritative source can answer.
5. Preferences belong to your human partner: recommend, never decide.

**Flow:**
1. **Start or resume.** If given a record path, or a record in `docs/superpowers/specs/` matches the topic (header `Deep Brainstorming Record` + `Topic:` slug), read it, state status + next open question, continue there. If other unfinished records exist, list them in one line and offer resume. Otherwise restate the idea in 2–3 sentences, flag decomposition if it spans independent subsystems, and create the record from the template.
2. **Investigate.** Read relevant code/docs/commits. Search authoritative external sources (official docs, specs, standards, vendor pages) when a fact could change a decision. Each finding goes into Evidence with source and date. Optional research helpers (subagents) use `prompts/research-helper.md`; they return findings only — no contact with your human partner, no file edits — and the main session discusses them.
3. **Discuss, one topic at a time:** intended outcome → approaches (2–3, recommendation first) → scope/non-goals → constraints → acceptance criteria.
   - One question per message; a batch of ≤3 only when they decide the same thing.
   - Each question: why it matters, options with tradeoffs, recommendation. Preference questions are labeled "your call".
   - Once per topic: offer at least one alternative, challenge one assumption, name complexity that does not serve the outcome (YAGNI).
   - Visual companion: same just-in-time offer rules as `brainstorming`; guide at `skills/brainstorming/visual-companion.md`, script paths relative to that directory.
4. **Pacing (anti-endless-interview).** Skip topics the request already answers (reflect them instead). Keep Open Questions ranked by impact. Ask only questions whose answer changes design, scope, or acceptance criteria; lower-impact items become stated Assumptions with a default. After each topic: update the record, then one checkpoint line — "N open questions remain (M high-impact). Continue, or move to the design?" When M = 0, propose moving to design. "Move to design" or "keep it light" is honored in the next message.
5. **Design.** Present in sections (scope, approach, components/data flow, error handling, acceptance criteria, testing), each approved before the next; carry over brainstorming's "design for isolation" and "working in existing codebases" guidance. Write approved sections into the record's Design section. Self-review (placeholders, contradictions, scope, ambiguity), then ask for review of the written file. On approval set `Status: design-approved`.
6. **Plan.** Invoke `superpowers:writing-plans` with the record as `Spec:`. At its Execution Handoff, ask for plan review; iterate until approved; record the plan path and `Status: plan-approved`; stop. An execution choice may be noted in the record; no execution skill is invoked.
7. **Record upkeep.** Update after every decision, finding, or assumption change. If your human partner drops the idea, set `Status: abandoned` and ask whether to delete the file.

**Red Flags table**, e.g.: "I can decide this preference for them" / "One more question would be nice" (low-impact → assumption) / "They liked the idea, so I'll write the plan" / "Quick scaffold to test the idea" / "I'll ask instead of reading the code" / "The plan is approved, so I'll start executing".

## Files

Create:
| Path | Purpose |
|---|---|
| `skills/deep-brainstorming/SKILL.md` | `name: deep-brainstorming`; `description: "Use when planning, designing, or building a new feature or subsystem that needs discovery, research, and an approved design before an implementation plan"` (no workflow words). Body ≤1,500 words. Sections: Hard rules, Start or resume, Investigate, Discuss, Pacing, Design, Plan handoff, Red Flags. No `$` + digit or `$ARGUMENTS` in body. "your human partner", never "the user". |
| `skills/deep-brainstorming/templates/record.md` | `# <Topic> — Deep Brainstorming Record`; `Topic: <slug>`; `Status: exploring \| design-review \| design-approved \| planning \| plan-approved \| abandoned`; `Last updated`; `Plan:`; sections: Intended outcome, Decisions (table: #, decision, why, evidence refs, date), Evidence (`[E1]` path:line or URL + access date — what it shows), Assumptions, Open questions (checkbox, impact, recommended answer), Rejected alternatives, Design (subsections from flow step 5), Next step. |
| `skills/deep-brainstorming/prompts/research-helper.md` | Subagent template: question, decision it affects, allowed sources; return per finding = claim, source, date, confidence, which option it favors; read-only; no preference calls. |
| `tests/deep-brainstorming/test-skill-structure.sh` | Adapted from the diagnosing-superpowers test: name, "Use when", ≤1024-char description, no `disable-model-invocation`, body ≤1,500 words, `## Hard rules` + `## Red Flags`, referenced `templates/`/`prompts/` files exist, no `$[0-9]`/`$ARGUMENTS`, no "the user", leak scan, no `git commit` instruction; `skills/brainstorming/SKILL.md` references `superpowers:deep-brainstorming`; `.muse-plugin/plugin.json` lists `deep-brainstorming`. |
| `tests/deep-brainstorming/test-trigger.sh` | Opt-in, headless, costs API calls. Fixture project with `cli.sh` and a small reports page. Asserts only Skill-tool names and Write/Edit paths from stream-json. Positive: `Let's make a react todo list` → `brainstorming` then `deep-brainstorming`, no Write/Edit outside `docs/superpowers/specs/` (threshold 3/3). Borderline: "add dark mode to the settings page", "add CSV export to the reports page" → deep-brainstorming (≥2/3). Negative: `Add a --verbose flag to cli.sh` → not invoked (0/3). `--reps N` (default 3); prints rates and log paths under `/tmp/superpowers-tests/<ts>/deep-brainstorming/`. |
| `tests/deep-brainstorming/manual-acceptance.md` | Scenarios below with pass criteria and a results table. |
| `docs/superpowers/plans/2026-09-30-deep-brainstorming-skill.md` | This plan, saved in the repo (uncommitted). |

Modify:
| Path | Change |
|---|---|
| `skills/brainstorming/SKILL.md` | Architectural path → hand off: Three Paths bullet, HARD-GATE architectural bullet ("deep-brainstorming's gates apply"), Architectural checklist (explore context → announce → invoke `superpowers:deep-brainstorming`), process-flow graph branch, terminal-states paragraph. Add one line to the Bounded checklist: if clarifying questions reveal a new user-facing feature or your human partner asks for fuller planning, upgrade to architectural. Move "Exploring approaches", "Presenting the design", "Design for isolation", "After the Design" verbatim into deep-brainstorming. Keep Establish Shared Understanding, spike/bounded wording, Red Flags, Visual Companion unchanged. |
| `.muse-plugin/plugin.json` | Add `{ "id": "deep-brainstorming", "path": "skills/deep-brainstorming/SKILL.md" }` in alphabetical order. |
| `README.md` | Skills Library → Collaboration: add `deep-brainstorming`; note brainstorming routes feature work to it. |
| `docs/testing.md` | List the two new tests. |

Not modified: `skills/using-superpowers/*`, `skills/writing-plans/*`, hooks, loaders, other manifests, `RELEASE-NOTES.md`, version files.

## Implementation steps (later implementation session)

0. **Now, after this plan is approved:** `git fetch origin dev && git switch -c feature/deep-brainstorming origin/dev`. Save this plan to `docs/superpowers/plans/2026-09-30-deep-brainstorming-skill.md`. Stop.
1. **Baseline (RED, per writing-skills):** run `test-trigger.sh` positive/negative and manual scenarios A–C against current `brainstorming`; record failure modes (asks answerable questions, fast jump to spec, no resumable record).
2. Write `test-skill-structure.sh`; run → fails (skill absent).
3. Write `templates/record.md`, `prompts/research-helper.md`, `SKILL.md`.
4. Edit `skills/brainstorming/SKILL.md` and `.muse-plugin/plugin.json`. Run structural test → PASS; `scripts/lint-shell.sh` on both new scripts → clean.
5. **GREEN:** run `test-trigger.sh --reps 3` and all manual scenarios A–O with `claude --plugin-dir .`; record results next to the step 1 baseline.
6. **REFACTOR:** close loopholes seen in step 5 (Red Flags rows, pacing or classification wording); rerun failing scenarios until every threshold in Acceptance tests is met.
7. Update `README.md` and `docs/testing.md`. Show you the full diff. No commit until you ask.

## Acceptance tests

Automated:
- `bash tests/deep-brainstorming/test-skill-structure.sh` → all PASS.
- `bash tests/deep-brainstorming/test-trigger.sh --reps 3` → positive 3/3, borderline ≥2/3, negative 0/3.
- `scripts/lint-shell.sh tests/deep-brainstorming/*.sh` → clean.
- Existing suites still pass: `tests/hooks/test-session-start.sh`, `tests/opencode/run-tests.sh`, `python -m pytest tests/hermes`.

Manual (fresh Claude Code session, sample repo, `--plugin-dir`):

| # | Scenario | Pass criteria |
|---|---|---|
| A | "Let's add CSV export to the reports page" | brainstorming announces architectural, invokes deep-brainstorming; code read before first question; exactly one question with options + recommendation; record created in `docs/superpowers/specs/`; no other files changed |
| B | Idea where a key fact is answerable from the repo | Agent states the answer with `path:line` evidence instead of asking |
| C | Idea depending on an external fact (e.g. an API rate limit) | Agent researches; Evidence entry has URL + date; question cites it |
| D | Reply "that sounds good" to a scope summary | writing-plans not invoked; design approval requested |
| E | Preference question (naming, UX tone) | Labeled "your call"; recommendation given; not decided |
| F | After 3 topics | Checkpoint line with counts; low-impact items moved to Assumptions |
| G | New session: `/superpowers:deep-brainstorming docs/superpowers/specs/<record>.md` | Summarizes status, resumes at first open question, does not re-ask decided items |
| H | Approve design | writing-plans invoked with `Spec:` = record; plan saved; review requested; no execution skill, no code, no commit |
| I | "Add a --verbose flag to cli.sh" in a repo that has cli.sh | Bounded path; deep-brainstorming not invoked |
| J | Enter plan mode for a new feature | brainstorming → deep-brainstorming before any plan is written |
| K | `git status` / `git log` after full run | Only record + plan files new; no new commits |
| L | Request that already states outcome, scope, constraints, and acceptance criteria | Reflected back; design proposed within ≤3 questions |
| M | Mid-discussion: "keep it light, move to design" | Next message presents the design; remaining questions listed as Assumptions |
| N | Spike: "Can we parse these logs with jq? quick and dirty is fine" | Spike path as before; deep-brainstorming not invoked |
| O | Start a new idea while an unfinished record exists; then drop the new idea | Unfinished record listed in one line with resume offer; dropped idea set to `abandoned` and deletion asked |

Steps 1 and 5 run scenarios I and N on both `origin/dev` and the branch; results go side by side in `manual-acceptance.md`.

## Risk mitigations

Each risk identified during planning is resolved in the design above or by the additions below; every mitigation has a check.

| Risk | Mitigation (built into the implementation) | Verified by |
|---|---|---|
| **Longer process for every feature request** | (a) Depth scales to the request: if the request already states outcome, scope, constraints, or acceptance criteria, reflect them and skip those topics. (b) After any checkpoint with 0 high-impact open questions, the agent proposes moving to design. (c) "Move to design" / "keep it light" from your human partner is honored immediately: remaining questions become Assumptions, design is presented in one pass. Added to SKILL.md Pacing section and Red Flags. | Scenario L (well-specified request reaches design proposal within ≤3 questions); Scenario M ("keep it light" honored next message); Scenario F |
| **Edits carefully tuned `brainstorming` content** | Diff limited to architectural-route lines (Three Paths bullet, HARD-GATE bullet, checklist, flow graph, terminal states) plus moving architectural-only sections verbatim; spike/bounded text, Establish Shared Understanding, Red Flags, Visual Companion untouched. Before/after results recorded in `manual-acceptance.md` so eval evidence exists if you later upstream (PR to `dev` with AGENTS.md disclosure). | Regression scenarios N (spike) and I (bounded) behave as before; AGENTS.md acceptance test ("Let's make a react todo list" auto-triggers brainstorming) in `test-trigger.sh`; `git diff origin/dev -- skills/brainstorming/SKILL.md` reviewed with you |
| **Trigger depends on brainstorming's classification** | Three routes into the skill: (1) brainstorming's architectural handoff; (2) deep-brainstorming's own description matches feature planning, so direct model invocation works; (3) `/superpowers:deep-brainstorming` manual override. Add one line to brainstorming's bounded checklist: if clarifying questions reveal a new user-facing feature or your human partner asks for fuller planning, upgrade to architectural (uses the existing one-way ratchet). | `test-trigger.sh` borderline prompts ("add dark mode to the settings page", "add CSV export to the reports page") route to deep-brainstorming in ≥2/3 reps; otherwise tighten wording in step 6 and rerun |
| **Nondeterministic model output in tests** | Automated assertions check only Skill-tool invocation names and Write/Edit paths from stream-json, never prose. `--reps N` with pass thresholds (positive 3/3, borderline ≥2/3, negative 0/3). Trigger test is opt-in (run explicitly, not part of default suites), logs kept under `/tmp/superpowers-tests/<ts>/deep-brainstorming/` for inspection. | Test script prints per-prompt rates and log paths |
| **Abandoned brainstorms leave files in `docs/superpowers/specs/`** | Status enum adds `abandoned`. On start, the skill lists unfinished records (Status not `plan-approved`/`abandoned`) in one line and offers resume. If your human partner drops the idea, set `Status: abandoned` and ask whether to delete the file. Files are never committed, so nothing lands in history without your action. | Scenario O |
| **Resume lookup relying on the filename date** | Record carries a `Topic: <slug>` line; resume matches header `Deep Brainstorming Record` + `Topic:` slug, never the date. Filename date = creation date, never renamed. | Scenario G run on a record created on an earlier date |
| **Muse handoff breaking** | New skill added to `.muse-plugin/plugin.json`. | Structural test asserts the entry |
