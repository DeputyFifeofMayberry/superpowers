# F32: sibling defect scan candidate

Source: [bigbadmn-sys/superpowers verification skill](https://github.com/bigbadmn-sys/superpowers/blob/ea9e70f1d9db92729aaf2593d2e340038ab96fa2/skills/verification-before-completion/SKILL.md).

**Status: staged; no live verification skill change.** The baseline agent
checked known copied normalization paths despite a passing suite, deadline,
and teammate pressure to ignore them. See [evaluation](evaluation.md).

The useful source addition explicitly asks for a same-pattern scan after a
defect is fixed. A possible scoped adaptation would require examining sibling
sites in the affected module that share the broken connection, lock,
transaction, exception handler or conversion pattern; record checked sites,
confirmed defects and exclusions. A shared pattern makes a site a suspect,
not proof that it contains the same bug. Search results alone do not prove
behavioral correctness.

Before activating this guidance, run new baseline cases where the agent is
not told which siblings exist, and where similar-looking sites have legitimate
semantic differences. Grade discovery, regression evidence, scope handling,
and unnecessary changes. Only add the rule if existing verification fails and
the candidate improves behavior without forcing a repository-wide audit.

This document is a proposal record. It is not loaded by the verification skill.
