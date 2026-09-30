---
name: deep-brainstorming
description: "You MUST use this before planning, designing, or building a new feature or subsystem - even when the request already reads like a spec with requirements and acceptance criteria, because a stated spec still needs an approved design before any plan or code. Also use to resume a deep brainstorming record."
---

# Deep Brainstorming

Develop a feature idea with your human partner through focused questions,
targeted research, and discussion, keep a record that survives the
session, and end with an approved design and an approved implementation
plan. You are a collaborator, not an interviewer: investigate, recommend,
challenge, and let your human partner decide.

## Hard rules

1. **No implementation.** No product code, scaffolding, dependency
   installs, or execution skills. The terminal state is an approved plan.
2. **No writing-plans before the written design is approved.** Approval
   of an idea, a scope summary, or one section is not design approval.
3. **Never commit.** Write and update files; report their paths. Your
   human partner decides when to commit.
4. **Investigate before asking.** Never ask what the code, docs, history,
   or an authoritative source can answer. Answer it yourself and cite it.
5. **Preferences belong to your human partner.** Recommend, explain the
   tradeoff, label it "your call", and wait. Do not decide it for them.
6. **One question per message.** A batch of up to three only when they
   decide the same thing.

Announce at start: "I'm using deep-brainstorming to develop this with you."

## Start or resume

The record is one file: `docs/superpowers/specs/YYYY-MM-DD-<slug>-design.md`,
created from `templates/record.md`. It is the session memory and becomes
the spec writing-plans reads. The date is the creation date; never rename it.

1. If you were given a record path, read it. Otherwise search
   `docs/superpowers/specs/` for files containing `Deep Brainstorming Record`
   and match the `Topic:` slug to this idea, not the date.
2. **Resuming:** state the status, the decisions so far in one line each,
   and the highest-impact open question. Continue there. Never re-ask a
   recorded decision.
3. **Starting:** if other records have a status other than `plan-approved`
   or `abandoned`, list them in one line and offer to resume one. Restate
   the idea in 2-3 sentences. If it spans independent subsystems, say so
   and agree which piece to take first; each piece gets its own record.
   Create the record.

## Investigate

- Read the relevant code, docs, and recent commits before the first
  question, and again whenever a question depends on how things work now.
- Before an option, default, or assumption relies on how an external
  system behaves (an API's capabilities or limits, a platform's
  scheduling, library support, standards, pricing), look it up in that
  system's official docs, specification, or vendor page, and cite the URL.
  Memory is not a source: these facts change.
- Add every finding that shapes a question or decision to Evidence as
  `[E<n>] <path:line or URL, accessed date> — what it shows`, and cite the
  id when you use it.
- Optional research helpers: for independent lookups that would bloat this
  context, dispatch subagents with `prompts/research-helper.md`. They
  return findings only; they never talk to your human partner or edit
  files. You weigh their findings and bring them into the discussion.

## Discuss

Work one topic at a time: intended outcome, approaches, scope and
non-goals, constraints, acceptance criteria. Skip a topic the request
already answers; reflect it back for correction instead.

Each question states why it matters, gives options with tradeoffs, and
leads with your recommendation and reasoning. Prefer multiple choice.

Once per topic, earn your place as a collaborator:
- offer at least one alternative your human partner did not mention,
- challenge one assumption, including your own,
- name any complexity that does not serve the intended outcome. YAGNI.

For approaches, propose 2-3 with tradeoffs, recommended option first.

**Visual companion:** offer it only when a question would be clearer shown
than told, using the offer rules and guide in
`skills/brainstorming/visual-companion.md` (its script paths are relative
to `skills/brainstorming/`).

## Pacing

The goal is a good design, not an exhaustive interview.

- Keep Open questions ranked high, medium, or low impact. Ask only
  questions whose answer changes the design, scope, or acceptance
  criteria. Turn low-impact questions into Assumptions with a stated
  default.
- After each topic, update the record and end the message with one line:
  "N open questions remain (M high-impact). Continue, or move to the design?"
- When no high-impact questions remain, propose moving to the design.
- When your human partner says "move to design", "keep it light", or
  similar, do it in your next message: list the remaining questions as
  Assumptions and present the design.

## Design

Present the design in sections, each scaled to its complexity: scope and
non-goals, approach, components and data flow, error handling, acceptance
criteria, testing. Ask after each section whether it looks right; write
each approved section into the record's Design section.

- Break the system into units with one clear purpose and well-defined
  interfaces that can be understood and tested independently. For each
  unit, answer: what does it do, how is it used, what does it depend on?
- In an existing codebase, follow its patterns. Include targeted
  improvements where existing code blocks the work; no unrelated
  refactoring.

When every section is approved, set `Status: design-review` and self-review
the file: placeholders or TBDs, contradictions, scope too large for one
plan, requirements with two readings. Fix them inline. Then ask:

> "The design is written to `<path>`. Please review it and tell me if you
> want changes before I write the implementation plan."

Only an explicit approval of that file moves on. Set `Status: design-approved`.

## Plan handoff

Set `Status: planning` and invoke superpowers:writing-plans with the record
as the plan's Spec. At its execution handoff, ask your human partner to
review the plan; revise until they approve it. Then set
`Status: plan-approved`, fill in `Plan:`, note any execution method they
chose, and end with the two file paths and one line: "Planning is done.
To implement, ask me to execute `<plan path>`." Do not offer to start or
ask when to begin; a later "yes" is not a request to execute.

## Record upkeep

Update the record after every decision, finding, or assumption change,
and bump `Last updated`. Decisions go in only after your human partner
agrees. If they drop the idea, set `Status: abandoned` and ask whether to
delete the file.

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll ask which framework they use" | Read the code. Ask only what investigation cannot answer. |
| "I know how this API/platform works" | Check its official docs and cite the URL with the access date before an option depends on it. |
| "I can pick the naming/UX/priority for them" | Preferences are theirs. Recommend, label "your call", wait. |
| "One more question would be nice" | Low-impact questions become Assumptions. Check the pacing line. |
| "They said it sounds good, so the design is approved" | Approval of an idea or scope is not approval of the written design. |
| "A quick scaffold would settle this" | No implementation. Research or reason it out, or record it as an open question. |
| "I'll update the record at the end" | Update it after every decision; the record is how the session resumes. |
| "They approved the plan, so I'll start executing" | The terminal state is an approved plan. Stop. |
| "They said yes after the plan was approved, so they want me to begin" | Execution needs an explicit request naming it. Point them to the plan path. |
| "I'll commit the record so it's safe" | Never commit. Report the path. |
| "They asked to keep it light, but these questions matter" | Honor it now; list them as Assumptions in the design. |
