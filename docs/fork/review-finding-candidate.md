# F33: exact finding verification candidate

Source: [bigbadmn-sys/superpowers review reception skill](https://github.com/bigbadmn-sys/superpowers/blob/ea9e70f1d9db92729aaf2593d2e340038ab96fa2/skills/receiving-code-review/SKILL.md).

**Status: staged; no live review skill change.** Under deadline pressure, the
simulated baseline agent proposed inspecting the flagged operation's data flow
and required the specific analyzer result before claiming the finding addressed.
It did not run an analyzer or inspect an actual application. See
[evaluation](evaluation.md).

The source addition makes this explicit: a mitigation elsewhere may improve
behavior without clearing a finding keyed to a particular call site or rule.
A possible adaptation would re-read the flagged operation and rule after the
fix, reproduce the originating check where available, and report any unresolved
finding or unavailable verification separately from passing behavioral tests.
Do not rewrite sound code simply to silence a false-positive analyzer; support
reasoned pushback with evidence.

Before activating it, evaluate false positives, moved/renamed call sites,
unavailable analyzers, equivalent mitigations that do satisfy the rule, and
mitigations that do not. Measure correct closure and correct pushback, not just
whether agents run a command. Add live guidance only after a failing baseline
and improved after results.

This document is a proposal record. It is not loaded by the review skill.
