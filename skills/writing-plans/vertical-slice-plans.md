# Compact vertical-slice plans

Use only when the project enables `vertical-slice-plans` as a JSON boolean
or your human partner explicitly requests this format. This is a planning
preference, not permission to skip design or plan approval.

Plan one independently testable capability per task, spanning the layers
needed to deliver it. A save-search task may need a migration, repository,
API, UI, and acceptance test. Do not create separate scaffolding, database,
API, and UI tasks that leave no usable deliverable. Split large capabilities
where one reviewer could reject a deliverable independently. State prerequisites;
independently testable does not mean independent of every earlier interface.

Keep the mandatory plan header, Global Constraints and Review Focus. Use
`### Task N: ...` headings: the task-brief extractor recognizes Task, not Slice.
Each task retains exact Files and Interfaces blocks. Do not invent paths,
commands, types, or requirements; inspect the project and approved spec first.

Replace the repeated TDD microsteps with two checkboxes per capability:

1. Deliver the capability through a red/green cycle. Give acceptance test
   names and exact assertions as code, the failing-test command and expected failure,
   implementation paths/signatures and pinned spec values, then the passing-test
   command and expected result. Tests still precede implementation; the shorter
   document does not remove either run. Leave routine production bodies to the
   implementer. Include the owning Review Focus tests.
2. Commit the verified capability, naming the files and intended message.

Each labeled unit (Acceptance, Red, Implement, Green, Regression, Commit) is
the step for "What a Step Contains" and the self-review step scan. The two
checkboxes group tracking, not actions: each labeled step must make one action
unambiguous. Write test assertions in fenced code blocks in the project's
language, not as prose. Every command step must have its own `Expected:` line
for executing-plans to compare with actual output.

Use this task shape after the standard plan header:

````markdown
### Task N: [User-visible capability]

**Files:**
- Modify: `exact/existing/path`
- Create: `exact/new/path`
- Test: `exact/test/path`

**Interfaces:**
- Consumes: [exact existing or earlier-task signatures/types]
- Produces: [exact signatures/types needed by later tasks]

- [ ] **Deliver [capability] with regression evidence.**
  Acceptance: [test names and exact assertions; spec values and error cases].
```
[actual test code with assertions using exact spec values]
```
  Red: run `[actual project command]` before implementation.
  Expected: [the missing behavior, not an unrelated setup error].
  Implement: [paths, signatures, and decisions the engineer cannot infer].
  Green: run `[actual project command]`.
  Expected: [explicit passing result].
  Regression: run `[relevant existing checks]`.
  Expected: [explicit passing result].

- [ ] **Commit the verified capability.**
  Files: [exact changed paths]. Message: `[intended commit message]`.
````

The bracketed entries above are template slots, not executable plan content.
Resolve them before handoff. Never label expected outcomes as observed test results.

Source concept: [fryga-io/superpowers-rails writing-plans](https://github.com/fryga-io/superpowers-rails/blob/8a784957544b9a4f49a150ef316f137132eef58f/skills/writing-plans/SKILL.md).
Adapted for this fork without Rails dependencies or replacing its review gates.
