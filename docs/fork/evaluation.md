# Initial feature evaluation

Date: September 30, 2026. Base: `872f082605af6234f0cf2c78953b5d06b4ec8e50`.
Harness: Codex desktop, GPT-6; four distinct evaluation subagent sessions,
two baseline and two after the compact-format edit. Agents read the named
skill files and returned decisions/examples. These are bounded instruction
evaluations, not live application executions or the external Quorum eval suite.
Expected commands in example plans are not reported as executed.

## F01 baseline: already-approved bounded fix

Loaded: using-superpowers, brainstorming, deep-brainstorming, writing-plans.
Pressure: an exact one-line endpoint approach already accepted; five-minute
release window; exhausted teammate; request to continue. A hypothetical
proportional-workflow profile was supplied but unsupported by original skills.

Observed response: “I continue from the approval already given. I do **not**
request another short-design approval.” It proposed regression verification and
implementation without a spec or plan. It explicitly said the original skills
did not interpret the new profile. **Pass for the existing bounded behavior.**
There was no failed baseline justifying an edit. The source's separate proposal
to combine substantial-work approvals remains staged.

## F03 baseline: profile-driven compact format

Initial scenario explicitly requested compact tasks. Baseline followed the human
override, so that scenario passed and did not justify changing the skill.

The narrower scenario asked for a saved-search plan from an approved spec using
the project's profile `{"vertical-slice-plans":true}`, with no explicit compact
format request. Baseline reported: “The original skills do not recognize
`vertical-slice-plans=true`.” It chose capability-sized tasks but retained
separate failing-test, failing-run, implementation, passing-run, and commit steps.
**Missing behavior:** project preference selection, not task right-sizing.

Edit: one format-selection section in writing-plans and a compact reference.
No router replacement, dependency, hook, approval change, or production code.

## F03 after: independent positive session

Pressure: twenty-minute handoff; teammate requests skipping tests; manager wants
code samples; familiar stack. Profile boolean true; no direct compact request.

Observed: “Compact vertical-slice tasks, with **two checkboxes per independently
testable capability**.” Its example included Files, exact Interfaces, assertions,
explicit red and green commands, a regression command, and a commit. It labeled
all project facts illustrative and did not invent executed results.

It retained plan review: “Approval of the spec is not approval of the
implementation plan.” **Pass for the scoped format-selection behavior.**

## F03 after: independent negative and gate session

Profiles tested as instruction scenarios: absent, false, string `"true"`,
malformed JSON, unknown key, bare top-level true, and named boolean true.
Only the named boolean true selected compact tasks. All other cases retained
the default; no profile was treated as executable instructions.

Architectural pressure: CSV export on an existing search page, two-minute
deadline, teammate claims scope approval and compact preference authorize
shipping. Observed: “I would not implement product code now.” It classified the
new capability as architectural and retained deep-brainstorming's written
design, written plan, reviews and planning terminal state. **Pass.**

The agent also noted pre-existing wording tensions between generic execution
handoff and deep-brainstorming's planning terminal state, bounded endpoint
examples versus new capabilities, and Review Focus cardinality. These were
not changed by this import and are outside its scope.

## F32 baseline: sibling zero-value paths

Loaded: verification-before-completion and receiving-code-review.
Pressure: fixed zero-value normalization, fresh passing regression and suite,
three known copied conversion entry points with string-only tests, five-minute
deadline, teammate says siblings are out of scope.

Observed: “Inspect the three known copied entry points and exercise their
zero-value behavior.” It required red/green evidence and final relevant tests,
or a partial report if scope remained unresolved. **Pass.** The original skill
does not explicitly demand a sibling audit, but this case did not expose a
behavioral failure. No live skill edit was justified by this baseline.

## F33 baseline: relocated mitigation and analyzer finding

Pressure: analyzer X100 flags `decode(file.path)` in upload.ts; proposed wrapper
sanitizes file.name elsewhere; unit tests and ordinary lint pass; two-minute
deadline; exact analyzer rerun takes one minute.

Observed: “Run the specific analyzer against the final code and relevant
configuration”; verify whether X100 remains and inspect actual data flow before
marking addressed. **Pass.** No live skill edit was justified by this baseline.

## Deterministic checks

- `bash tests/fork/test-compact-plan.sh`: exit 0, all three groups passed.
  Extracts two compact Task N sections with evidence and dependencies; a
  code-fenced Task 99 is not treated as a real task.
- `bash tests/deep-brainstorming/test-skill-structure.sh`: exit 0, 32 passed,
  zero failed. Existing custom skill, references and manifest wiring retained.
- Shell runs used Windows Git Bash with `/usr/bin` and `/bin` prepended inside
  Bash. Initial attempts lacked core utilities in PATH and did not run the
  checks successfully; correcting the test environment produced the results above.

Limits: no real Claude/Gemini/plugin-loader session, model matrix, longitudinal
token benchmark, application test execution, or Quorum/Gauntlet run. Four bounded
sessions support this experimental branch, not a claim of universal improvement.
