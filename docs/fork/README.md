# Superpowers fork feature dump

Start with [the manifest](feature-manifest.md), then read [the audit](fork-audit.md) for the evidence and tradeoffs. This branch starts from your `dev`, including deep-brainstorming. Your other feature branch is not included automatically.

The manifest distinguishes installed behavior from candidates. A source recommendation is not a compatibility guarantee. Larger integrations and domain packs remain candidates until selected for an actual project.

## Initial selection

- F01: [bounded behavior already covered](proportional-workflow.md); combining substantial-work approvals remains staged.
- F03: [compact vertical-slice planning added as an opt-in preference](compact-planning.md). Task extraction, tests before implementation, exact interfaces, and existing review gates are preserved.
- F32: [sibling defect scan staged](defect-scan-candidate.md); current baseline passed.
- F33: [exact review finding verification staged](review-finding-candidate.md); current baseline passed.

Read [the evaluation record](evaluation.md) for before/after evidence and limits.
Read [audit corrections](audit-corrections.md) for execution compatibility fixes
and newly recorded live sessions, and [research artifacts](research-artifacts.md)
for archived large reports and evidence transformations.
The compact preference is instruction-based and defaults off. No integration
hook, domain pack, external dependency, or project setting was installed by this
branch. The remaining manifest entries are candidates, except deliberate skips.

The source audit is a preserved research snapshot. Its statement that the user's fork was unknown describes the earlier research stage; branch integration uses the base recorded in the manifest.
