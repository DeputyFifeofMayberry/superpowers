# Superpowers fork enhancement audit

Audit date: **September 30, 2026 (America/Los_Angeles)**. Public repository data was fetched during this session. Upstream baseline: [obra/superpowers v6.4.2, `8ca22dba9a94`](https://github.com/obra/superpowers/tree/8ca22dba9a94f28898bbce59f2537ff4d87c747d).

## Recommended direction

Keep current upstream as the core and add a small, configurable extension layer. The strongest broadly useful opportunities are **proportional workflow routing, thin vertical-slice plans, searchable solved-problem memory, precise handoffs, defect-class verification, and measured skill evaluations**. Persistent trackers, model-routing hooks, containers, agent teams and domain packs are valuable only when they match an actual need.

Do not merge a large fork wholesale. Popular forks contain older upstream behavior, imported third-party material, specialized assumptions, and sometimes obsolete comparisons with upstream. The user's own fork URL/base and supported hosts were not provided; recommendations are architectural priorities, not a compatibility-tested patch list.

## Coverage and methodology

| Stage | Coverage |
| --- | ---: |
| Distinct public fork records returned by the paginated forks endpoint | 26,385 |
| Heuristically selected default branches compared with pinned upstream | 2,930 |
| Ahead or diverged, with at least one ahead commit | 435 |
| Identical default branches | 108 |
| Only behind upstream | 2,195 |
| Unresolved API comparisons | 192 |
| Repositories fetched into Git for source/diff/history inspection, including supplemental leads | 46 |
| Curated enhancement/skip findings in this report | 72 |

1. **Enumerate:** read GitHub repository metadata and paginate `GET /repos/obra/superpowers/forks?per_page=100&sort=oldest&page=N`. Deduplicate by full repository name. An initial stargazer-ordered pass produced duplicate records among equal-star forks, so the final inventory uses stable creation order. No final inventory page failed.
2. **Select candidates:** include forks with at least one star, a renamed repository, a nonstandard description, or repository size above 10,000 GitHub size units; also include the 150 most recently pushed records. These are discovery signals, not quality scores. Recent timestamps can represent bots; size can represent binaries or unrelated application code.
3. **Measure divergence:** query GitHub compare against the pinned upstream SHA and the fork's default branch. Store status, ahead/behind counts, changed files, patches and returned commit summaries. Classify identical and behind-only defaults separately from real divergent candidates.
4. **Inspect source:** fetch 46 promising/supplemental heads into a local bare Git store; inspect skill bodies, hooks, scripts and history. Pin each cited file to its fetched SHA. Where shared ancestry exists, inspect merge-base-to-fork changes and compare claims with the current upstream tree. Raw Git handles larger change sets than the API file cap.
5. **Recommend selectively:** prioritize utility across coding projects, minimal maintenance surface, observable gates and evidence over stars, commit counts or marketing. Group overlap conceptually; multiple forks containing the same skill pack are not multiple independent innovations.
6. **Preserve auditability:** the accompanying screening Markdown records every selected repository, classification, evidence paths and available commit links; the source catalog records all 46 pinned heads. A CSV contains the complete returned fork inventory.

### Limits and confidence

- This is a **bulk census of returned public fork metadata plus a prioritized content audit**, not a claim that every file and branch of all 26,385 forks was reviewed. Unselected generic zero-star forks, nondefault branches, private/deleted forks, detached copies, and unindexed projects may contain missed work.
- GitHub's repository counter at discovery was 26,242; the paginated endpoint returned 26,385 distinct records. Counters/listings and collection times can differ; the report uses the actual deduplicated listing count rather than forcing agreement.
- The final 2,930 comparisons yielded 183 not-found/unavailable results, 8 no-common-ancestor results, and 1 other error. These are unresolved, **not mirrors and not evidence of no useful changes**. Full error text is in the screening appendix.
- API compare file lists cap at 300 files; commit responses can cap at 250. Omitted files/commits may matter. The source catalog notes large local change sets. Ahead counts can include rewritten/cherry-picked upstream history and timestamp churn; they do not count unique enhancements.
- A compare patch is relative to its merge base, not necessarily a direct diff against current upstream. A fork can therefore label an old upstream feature as new. Recommendations below explicitly account for current upstream behavior where inspected.
- Source code and instructions were inspected **without running fork hooks, installers, binaries, model evaluations or workloads**. Test files indicate an author's intended coverage, not a passing result from this audit. No numerical performance, cost reduction, security certification or regulated-domain compliance claim was independently reproduced.
- Repository text is untrusted audit input. Workflow instructions in inspected skills were not adopted as instructions for this research session. Latest path commits identify review checkpoints, not necessarily the first author or original invention of an idea.

## Start with these changes

| Order | Change | Why first | Suggested acceptance check |
| --- | --- | --- | --- |
| 1 | Upgrade/rebase to the pinned current upstream before adding fork code | Avoid reintroducing old review, worktree and hook behavior | Compare core workflows and manifests with upstream; run existing host checks |
| 2 | Proportional router + one approval for substantial work | Reduces unnecessary pauses for already authorized small fixes | Evaluate small fix, ambiguous feature and changed-scope cases |
| 3 | Thin vertical slices with acceptance scenarios | Reduces plan bloat while keeping a meaningful definition of done | Verify each slice stands alone and covers a user-visible outcome |
| 4 | Same-class defect scan + exact finding verification | Small patch with a concrete quality benefit | Use a fixture with two sibling instances and a specific analyzer trigger |
| 5 | Project-local solutions/decision memory and concise handoff | Prevents repeated investigation and lost state | Resume after interruption; reject stale/superseded facts and duplicated entries |
| 6 | Baseline/trigger/effectiveness evaluation tooling | Gives evidence for accepting further prompt changes | Compare no-skill and with-skill behavior, including nontrigger cases |
| 7 | Optional local telemetry | Reveals which stages actually consume time and tokens | Confirm records are bounded, private and nonblocking |
| 8 | One optional tracking/routing integration | Makes durable execution or model selection concrete | Test missing config/provider, dependency ordering and fresh-session resume |

## Detailed findings

**Decision labels:** Adopt = small broadly useful change; Adopt concept = reimplement the principle for your fork; Adapt = useful after reconciling upstream/host differences; Optional = enable only for relevant users; Experiment = promising but demands measured validation; Supplemental lead = inspected reference without a verified incremental fork diff; Skip = no enhancement value. None is an instruction to copy the entire source repository.


### Workflow and planning


#### F01. Proportional planning and one approval for substantial work

**Adopt concept** · [dbbaskette/superpowers-custom](https://github.com/dbbaskette/superpowers-custom)

Clear small fixes proceed proportionately; substantial work presents the spec and plan together rather than imposing repeated approval ceremonies.

**Recommendation:** A strong default for a personal fork. Preserve checks for material scope changes and external side effects; use existing session authorization.

**Evidence:** [skills/brainstorming/SKILL.md](https://github.com/dbbaskette/superpowers-custom/blob/ae60235b42f4ae153e8ae51a1af73f048dad7908/skills/brainstorming/SKILL.md). Latest non-merge change to the first cited path: [49c45fb75c](https://github.com/dbbaskette/superpowers-custom/commit/49c45fb75cdbfa2597763927ad6a80f2bc939a4e).


#### F02. Skills-only lightweight overlay

**Adapt** · [nanyumeng/superpowers-lite](https://github.com/nanyumeng/superpowers-lite)

Publishes a lighter skills overlay while preserving familiar skill names and document locations.

**Recommendation:** Prefer this distribution pattern over a permanent rewrite of all upstream internals. Its reported 30%+ token reduction is maintainer field observation, not a result reproduced here.

**Evidence:** [README.md](https://github.com/nanyumeng/superpowers-lite/blob/3fef64cc720671bc75924dc02697f0b8d1b7777d/README.md); [skills/using-superpowers/SKILL.md](https://github.com/nanyumeng/superpowers-lite/blob/3fef64cc720671bc75924dc02697f0b8d1b7777d/skills/using-superpowers/SKILL.md). Latest non-merge change to the first cited path: [3fef64cc72](https://github.com/nanyumeng/superpowers-lite/commit/3fef64cc720671bc75924dc02697f0b8d1b7777d).


#### F03. Vertical slices instead of scripted layer-by-layer plans

**Adopt concept** · [fryga-io/superpowers-rails](https://github.com/fryga-io/superpowers-rails)

Each task delivers one user-facing capability across the layers it needs, with its own end-to-end acceptance scenario; omits repeated write/run/implement/run microsteps.

**Recommendation:** Generalize the slice structure to your stack. Upstream already right-sizes tasks; the delta is the much thinner capability-oriented plan format.

**Evidence:** [skills/writing-plans/SKILL.md](https://github.com/fryga-io/superpowers-rails/blob/8a784957544b9a4f49a150ef316f137132eef58f/skills/writing-plans/SKILL.md). Latest non-merge change to the first cited path: [04bb83ca45](https://github.com/fryga-io/superpowers-rails/commit/04bb83ca454c02fcc4b616d6e0254f59905bfe75).


#### F04. Micro/lightweight/full workflow router

**Adapt** · [REPOZY/superpowers-optimized](https://github.com/REPOZY/superpowers-optimized)

A micro task can bypass workflow machinery; qualifying lightweight work goes directly to implementation with final verification; full work retains the pipeline.

**Recommendation:** Upstream already has spike/bounded/architectural paths. Consider only the missing direct-execution micro path and observable classification rules, rather than copying an older whole router.

**Evidence:** [skills/using-superpowers/SKILL.md](https://github.com/REPOZY/superpowers-optimized/blob/38e85b92383e7d18afe4a59cc681c9caa9479e21/skills/using-superpowers/SKILL.md). Latest non-merge change to the first cited path: [0a78a70002](https://github.com/REPOZY/superpowers-optimized/commit/0a78a7000266c48901067960eaf0f1d2b33e2532).


#### F05. Premise validation before investing in implementation

**Adopt concept** · [REPOZY/superpowers-optimized](https://github.com/REPOZY/superpowers-optimized)

Reassesses whether proposed work is justified, including when new evidence undermines its original motivation.

**Recommendation:** Useful for preventing unnecessary features and fixes to nonexistent problems. Keep the output a short evidence-based decision, not another mandatory ceremony.

**Evidence:** [skills/premise-check/SKILL.md](https://github.com/REPOZY/superpowers-optimized/blob/38e85b92383e7d18afe4a59cc681c9caa9479e21/skills/premise-check/SKILL.md). Latest non-merge change to the first cited path: [5b919bb16b](https://github.com/REPOZY/superpowers-optimized/commit/5b919bb16b55053354efc0b933aa19afcc0ef3f9).


#### F06. Structured stakeholder deliberation

**Optional** · [REPOZY/superpowers-optimized](https://github.com/REPOZY/superpowers-optimized)

Uses distinct stakeholder perspectives to identify convergence and unresolved tensions before design.

**Recommendation:** Use for costly architectural tradeoffs. Multiple simulated perspectives are reasoning aids, not independent factual evidence.

**Evidence:** [skills/deliberation/SKILL.md](https://github.com/REPOZY/superpowers-optimized/blob/38e85b92383e7d18afe4a59cc681c9caa9479e21/skills/deliberation/SKILL.md). Latest non-merge change to the first cited path: [0a78a70002](https://github.com/REPOZY/superpowers-optimized/commit/0a78a7000266c48901067960eaf0f1d2b33e2532).


#### F07. Opt-in autonomy with blocker timeboxes

**Adapt** · [Ayagikei/superpowers](https://github.com/Ayagikei/superpowers)

Defines conservative assumptions, timeboxes blockers, continues independent tasks, and reports unresolved unblock conditions.

**Recommendation:** Take the blocker handling and explicit opt-in. Reject any priority statement that would supersede host policy or real authorization boundaries.

**Evidence:** [skills/unattended-mode/SKILL.md](https://github.com/Ayagikei/superpowers/blob/7d43fad631d7d713470a67dde1f9aed37625ff08/skills/unattended-mode/SKILL.md). Latest non-merge change to the first cited path: [eaafb86e19](https://github.com/Ayagikei/superpowers/commit/eaafb86e196c96c9697454d3905d30cdb2d0110d).


#### F08. Anti-stalling Stop hook

**Adapt cautiously** · [ennio-datatide/ultrapowers](https://github.com/ennio-datatide/ultrapowers)

Detects mid-task requests to continue and distinguishes sanctioned workflow checkpoints from unnecessary permission questions.

**Recommendation:** Useful as a reminder after scope is authorized. Regex phrase policing can reject legitimate questions; default to advisory and keep required approvals possible.

**Evidence:** [skills/core/no-permission-asks/SKILL.md](https://github.com/ennio-datatide/ultrapowers/blob/c6bcb5d7afad97868bb4775404879964a72ae756/skills/core/no-permission-asks/SKILL.md); [hooks/enforce-no-permission-asks](https://github.com/ennio-datatide/ultrapowers/blob/c6bcb5d7afad97868bb4775404879964a72ae756/hooks/enforce-no-permission-asks). Latest non-merge change to the first cited path: [a08ee872a8](https://github.com/ennio-datatide/ultrapowers/commit/a08ee872a8c71edff1edea8ebbbcc7b2706251f7).


### Execution, tracking and integrations


#### F09. Task metadata, dependencies, and commit strategy

**Adapt** · [pcvelz/superpowers](https://github.com/pcvelz/superpowers)

Extends native task descriptions with machine-readable metadata and hooks for execution policies.

**Recommendation:** Good when using Claude Code native tasks. Define one task authority and a versioned schema; avoid independently updating native tasks, plan checkboxes, and a ledger without reconciliation.

**Evidence:** [skills/shared/task-format-reference.md](https://github.com/pcvelz/superpowers/blob/cb12f4fdfcd31e2c76b06cc2b39dc21986b97b0a/skills/shared/task-format-reference.md); [hooks/pre-taskcreate-commit-strategy](https://github.com/pcvelz/superpowers/blob/cb12f4fdfcd31e2c76b06cc2b39dc21986b97b0a/hooks/pre-taskcreate-commit-strategy). Latest non-merge change to the first cited path: [a0d177f18c](https://github.com/pcvelz/superpowers/commit/a0d177f18c69541f082de9b3a79301a0f559b31c).


#### F10. Configurable model/effort routing enforced before dispatch

**Adapt** · [pcvelz/superpowers](https://github.com/pcvelz/superpowers)

Project or user configuration maps task tiers to models; dispatch hooks enforce allowed routing and can account for custom agent definitions.

**Recommendation:** Upstream already recommends model selection. The enhancement is opt-in configuration and enforcement. Keep fail-open behavior for malformed config and evaluate dispatch overhead.

**Evidence:** [hooks/pre-agent-model-routing](https://github.com/pcvelz/superpowers/blob/cb12f4fdfcd31e2c76b06cc2b39dc21986b97b0a/hooks/pre-agent-model-routing); [hooks/pre-taskcreate-model-tier](https://github.com/pcvelz/superpowers/blob/cb12f4fdfcd31e2c76b06cc2b39dc21986b97b0a/hooks/pre-taskcreate-model-tier). Latest non-merge change to the first cited path: [e5d8031662](https://github.com/pcvelz/superpowers/commit/e5d8031662a01c808454cd8aaddbe87b58947e6e).


#### F11. Explicit user verification gates

**Optional** · [pcvelz/superpowers](https://github.com/pcvelz/superpowers)

Gate metadata records acceptance criteria, proof commands, scope, and failure policy; specification and execution are separate.

**Recommendation:** Useful for rollout or hardware acceptance. Make clarification conditional on genuinely missing mechanics; do not repeat questions already answered in the task.

**Evidence:** [skills/specifying-gates/SKILL.md](https://github.com/pcvelz/superpowers/blob/cb12f4fdfcd31e2c76b06cc2b39dc21986b97b0a/skills/specifying-gates/SKILL.md); [skills/checking-gates/SKILL.md](https://github.com/pcvelz/superpowers/blob/cb12f4fdfcd31e2c76b06cc2b39dc21986b97b0a/skills/checking-gates/SKILL.md). Latest non-merge change to the first cited path: [6ca7ee284c](https://github.com/pcvelz/superpowers/commit/6ca7ee284c8fe9823bfdbaf4166bf7fe1638bcf4).


#### F12. Stop/wait and handoff enforcement

**Optional** · [pcvelz/superpowers](https://github.com/pcvelz/superpowers)

Provides guards against premature waiting and poorly timed handoffs during execution.

**Recommendation:** Treat as optional Claude-specific controls. Transcript layouts, context accounting, and hook behavior require host-specific validation.

**Evidence:** [hooks/examples/stop-wait-guard.sh](https://github.com/pcvelz/superpowers/blob/cb12f4fdfcd31e2c76b06cc2b39dc21986b97b0a/hooks/examples/stop-wait-guard.sh); [hooks/pre-askuser-handoff-guard](https://github.com/pcvelz/superpowers/blob/cb12f4fdfcd31e2c76b06cc2b39dc21986b97b0a/hooks/pre-askuser-handoff-guard). Latest non-merge change to the first cited path: [f926482ac1](https://github.com/pcvelz/superpowers/commit/f926482ac12672eb7a4cbb693975fcc991f2653f).


#### F13. Persistent dependency-aware beads execution

**Optional** · [schlenks/superpowers-bd](https://github.com/schlenks/superpowers-bd)

Converts plans into beads issues and executes dependency-aware waves with durable work state.

**Recommendation:** Consider when multi-session issue tracking is a real requirement. Beads is an added prerequisite; basic persistence and scoped reviews already exist upstream.

**Evidence:** [skills/plan2beads/SKILL.md](https://github.com/schlenks/superpowers-bd/blob/30e3c5e96a80cb21d338e61e31cbed00bbad02de/skills/plan2beads/SKILL.md); [skills/subagent-driven-development/SKILL.md](https://github.com/schlenks/superpowers-bd/blob/30e3c5e96a80cb21d338e61e31cbed00bbad02de/skills/subagent-driven-development/SKILL.md). Latest non-merge change to the first cited path: [5b81d1b9df](https://github.com/schlenks/superpowers-bd/commit/5b81d1b9dffea446e9b44850eaddfa14a98b3afd).


#### F14. Dedicated aggregate verifier and checkpoint hooks

**Optional** · [schlenks/superpowers-bd](https://github.com/schlenks/superpowers-bd)

Adds an epic verification role and work-state anchoring beyond individual task reviews.

**Recommendation:** Useful for cross-task integration failures. Avoid its blanket five-pass reviews for every artifact above a line-count threshold unless evaluations justify the cost.

**Evidence:** [agents/epic-verifier.md](https://github.com/schlenks/superpowers-bd/blob/30e3c5e96a80cb21d338e61e31cbed00bbad02de/agents/epic-verifier.md); [hooks/work-state-anchor.sh](https://github.com/schlenks/superpowers-bd/blob/30e3c5e96a80cb21d338e61e31cbed00bbad02de/hooks/work-state-anchor.sh). Latest non-merge change to the first cited path: [f2a5c7ba36](https://github.com/schlenks/superpowers-bd/commit/f2a5c7ba36ff960114aa7c0561d2e2a03ff2ea42).


#### F15. Claude agent-team workflow with capability fallback

**Optional** · [sharankarthikyan/superpowers](https://github.com/sharankarthikyan/superpowers)

Defines parallel tracks, peer messaging, shared tasks, and fallback to ordinary execution when agent teams are unavailable.

**Recommendation:** Add as a separate explicitly selected mode. Require independent ownership; do not replace ordinary SDD with experimental teams for small work.

**Evidence:** [skills/team-driven-development/SKILL.md](https://github.com/sharankarthikyan/superpowers/blob/f804ab9b1126a4de6a2dcd8b392c4db4e8bdd22e/skills/team-driven-development/SKILL.md). Latest non-merge change to the first cited path: [0b9db1564c](https://github.com/sharankarthikyan/superpowers/commit/0b9db1564c9f6ad686e4adeb1262a1aa82ccdb07).


#### F16. Plan-to-issue and task-group pull requests

**Optional** · [mikeyobrien/superpowers](https://github.com/mikeyobrien/superpowers)

Moves approved plans into GitHub issues and executes task groups into individually reviewable PRs.

**Recommendation:** A useful integration pattern, but modernize its naive Markdown parsing and use structured bodies/files. Publishing an issue or PR still needs appropriate authorization.

**Evidence:** [skills/plan-to-issue/SKILL.md](https://github.com/mikeyobrien/superpowers/blob/436af83966f01110c058b366f69fd8671dbf382c/skills/plan-to-issue/SKILL.md); [skills/execute-with-prs/SKILL.md](https://github.com/mikeyobrien/superpowers/blob/436af83966f01110c058b366f69fd8671dbf382c/skills/execute-with-prs/SKILL.md). Latest non-merge change to the first cited path: [436af83966](https://github.com/mikeyobrien/superpowers/commit/436af83966f01110c058b366f69fd8671dbf382c).


#### F17. Separate roadmap and execution providers

**Optional** · [codyw912/sjujperpowers](https://github.com/codyw912/sjujperpowers)

Separates portfolio authority, versioned specs/plans, durable task tracking, session progress, and landing history; offers file/session and external-provider combinations.

**Recommendation:** A good architecture for integrations without binding the core to one vendor. Plane is reference-only and Linear is reserved, not implemented; avoid advertising either as a complete automation connector.

**Evidence:** [skills/tracking-providers/SKILL.md](https://github.com/codyw912/sjujperpowers/blob/fb3395eb3e2e9808fc516fe5d537f5b42a737b2d/skills/tracking-providers/SKILL.md). Latest non-merge change to the first cited path: [fb3395eb3e](https://github.com/codyw912/sjujperpowers/commit/fb3395eb3e2e9808fc516fe5d537f5b42a737b2d).


#### F18. Jujutsu change-stack workflow

**Optional** · [codyw912/sjujperpowers](https://github.com/codyw912/sjujperpowers)

Reworks change creation and finishing around Jujutsu and stacked changes.

**Recommendation:** Only for a fork whose users choose jj. Keep a Git-compatible default instead of importing the stack mechanics universally.

**Evidence:** [skills/starting-a-change/SKILL.md](https://github.com/codyw912/sjujperpowers/blob/fb3395eb3e2e9808fc516fe5d537f5b42a737b2d/skills/starting-a-change/SKILL.md); [skills/finishing-a-change-stack/SKILL.md](https://github.com/codyw912/sjujperpowers/blob/fb3395eb3e2e9808fc516fe5d537f5b42a737b2d/skills/finishing-a-change-stack/SKILL.md). Latest non-merge change to the first cited path: [7eaedbf712](https://github.com/codyw912/sjujperpowers/commit/7eaedbf71252ed4d535300b2fd2fcc4a9e8dbe6d).


#### F19. Cross-model collaboration with evidence checkpoints

**Optional** · [BryanHoo/superpowers-ccg](https://github.com/BryanHoo/superpowers-ccg)

Routes work to Codex/Gemini MCP integrations and requires external artifacts before continuing selected workflows.

**Recommendation:** Keep role/evidence contracts and patch-only prototypes. Avoid rigid frontend/backend model stereotypes, bundled executable wrappers, and blocking every task when an optional provider is unavailable.

**Evidence:** [skills/coordinating-multi-model-work/SKILL.md](https://github.com/BryanHoo/superpowers-ccg/blob/a8b4915e9e5df338ebf85bcf6cbd66979f8cbbf0/skills/coordinating-multi-model-work/SKILL.md); [skills/coordinating-multi-model-work/GATE.md](https://github.com/BryanHoo/superpowers-ccg/blob/a8b4915e9e5df338ebf85bcf6cbd66979f8cbbf0/skills/coordinating-multi-model-work/GATE.md). Latest non-merge change to the first cited path: [4d44d0b64a](https://github.com/BryanHoo/superpowers-ccg/commit/4d44d0b64a5ee577038e2fe91505334d11d6ab05).


#### F20. Container-based agent environments

**Optional** · [dizk/containerpowers](https://github.com/dizk/containerpowers)

Adapts execution to Dagger container-use environments with reviewable diffs and environment monitoring.

**Recommendation:** Useful for dependency isolation and reproducibility. Do not copy the all-work-in-containers mandate or claim a container eliminates all host/network risks.

**Evidence:** [skills/container-setup/SKILL.md](https://github.com/dizk/containerpowers/blob/22a4197200fb4d79170c5cba6ced0a299b837b88/skills/container-setup/SKILL.md); [skills/monitoring-container-agents/SKILL.md](https://github.com/dizk/containerpowers/blob/22a4197200fb4d79170c5cba6ced0a299b837b88/skills/monitoring-container-agents/SKILL.md). Latest non-merge change to the first cited path: [5aa5f65845](https://github.com/dizk/containerpowers/commit/5aa5f658456520a784bccd0372f82fc79a486f69).


### Memory, handoffs and specifications


#### F21. Durable project map, decision log, and task snapshot

**Adopt concept** · [REPOZY/superpowers-optimized](https://github.com/REPOZY/superpowers-optimized)

Separates project structure/constraints, saved decisions, active-task state, and known issue recall.

**Recommendation:** A substantive extension to upstream per-plan ledgers. Start with small project-local files, provenance and staleness handling; do not inject the whole historical log every turn.

**Evidence:** [skills/context-management/SKILL.md](https://github.com/REPOZY/superpowers-optimized/blob/38e85b92383e7d18afe4a59cc681c9caa9479e21/skills/context-management/SKILL.md); [hooks/context-engine.js](https://github.com/REPOZY/superpowers-optimized/blob/38e85b92383e7d18afe4a59cc681c9caa9479e21/hooks/context-engine.js). Latest non-merge change to the first cited path: [734da63220](https://github.com/REPOZY/superpowers-optimized/commit/734da63220eee6738240288f1e99a58d903c698f).


#### F22. Searchable solved-problem knowledge with deduplication

**Adopt concept** · [alexanderop/superpowers](https://github.com/alexanderop/superpowers)

Captures verified solutions under docs/solutions with searchable frontmatter and an index; related entries can be updated rather than duplicated.

**Recommendation:** Strong portable addition. Use one writer and small retrieval results; reduce the default three-agent research overhead for simple captures.

**Evidence:** [skills/compound/SKILL.md](https://github.com/alexanderop/superpowers/blob/0743b48cc31f3830f52fd2f3527144d8c32eec0e/skills/compound/SKILL.md); [hooks/index-solutions](https://github.com/alexanderop/superpowers/blob/0743b48cc31f3830f52fd2f3527144d8c32eec0e/hooks/index-solutions); [hooks/inject-solutions-index](https://github.com/alexanderop/superpowers/blob/0743b48cc31f3830f52fd2f3527144d8c32eec0e/hooks/inject-solutions-index). Latest non-merge change to the first cited path: [d7dac7b11c](https://github.com/alexanderop/superpowers/commit/d7dac7b11c30c099f0998e07d581663179b19cfa).


#### F23. Decision lineage for future sessions

**Adopt concept** · [micahstubbs/superpowers](https://github.com/micahstubbs/superpowers)

Records architectural decisions, rejected alternatives, affected areas, and tags in a durable decision log.

**Recommendation:** Prevent repeated debate and contradictory redesigns. Combine with an existing ADR practice rather than maintaining a second authoritative decision database.

**Evidence:** [skills/knowledge-lineages/SKILL.md](https://github.com/micahstubbs/superpowers/blob/fcf3a38cc16c3b195089778dc0569ff058d99f2f/skills/knowledge-lineages/SKILL.md). Latest non-merge change to the first cited path: [d8976a2ec7](https://github.com/micahstubbs/superpowers/commit/d8976a2ec7606ae2e4fd97fe283f3a4d02952f39).


#### F24. Standalone structured session handoff

**Adapt** · [b0o/superpowers](https://github.com/b0o/superpowers)

Extracts handoff into a reusable skill and template for restoring exact state in a fresh session.

**Recommendation:** Include goal, approved scope, evidence, branch/SHA, next action and blockers. Its checklimits tool/context assumptions are environment-specific; use host signals where available.

**Evidence:** [skills/session-handoff/SKILL.md](https://github.com/b0o/superpowers/blob/b867911ff44a6faaab79175c7f6c7f5e435a7774/skills/session-handoff/SKILL.md); [skills/session-handoff/handoff-template.md](https://github.com/b0o/superpowers/blob/b867911ff44a6faaab79175c7f6c7f5e435a7774/skills/session-handoff/handoff-template.md). Latest non-merge change to the first cited path: [3e5c470c94](https://github.com/b0o/superpowers/commit/3e5c470c948521070d84a49f8e98deb985406e71).


#### F25. Handoff creation/restoration and compounded learning

**Adapt** · [lucianghinda/superpowers-ruby](https://github.com/lucianghinda/superpowers-ruby)

Adds named handoffs, restoration hooks, and refreshable accumulated learning alongside domain skills.

**Recommendation:** Reusable outside Ruby if paths and tools are generalized. Deduplicate against the chosen handoff and solutions system.

**Evidence:** [skills/handoff/SKILL.md](https://github.com/lucianghinda/superpowers-ruby/blob/99fac3d8bee27bab20b23d4bef6fa634738a59e8/skills/handoff/SKILL.md); [hooks/handoff-create](https://github.com/lucianghinda/superpowers-ruby/blob/99fac3d8bee27bab20b23d4bef6fa634738a59e8/hooks/handoff-create); [skills/compound-refresh/SKILL.md](https://github.com/lucianghinda/superpowers-ruby/blob/99fac3d8bee27bab20b23d4bef6fa634738a59e8/skills/compound-refresh/SKILL.md). Latest non-merge change to the first cited path: [88b466b918](https://github.com/lucianghinda/superpowers-ruby/commit/88b466b9187e09d1541faba6d0cd70d00b1c72bb).


#### F26. Canonical domain glossary reconciled with code

**Adopt concept** · [owittek/stateful-superpowers](https://github.com/owittek/stateful-superpowers)

Builds or extends CONTEXT.md from cited project terms, preserving existing human choices and surfacing conflicts.

**Recommendation:** Useful for vocabulary drift in larger projects. Make it opt-in, concise and linked to actual code rather than a generic programming glossary.

**Evidence:** [skills/syncing-context/SKILL.md](https://github.com/owittek/stateful-superpowers/blob/6cda0d56bfee231455073b7ee0a68b3a9ee51653/skills/syncing-context/SKILL.md). Latest non-merge change to the first cited path: [4b0e104ae7](https://github.com/owittek/stateful-superpowers/commit/4b0e104ae7b94153dbf7f4eecc13bde9f632d538).


#### F27. Tree-sitter repository map with token budget

**Adapt** · [Interstellar-code/stellar-powers](https://github.com/Interstellar-code/stellar-powers)

Provides cached symbol mapping and dependency-oriented ranking within a configurable context budget.

**Recommendation:** Potentially valuable for large repositories. Confirm parser/license coverage and invalidation; prefer paths supplied by the host over hardcoded plugin-cache searches and automatic dependency installation.

**Evidence:** [skills/code-indexer/SKILL.md](https://github.com/Interstellar-code/stellar-powers/blob/a7750d187ae05f39f490269f9363f9b9f5c95d86/skills/code-indexer/SKILL.md); [skills/code-indexer/scripts/repomap.py](https://github.com/Interstellar-code/stellar-powers/blob/a7750d187ae05f39f490269f9363f9b9f5c95d86/skills/code-indexer/scripts/repomap.py). Latest non-merge change to the first cited path: [6042eee2a5](https://github.com/Interstellar-code/stellar-powers/commit/6042eee2a5bab0366f4b88e66fe0a647270b92d2).


#### F28. Source-grounded retrospective on user corrections

**Adopt concept** · [dgafka/superpowers](https://github.com/dgafka/superpowers)

Uses recent work and specific user corrections to propose skill/process improvements.

**Recommendation:** Capture improvements only when there was real friction. Keep edits reviewable and avoid automatically changing future behavior from every conversational correction.

**Evidence:** [skills/recognize-and-learn/SKILL.md](https://github.com/dgafka/superpowers/blob/c67194924eda645ce9c3878c84813012996b24c7/skills/recognize-and-learn/SKILL.md). Latest non-merge change to the first cited path: [45f14582a1](https://github.com/dgafka/superpowers/commit/45f14582a1dea6554047899f7f3e752b63e5abdd).


#### F29. Automatically classify and catalog correction patterns

**Experiment** · [josuerf/superpowers](https://github.com/josuerf/superpowers)

Detects correction phrases, invokes a classifier, and queries a pattern catalog before saving learned patterns.

**Recommendation:** Promising but heavier than a Markdown solutions store. Check real hook registration, classification false positives, private conversation retention, and shell-safe argument handling before enabling.

**Evidence:** [hooks/capture-hook.js](https://github.com/josuerf/superpowers/blob/b0bbdbb98cf6cc12251b5bac193a6e3fbeeffcd4/hooks/capture-hook.js); [hooks/capture-classifier.js](https://github.com/josuerf/superpowers/blob/b0bbdbb98cf6cc12251b5bac193a6e3fbeeffcd4/hooks/capture-classifier.js). Latest non-merge change to the first cited path: [039f58fcd6](https://github.com/josuerf/superpowers/commit/039f58fcd63c612d95458b277bf78d492aa194a8).


#### F30. Spec reconciliation versus new scope

**Adapt** · [HumanBean17/superpowers](https://github.com/HumanBean17/superpowers)

Separates reconciling documentation with built behavior from evolving scope; uses snapshots and explicit spec lifecycle states.

**Recommendation:** Useful for long-running work. Keep approved scope intact and implement only the delta; simplify the status ceremony for smaller projects.

**Evidence:** [skills/spec-update/SKILL.md](https://github.com/HumanBean17/superpowers/blob/b10a756bee39f49070e315f6dd62c64398f90aa8/skills/spec-update/SKILL.md). Latest non-merge change to the first cited path: [b10a756bee](https://github.com/HumanBean17/superpowers/commit/b10a756bee39f49070e315f6dd62c64398f90aa8).


#### F31. Living capability specs and behavior deltas

**Adopt concept** · [jackscan/superpowers](https://github.com/jackscan/superpowers)

Adds opt-in ADDED/MODIFIED/REMOVED/RENAMED behavior deltas with scenarios and folds them into canonical capability specs on completion.

**Recommendation:** A strong option if docs already describe current behavior. A pure refactor needs no delta; define when an unmerged change becomes canonical.

**Evidence:** [skills/writing-spec-deltas/SKILL.md](https://github.com/jackscan/superpowers/blob/4be9ea293387e5cac6196bd0e7cca532d4f5484e/skills/writing-spec-deltas/SKILL.md); [skills/syncing-specs/SKILL.md](https://github.com/jackscan/superpowers/blob/4be9ea293387e5cac6196bd0e7cca532d4f5484e/skills/syncing-specs/SKILL.md). Latest non-merge change to the first cited path: [ff558f12b2](https://github.com/jackscan/superpowers/commit/ff558f12b2745f70e2d1128e3acc95d2fc1a07a7).


### Quality, verification and evaluations


#### F32. Same-class defect scan after a bugfix

**Adopt** · [bigbadmn-sys/superpowers](https://github.com/bigbadmn-sys/superpowers)

Requires checking sibling call sites sharing a broken lock, transaction, connection, or exception-handling pattern before claiming the bug is fixed.

**Recommendation:** Small, high-value patch. Scope to the evidenced defect class and touched subsystem rather than demanding an unlimited repository scan.

**Evidence:** [skills/verification-before-completion/SKILL.md](https://github.com/bigbadmn-sys/superpowers/blob/ea9e70f1d9db92729aaf2593d2e340038ab96fa2/skills/verification-before-completion/SKILL.md). Latest non-merge change to the first cited path: [b959d70cf8](https://github.com/bigbadmn-sys/superpowers/commit/b959d70cf85a8fc7609acdae4a396983ac5fa4c2).


#### F33. Verify the flagged call site and exact analysis rule

**Adopt** · [bigbadmn-sys/superpowers](https://github.com/bigbadmn-sys/superpowers)

Distinguishes fixing the actual flagged trigger from adding equivalent mitigation elsewhere that leaves a static-analysis finding unresolved.

**Recommendation:** A good addition to code-review response rules. Record both the substantive fix and whether the original analyzer/reproducer now clears.

**Evidence:** [skills/receiving-code-review/SKILL.md](https://github.com/bigbadmn-sys/superpowers/blob/ea9e70f1d9db92729aaf2593d2e340038ab96fa2/skills/receiving-code-review/SKILL.md). Latest non-merge change to the first cited path: [b959d70cf8](https://github.com/bigbadmn-sys/superpowers/commit/b959d70cf85a8fc7609acdae4a396983ac5fa4c2).


#### F34. Characterization tests before uncertain legacy refactors

**Adopt concept** · [micahstubbs/superpowers](https://github.com/micahstubbs/superpowers)

Captures observed behavior of poorly understood code before changing it.

**Recommendation:** Add as a narrowly triggered companion to TDD. Label intentional existing bugs; characterization must not silently make broken behavior a permanent requirement.

**Evidence:** [skills/characterization-testing/SKILL.md](https://github.com/micahstubbs/superpowers/blob/fcf3a38cc16c3b195089778dc0569ff058d99f2f/skills/characterization-testing/SKILL.md). Latest non-merge change to the first cited path: [d8976a2ec7](https://github.com/micahstubbs/superpowers/commit/d8976a2ec7606ae2e4fd97fe283f3a4d02952f39).


#### F35. Incremental replacement rather than large rewrites

**Adopt concept** · [micahstubbs/superpowers](https://github.com/micahstubbs/superpowers)

Defines seams and staged coexistence for replacing legacy features.

**Recommendation:** Useful when migration risk warrants it. Avoid an abstraction layer for a simple small refactor; keep rollback and compatibility scenarios explicit.

**Evidence:** [skills/strangler-fig-pattern/SKILL.md](https://github.com/micahstubbs/superpowers/blob/fcf3a38cc16c3b195089778dc0569ff058d99f2f/skills/strangler-fig-pattern/SKILL.md). Latest non-merge change to the first cited path: [b16ab29299](https://github.com/micahstubbs/superpowers/commit/b16ab292997367cac75514e8b17bd3fb640f3520).


#### F36. Verification scope proportional to the change

**Adapt** · [REPOZY/superpowers-optimized](https://github.com/REPOZY/superpowers-optimized)

Defines targeted verification for local changes and broader suites for shared contracts, dependencies, build configuration and cross-subsystem changes.

**Recommendation:** Take the scope decision table and honest unrun-suite reporting. Reconcile with upstream covering-test rules; do not weaken required project CI checks.

**Evidence:** [skills/verification-before-completion/SKILL.md](https://github.com/REPOZY/superpowers-optimized/blob/38e85b92383e7d18afe4a59cc681c9caa9479e21/skills/verification-before-completion/SKILL.md). Latest non-merge change to the first cited path: [296162741d](https://github.com/REPOZY/superpowers-optimized/commit/296162741db1bcc0111774c48df440b6b8d49f78).


#### F37. Typed verification harness with completeness and drift modes

**Experiment** · [josuerf/superpowers](https://github.com/josuerf/superpowers)

Defines local/full/security/completeness/dead-code checks and spec-versus-implementation reports.

**Recommendation:** Evaluate one deterministic gate at a time. Semantic completeness and drift judgments remain fallible; inspect executable validators before treating a PASS as proof.

**Evidence:** [skills/harness-verify/SKILL.md](https://github.com/josuerf/superpowers/blob/b0bbdbb98cf6cc12251b5bac193a6e3fbeeffcd4/skills/harness-verify/SKILL.md); [tools/harness/cli.ts](https://github.com/josuerf/superpowers/blob/b0bbdbb98cf6cc12251b5bac193a6e3fbeeffcd4/tools/harness/cli.ts). Latest non-merge change to the first cited path: [939be961de](https://github.com/josuerf/superpowers/commit/939be961de34d3d92ec9146c48bbe76dc5cd8c96).


#### F38. Skill baseline/effectiveness/trigger evaluation toolkit

**Adopt concept** · [cuongnbms/superpowers](https://github.com/cuongnbms/superpowers)

Expands skill creation into baseline runs, graded comparisons, iteration, an output viewer, and should/should-not-trigger tests.

**Recommendation:** Prioritize this before importing many skills. Adapted tooling has Apache-2.0 attribution separate from the project MIT license; retain notices. Do not copy the instruction to uninstall another plugin automatically.

**Evidence:** [skills/writing-skills/SKILL.md](https://github.com/cuongnbms/superpowers/blob/46fa412cd0a276500872933cea7d6dfa1d0edff4/skills/writing-skills/SKILL.md); [skills/writing-skills/references/eval-workflow.md](https://github.com/cuongnbms/superpowers/blob/46fa412cd0a276500872933cea7d6dfa1d0edff4/skills/writing-skills/references/eval-workflow.md). Latest non-merge change to the first cited path: [5536f7da4a](https://github.com/cuongnbms/superpowers/commit/5536f7da4a4d082ffc525ccb9ac50624d50e0af4).


#### F39. Lightweight local telemetry segmented by turn and skill

**Adapt** · [tackyto/superpowers](https://github.com/tackyto/superpowers)

Reads new transcript segments at Stop/SubagentStop and appends local records; identifies each transcript separately and avoids stdout interference.

**Recommendation:** Useful for measuring actual overhead. Make opt-in and bounded, inspect stored fields, and keep observation failures from blocking work.

**Evidence:** [hooks/custom/telemetry.py](https://github.com/tackyto/superpowers/blob/0993667516a528f016606f9285a599c724ca5ded/hooks/custom/telemetry.py); [hooks/custom/telemetry_lib/store.py](https://github.com/tackyto/superpowers/blob/0993667516a528f016606f9285a599c724ca5ded/hooks/custom/telemetry_lib/store.py). Latest non-merge change to the first cited path: [3e6c857c77](https://github.com/tackyto/superpowers/commit/3e6c857c775efb42679d9091634e90290f81fea8).


#### F40. Successful-output compression with raw failure fallback

**Experiment** · [REPOZY/superpowers-optimized](https://github.com/REPOZY/superpowers-optimized)

Compresses recognized successful command outputs while retaining raw failures, stderr, exit status and an explicit compression marker.

**Recommendation:** Evaluate recoverability and semantic preservation before adoption. Keep raw output available, bypass scripts/searches where output itself is the result, and verify the hook contract on each host.

**Evidence:** [hooks/compression-rules.js](https://github.com/REPOZY/superpowers-optimized/blob/38e85b92383e7d18afe4a59cc681c9caa9479e21/hooks/compression-rules.js); [hooks/bash-optimizer.js](https://github.com/REPOZY/superpowers-optimized/blob/38e85b92383e7d18afe4a59cc681c9caa9479e21/hooks/bash-optimizer.js). Latest non-merge change to the first cited path: [fdd0bfebf5](https://github.com/REPOZY/superpowers-optimized/commit/fdd0bfebf56ab1b20f220b2a2f68a524319be935).


#### F41. Configurable dangerous-command and secret guards

**Optional** · [REPOZY/superpowers-optimized](https://github.com/REPOZY/superpowers-optimized)

Adds regex-based policy levels for hazardous commands, sensitive file access and hardcoded credentials.

**Recommendation:** Defense-in-depth only. Test false positives, alternate shells, encodings and quoting; these regexes are not an OWASP certification or a complete security boundary.

**Evidence:** [hooks/safety/block-dangerous-commands.js](https://github.com/REPOZY/superpowers-optimized/blob/38e85b92383e7d18afe4a59cc681c9caa9479e21/hooks/safety/block-dangerous-commands.js); [hooks/safety/protect-secrets.js](https://github.com/REPOZY/superpowers-optimized/blob/38e85b92383e7d18afe4a59cc681c9caa9479e21/hooks/safety/protect-secrets.js). Latest non-merge change to the first cited path: [91a37d64b9](https://github.com/REPOZY/superpowers-optimized/commit/91a37d64b9437ef157bf6d00604460c6b3e2a730).


#### F42. Separate adversarial reviewer role

**Optional** · [REPOZY/superpowers-optimized](https://github.com/REPOZY/superpowers-optimized)

Ships an explicit adversarial review role and a native Codex agent configuration.

**Recommendation:** Use for risky interfaces, authentication or deployment changes. Keep findings reproducible and bounded; do not automatically launch a second expensive review for every small change.

**Evidence:** [agents/red-team.md](https://github.com/REPOZY/superpowers-optimized/blob/38e85b92383e7d18afe4a59cc681c9caa9479e21/agents/red-team.md); [codex-agents/red-team.toml](https://github.com/REPOZY/superpowers-optimized/blob/38e85b92383e7d18afe4a59cc681c9caa9479e21/codex-agents/red-team.toml). Latest non-merge change to the first cited path: [ee6152fc6b](https://github.com/REPOZY/superpowers-optimized/commit/ee6152fc6bee9a015fdcfbbfc6bdc70182614a49).


#### F43. Measured performance investigation

**Adopt concept** · [REPOZY/superpowers-optimized](https://github.com/REPOZY/superpowers-optimized)

Adds a dedicated measure/profile/fix/re-measure workflow rather than guessing at performance fixes.

**Recommendation:** Useful generic skill. Require representative workloads and retain measurement conditions; do not import blanket speed claims.

**Evidence:** [skills/performance-investigation/SKILL.md](https://github.com/REPOZY/superpowers-optimized/blob/38e85b92383e7d18afe4a59cc681c9caa9479e21/skills/performance-investigation/SKILL.md). Latest non-merge change to the first cited path: [0a78a70002](https://github.com/REPOZY/superpowers-optimized/commit/0a78a7000266c48901067960eaf0f1d2b33e2532).


#### F44. Dependency and failure-recovery playbooks

**Adapt** · [REPOZY/superpowers-optimized](https://github.com/REPOZY/superpowers-optimized)

Adds dedicated triggers and procedures for dependency changes and recovery from failed approaches.

**Recommendation:** Use focused procedures for lockfiles, compatibility, rollback and evidence. Avoid an always-on instruction expansion if existing project rules already cover it.

**Evidence:** [skills/dependency-management/SKILL.md](https://github.com/REPOZY/superpowers-optimized/blob/38e85b92383e7d18afe4a59cc681c9caa9479e21/skills/dependency-management/SKILL.md); [skills/error-recovery/SKILL.md](https://github.com/REPOZY/superpowers-optimized/blob/38e85b92383e7d18afe4a59cc681c9caa9479e21/skills/error-recovery/SKILL.md). Latest non-merge change to the first cited path: [ae16bf3728](https://github.com/REPOZY/superpowers-optimized/commit/ae16bf3728512c110513092c01d56069694efda3).


### Maintenance and host support


#### F45. Fork-specific extension directory and divergence register

**Adopt** · [tackyto/superpowers](https://github.com/tackyto/superpowers)

Keeps new hooks in a fork-owned directory and records divergence; limits edits to shared hook registries.

**Recommendation:** One of the best maintenance ideas. New files avoid content conflicts, but shared registration and behavior can still conflict; keep an explicit extension inventory.

**Evidence:** [hooks/custom/README.md](https://github.com/tackyto/superpowers/blob/0993667516a528f016606f9285a599c724ca5ded/hooks/custom/README.md); [docs/fork/DIVERGENCE.md](https://github.com/tackyto/superpowers/blob/0993667516a528f016606f9285a599c724ca5ded/docs/fork/DIVERGENCE.md). Latest non-merge change to the first cited path: [3835c104ae](https://github.com/tackyto/superpowers/commit/3835c104aea04c076bae3d85f4e42a2bfbc90132).


#### F46. Thin Codex-specific overlay and regression surface

**Adapt** · [smallocean43658/codex-superpowers](https://github.com/smallocean43658/codex-superpowers)

Documents a deliberately small Codex overlay and checks stale tool/prompt assumptions rather than carrying broad old workflow rewrites.

**Recommendation:** A useful maintenance pattern. Current upstream already has Codex support and file handoffs; port only demonstrated gaps, and map to tools actually exposed by the active Codex version.

**Evidence:** [CODEX_OPTIMIZATIONS.md](https://github.com/smallocean43658/codex-superpowers/blob/48aba461a6405bb8f1a568dabb37bcf9a0db4f46/CODEX_OPTIMIZATIONS.md); [tests/codex/test-codex-fork-overlay.sh](https://github.com/smallocean43658/codex-superpowers/blob/48aba461a6405bb8f1a568dabb37bcf9a0db4f46/tests/codex/test-codex-fork-overlay.sh). Latest non-merge change to the first cited path: [cf38301cfd](https://github.com/smallocean43658/codex-superpowers/commit/cf38301cfd9f7ce4ee4f5a0aabf279efc978f5f0).


#### F47. Zed tool reference

**Optional** · [zed-industries/superpowers](https://github.com/zed-industries/superpowers)

Adds a Zed-specific tool mapping reference with minimal divergence.

**Recommendation:** Worth considering only if your fork targets Zed; validate current capabilities before advertising integration.

**Evidence:** [skills/using-superpowers/references/zed-tools.md](https://github.com/zed-industries/superpowers/blob/ac082fac785e8f042fe8eea7b8f1d88bddb7e35b/skills/using-superpowers/references/zed-tools.md). Latest non-merge change to the first cited path: [ac082fac78](https://github.com/zed-industries/superpowers/commit/ac082fac785e8f042fe8eea7b8f1d88bddb7e35b).


#### F48. Gemini subagent orchestration polyfill

**Optional** · [vladivis/superpowers](https://github.com/vladivis/superpowers)

Implements a Gemini-specific orchestration adaptation rather than merely adding install prose.

**Recommendation:** Inspect the supporting Gemini scripts in the source catalog. Gemini is already supported upstream; adopt only a concrete missing orchestration capability and preserve honest fallback behavior.

**Evidence:** [skills/using-superpowers/references/gemini-tools.md](https://github.com/vladivis/superpowers/blob/990aea0770a461e52369212886240234a955c39f/skills/using-superpowers/references/gemini-tools.md). Latest non-merge change to the first cited path: [990aea0770](https://github.com/vladivis/superpowers/commit/990aea0770a461e52369212886240234a955c39f).


#### F49. VS Code Copilot custom agents

**Optional** · [marikkan-microsoft/copilot-superpowers](https://github.com/marikkan-microsoft/copilot-superpowers)

Adapts the workflow for VS Code skills and custom agents.

**Recommendation:** Differentiate VS Code Copilot from upstream Copilot CLI support. Port the agent frontmatter and supported tool mapping selectively; do not copy obsolete two-reviewer workflow instructions wholesale.

**Evidence:** [COPILOT-README.md](https://github.com/marikkan-microsoft/copilot-superpowers/blob/697fb7312deb4ed507db90fd798eebf1c5f69ea4/COPILOT-README.md); [.github/agents/superpowers-orchestrator.agent.md](https://github.com/marikkan-microsoft/copilot-superpowers/blob/697fb7312deb4ed507db90fd798eebf1c5f69ea4/.github/agents/superpowers-orchestrator.agent.md). Latest non-merge change to the first cited path: [6e24709227](https://github.com/marikkan-microsoft/copilot-superpowers/commit/6e247092270458117c08e5f558ed818211245b88).


### Domain extensions and further leads


#### F50. SQLite development databases in isolated worktrees

**Adapt** · [lucianghinda/superpowers-ruby](https://github.com/lucianghinda/superpowers-ruby)

Provides Rails SQLite worktree setup with WAL checkpointing, sidecar copying and backups before overwrite.

**Recommendation:** Useful even outside Rails after generalization. A checkpoint-plus-copy is not proof of a consistent snapshot under concurrent writes; prefer a verified SQLite backup mechanism and unique backup names.

**Evidence:** [skills/using-sqlite-worktrees/SKILL.md](https://github.com/lucianghinda/superpowers-ruby/blob/99fac3d8bee27bab20b23d4bef6fa634738a59e8/skills/using-sqlite-worktrees/SKILL.md); [skills/using-sqlite-worktrees/scripts/create_sqlite_worktree.rb](https://github.com/lucianghinda/superpowers-ruby/blob/99fac3d8bee27bab20b23d4bef6fa634738a59e8/skills/using-sqlite-worktrees/scripts/create_sqlite_worktree.rb). Latest non-merge change to the first cited path: [9b361808e9](https://github.com/lucianghinda/superpowers-ruby/commit/9b361808e979a391fdd69fb4f9e1c2ba6ef004de).


#### F51. Rails conventions injected into workflow

**Optional** · [fryga-io/superpowers-rails](https://github.com/fryga-io/superpowers-rails)

Adds role-specific Rails conventions and a hook-integrated conventions layer.

**Recommendation:** Good evidence for domain packs as separate extensions. Keep Rails-only instructions conditional; loading all conventions for every task may add needless context.

**Evidence:** [hooks/rails-conventions.sh](https://github.com/fryga-io/superpowers-rails/blob/8a784957544b9a4f49a150ef316f137132eef58f/hooks/rails-conventions.sh); [skills/rails-migration-conventions/SKILL.md](https://github.com/fryga-io/superpowers-rails/blob/8a784957544b9a4f49a150ef316f137132eef58f/skills/rails-migration-conventions/SKILL.md). Latest non-merge change to the first cited path: [33ce070292](https://github.com/fryga-io/superpowers-rails/commit/33ce0702929117dde9d428f33680c1bd16f76469).


#### F52. Ruby/Rails upgrades, security scanning, and reference packs

**Optional** · [lucianghinda/superpowers-ruby](https://github.com/lucianghinda/superpowers-ruby)

Adds version migration guidance, scanner workflows, Ruby practices and substantial Rails/Hotwire references.

**Recommendation:** Strong domain-specific additions, not universal core features. Verify version facts against current official docs before use; keep references progressively loaded.

**Evidence:** [skills/rails-upgrade/SKILL.md](https://github.com/lucianghinda/superpowers-ruby/blob/99fac3d8bee27bab20b23d4bef6fa634738a59e8/skills/rails-upgrade/SKILL.md); [skills/brakeman/SKILL.md](https://github.com/lucianghinda/superpowers-ruby/blob/99fac3d8bee27bab20b23d4bef6fa634738a59e8/skills/brakeman/SKILL.md); [skills/ruby-upgrade/SKILL.md](https://github.com/lucianghinda/superpowers-ruby/blob/99fac3d8bee27bab20b23d4bef6fa634738a59e8/skills/ruby-upgrade/SKILL.md). Latest non-merge change to the first cited path: [552250a2d5](https://github.com/lucianghinda/superpowers-ruby/commit/552250a2d574090e73c13beec0638fd9439a196a).


#### F53. ML research loop with immutable evaluator

**Optional** · [qqhard/superpowers-ML](https://github.com/qqhard/superpowers-ML)

Defines a supervisor/researcher loop with a predeclared evaluator, fixed/variable files, experience records, resume state and iteration limits.

**Recommendation:** Borrow evaluator separation for any optimization loop. Enforce file permissions mechanically and bound compute; its scheduled monitoring is Claude-specific, not a portable timer guarantee.

**Evidence:** [skills/autoresearch/SKILL.md](https://github.com/qqhard/superpowers-ML/blob/eb489567cfcd343795a9d81cfdfec9432b52ec75/skills/autoresearch/SKILL.md); [skills/_ml-loop-primitives/eval-lock.md](https://github.com/qqhard/superpowers-ML/blob/eb489567cfcd343795a9d81cfdfec9432b52ec75/skills/_ml-loop-primitives/eval-lock.md). Latest non-merge change to the first cited path: [eb489567cf](https://github.com/qqhard/superpowers-ML/commit/eb489567cfcd343795a9d81cfdfec9432b52ec75).


#### F54. ML runtime validation and profiling toolkit

**Optional** · [qqhard/superpowers-ML](https://github.com/qqhard/superpowers-ML)

Adds progressive ML validation and GPU/training profiling support beyond normal unit-test workflows.

**Recommendation:** Useful only for ML workloads. Inspect actual metrics, hardware support and reproducibility before treating profiling output as authoritative.

**Evidence:** [skills/ml-runtime-validator/SKILL.md](https://github.com/qqhard/superpowers-ML/blob/eb489567cfcd343795a9d81cfdfec9432b52ec75/skills/ml-runtime-validator/SKILL.md); [toolkit/profiling/mfu_calculator.py](https://github.com/qqhard/superpowers-ML/blob/eb489567cfcd343795a9d81cfdfec9432b52ec75/toolkit/profiling/mfu_calculator.py). Latest non-merge change to the first cited path: [05f0aca9e8](https://github.com/qqhard/superpowers-ML/commit/05f0aca9e818bb14a235477fb532402f876cf148).


#### F55. Experiment reproduction and paper-to-code workflow

**Optional** · [ShunyangLiu/superpowers_DL](https://github.com/ShunyangLiu/superpowers_DL)

Specializes work around paper interpretation, experimental evidence, reproducibility and result analysis.

**Recommendation:** Keep in an ML extension. Experimental evidence has different success criteria from ordinary web-app tests.

**Evidence:** [skills/paper-to-implementation/SKILL.md](https://github.com/ShunyangLiu/superpowers_DL/blob/4d2921304d5a49f4aee0b201cc0870ba441dbc73/skills/paper-to-implementation/SKILL.md); [skills/reproducibility-check/SKILL.md](https://github.com/ShunyangLiu/superpowers_DL/blob/4d2921304d5a49f4aee0b201cc0870ba441dbc73/skills/reproducibility-check/SKILL.md). Latest non-merge change to the first cited path: [3edf99c96b](https://github.com/ShunyangLiu/superpowers_DL/commit/3edf99c96b54f4a293fcb5c45d949e595602edbe).


#### F56. Dataset-sharing experiment worktrees and cleanup guardrails

**Optional** · [ShunyangLiu/superpowers_DL](https://github.com/ShunyangLiu/superpowers_DL)

Shares large datasets through links, records experiment start state and addresses safe experiment cleanup.

**Recommendation:** Adapt the metadata and cleanup contract; use read-only shared data where possible. Never apply POSIX deletion recipes to Windows without checking resolved targets and link semantics.

**Evidence:** [skills/experiment-worktree/SKILL.md](https://github.com/ShunyangLiu/superpowers_DL/blob/4d2921304d5a49f4aee0b201cc0870ba441dbc73/skills/experiment-worktree/SKILL.md); [skills/finishing-experiment-branch/SKILL.md](https://github.com/ShunyangLiu/superpowers_DL/blob/4d2921304d5a49f4aee0b201cc0870ba441dbc73/skills/finishing-experiment-branch/SKILL.md). Latest non-merge change to the first cited path: [b1153289f7](https://github.com/ShunyangLiu/superpowers_DL/commit/b1153289f708d925e2d05fc62b2e3ffc93c463a8).


#### F57. Laravel/Sail/monorepo workflow pack

**Optional** · [eznix86/superpowers-laravel](https://github.com/eznix86/superpowers-laravel)

Adds Laravel-specific development, testing, environment and complexity skills; commit history includes multi-app/monorepo support.

**Recommendation:** Use only for Laravel projects. Several scanned forks share this change set, so treat them as one family rather than independent feature discoveries.

**Evidence:** [skills/e2e-playwright/SKILL.md](https://github.com/eznix86/superpowers-laravel/blob/0526577e7341565426f96ff94a15655beace0453/skills/e2e-playwright/SKILL.md); [skills/complexity-guardrails/SKILL.md](https://github.com/eznix86/superpowers-laravel/blob/0526577e7341565426f96ff94a15655beace0453/skills/complexity-guardrails/SKILL.md). Latest non-merge change to the first cited path: [62f64d0060](https://github.com/eznix86/superpowers-laravel/commit/62f64d00607ca090502481a8bdb53897500ed413).


#### F58. GridGain/Ignite concurrency and review patterns

**Optional** · [gridgain/ggcoder](https://github.com/gridgain/ggcoder)

Adds specialized reviews for concurrency, cleanup, async operations and compatibility in Java distributed systems.

**Recommendation:** Extract the subject-specific checklist if relevant. Treat examples as review material, not universally safe code; validate against the actual memory model and framework.

**Evidence:** [skills/concurrency-patterns/SKILL.md](https://github.com/gridgain/ggcoder/blob/3e814bf99967d563d3d9517592911fbdb4b5d058/skills/concurrency-patterns/SKILL.md); [skills/review-pr/SKILL.md](https://github.com/gridgain/ggcoder/blob/3e814bf99967d563d3d9517592911fbdb4b5d058/skills/review-pr/SKILL.md). Latest non-merge change to the first cited path: [719b179f9c](https://github.com/gridgain/ggcoder/commit/719b179f9c37d00d93eaffa577f0e3eb9baa88e5).


#### F59. SAP CAP/UI5/BTP skills

**Optional** · [abhaskar27/sapsuperpowers](https://github.com/abhaskar27/sapsuperpowers)

Adds domain packs for SAP service authorization, modeling, deployment and UI/testing.

**Recommendation:** A useful specialization model; skip the content if your fork does not target SAP.

**Evidence:** [skills/cap-authorization/SKILL.md](https://github.com/abhaskar27/sapsuperpowers/blob/f842e25a7115b2e9c557a0201c663c8261b583cc/skills/cap-authorization/SKILL.md); [skills/btp-deployment/SKILL.md](https://github.com/abhaskar27/sapsuperpowers/blob/f842e25a7115b2e9c557a0201c663c8261b583cc/skills/btp-deployment/SKILL.md). Latest non-merge change to the first cited path: [29988cfbcf](https://github.com/abhaskar27/sapsuperpowers/commit/29988cfbcf48688d37f11664ccf9c30b922a8353).


#### F60. Zephyr/Cortex-M debugging and embedded TDD

**Optional** · [toonst/superpowers-embedded](https://github.com/toonst/superpowers-embedded)

Adds firmware fault interpretation, device configuration, driver development and hardware-aware testing guidance.

**Recommendation:** Keep as an embedded extension with explicit hardware/tool prerequisites. No firmware or board validation was performed in this audit.

**Evidence:** [skills/cortex-m-fault-diagnosis/SKILL.md](https://github.com/toonst/superpowers-embedded/blob/c4c8993cb17140a0b4fb30f9cc7af5ce096aabaa/skills/cortex-m-fault-diagnosis/SKILL.md); [skills/embedded-tdd/SKILL.md](https://github.com/toonst/superpowers-embedded/blob/c4c8993cb17140a0b4fb30f9cc7af5ce096aabaa/skills/embedded-tdd/SKILL.md). Latest non-merge change to the first cited path: [cc8a7dde36](https://github.com/toonst/superpowers-embedded/commit/cc8a7dde36fd72d7c6b0b54c9e1166c0a9442616).


#### F61. Robotics field, control, localization, and audit skills

**Optional** · [RedEarth-Robotics/robotics-superpowers](https://github.com/RedEarth-Robotics/robotics-superpowers)

Adds robotics discipline roles including field engineering and C++ safety-oriented review material.

**Recommendation:** Consider only for robotics work. Skill names do not demonstrate MISRA compliance or safe real-world control behavior.

**Evidence:** [skills/robotics-field-engineer/SKILL.md](https://github.com/RedEarth-Robotics/robotics-superpowers/blob/fd27c66d4e861082215e3ddd78e9aa43d69116cc/skills/robotics-field-engineer/SKILL.md); [skills/cpp-misra-auditor/SKILL.md](https://github.com/RedEarth-Robotics/robotics-superpowers/blob/fd27c66d4e861082215e3ddd78e9aa43d69116cc/skills/cpp-misra-auditor/SKILL.md). Latest non-merge change to the first cited path: [4d7b2236e8](https://github.com/RedEarth-Robotics/robotics-superpowers/commit/4d7b2236e8dfe217c7b3197f143ec96052522fc8).


#### F62. Requirements traceability and lifecycle evidence templates

**Optional** · [adam-schneider-dev/superpowers-nasa-swe](https://github.com/adam-schneider-dev/superpowers-nasa-swe)

Generates scoped requirements mapping artifacts and lifecycle records from a bundled catalog.

**Recommendation:** The transferable idea is requirement-to-evidence traceability. This audit did not validate NASA standards interpretation or compliance; keep regulated-domain claims outside a generic fork.

**Evidence:** [skills/requirements-matrix/SKILL.md](https://github.com/adam-schneider-dev/superpowers-nasa-swe/blob/2ffba33ba59280ba27472687aee8f475ad41a701/skills/requirements-matrix/SKILL.md); [skills/requirements-matrix/scripts/filter_matrix.py](https://github.com/adam-schneider-dev/superpowers-nasa-swe/blob/2ffba33ba59280ba27472687aee8f475ad41a701/skills/requirements-matrix/scripts/filter_matrix.py). Latest non-merge change to the first cited path: [3a14a8b251](https://github.com/adam-schneider-dev/superpowers-nasa-swe/commit/3a14a8b2511057343e86c617dff64cff751f12e0).


#### F63. Bounded E2E quality and failure classification

**Adopt concept** · [Nimbou/nimbou-skills](https://github.com/Nimbou/nimbou-skills)

Scopes an audit to one flow and distinguishes test, environment, product and mixed failures before changing code or assertions.

**Recommendation:** Useful beyond Nuxt/NestJS. Remove hardcoded framework versions if porting; prohibit hiding failures with arbitrary sleeps, retries or weaker assertions.

**Evidence:** [plugins/nimbou-skills/skills/e2e-test-quality/SKILL.md](https://github.com/Nimbou/nimbou-skills/blob/685ae2213325f8d676dcfdae8de21bfa2c68da82/plugins/nimbou-skills/skills/e2e-test-quality/SKILL.md). Latest non-merge change to the first cited path: [08882ebe1e](https://github.com/Nimbou/nimbou-skills/commit/08882ebe1e2bf820a278cc670a332d3f95d5eb77).


#### F64. Contract documentation from a shared domain model

**Optional** · [Nimbou/nimbou-skills](https://github.com/Nimbou/nimbou-skills)

Adds coordinated domain scenario and API documentation skills alongside framework-specific plans.

**Recommendation:** Good for teams with contract drift. Select one canonical source and validate generated contracts; do not add redundant document layers by default.

**Evidence:** [plugins/nimbou-skills/skills/doc-gherkin/SKILL.md](https://github.com/Nimbou/nimbou-skills/blob/685ae2213325f8d676dcfdae8de21bfa2c68da82/plugins/nimbou-skills/skills/doc-gherkin/SKILL.md); [plugins/nimbou-skills/skills/doc-openapi/SKILL.md](https://github.com/Nimbou/nimbou-skills/blob/685ae2213325f8d676dcfdae8de21bfa2c68da82/plugins/nimbou-skills/skills/doc-openapi/SKILL.md). Latest non-merge change to the first cited path: [08882ebe1e](https://github.com/Nimbou/nimbou-skills/commit/08882ebe1e2bf820a278cc670a332d3f95d5eb77).


#### F65. Explicit trust-boundary and staged-migration playbooks

**Adapt** · [natthamon-suphon/all-about-agents](https://github.com/natthamon-suphon/all-about-agents)

Adds scoped security and compatibility-transition workflows with observable evidence, abort/recovery paths and ownership.

**Recommendation:** Useful separate skills for risky changes. Version, topology and operational assumptions must be verified in the target project before execution.

**Evidence:** [core/skills/threat-modeling-and-security/SKILL.md](https://github.com/natthamon-suphon/all-about-agents/blob/50d92f30ca9314673d5fd46a98f891eb713374b1/core/skills/threat-modeling-and-security/SKILL.md); [core/skills/zero-downtime-migrations/SKILL.md](https://github.com/natthamon-suphon/all-about-agents/blob/50d92f30ca9314673d5fd46a98f891eb713374b1/core/skills/zero-downtime-migrations/SKILL.md). Latest non-merge change to the first cited path: [43f18bacc2](https://github.com/natthamon-suphon/all-about-agents/commit/43f18bacc28220e491ef913fa0cc2bcc82fd6402).


#### F66. Provider-neutral two-tier model selection

**Optional** · [cuongnbms/superpowers](https://github.com/cuongnbms/superpowers)

Reworks model selection into a smaller tier scheme with harness-specific mappings, alongside evaluation cases.

**Recommendation:** Model selection itself is upstream. Consider only the mapping/config simplification; use currently available models and host policy rather than frozen names.

**Evidence:** [skills/subagent-driven-development/SKILL.md](https://github.com/cuongnbms/superpowers/blob/46fa412cd0a276500872933cea7d6dfa1d0edff4/skills/subagent-driven-development/SKILL.md); [skills/using-superpowers/references/codex-tools.md](https://github.com/cuongnbms/superpowers/blob/46fa412cd0a276500872933cea7d6dfa1d0edff4/skills/using-superpowers/references/codex-tools.md). Latest non-merge change to the first cited path: [3b00798fda](https://github.com/cuongnbms/superpowers/commit/3b00798fdab28f7fa4400949d6bbff1afbe9051f).


#### F67. Configured agent-tier floor guard

**Optional** · [dami-laare/superpowers-on-steroids](https://github.com/dami-laare/superpowers-on-steroids)

Adds a Claude dispatch guard for configured agent tiers, with platform exclusions and fail-open parsing.

**Recommendation:** Compare with pcvelz before choosing one implementation. Do not maintain two independent routing guards or mistake a fail-open hook for mandatory cost control.

**Evidence:** [hooks/agent-tier-gate](https://github.com/dami-laare/superpowers-on-steroids/blob/c0659db7d3782d15522157d11cc12b7786cf6ae4/hooks/agent-tier-gate); [hooks/lib-config](https://github.com/dami-laare/superpowers-on-steroids/blob/c0659db7d3782d15522157d11cc12b7786cf6ae4/hooks/lib-config). Latest non-merge change to the first cited path: [ac17b3cdcd](https://github.com/dami-laare/superpowers-on-steroids/commit/ac17b3cdcdcadb6b8a1d1c527245d22aa2d35235).


#### F68. Broader roadmap and QA workflow skills

**Optional** · [evepupil/superpowers-yeton-ver](https://github.com/evepupil/superpowers-yeton-ver)

Adds roadmap management/execution and distinct QA risk/test-design skills.

**Recommendation:** Useful if your fork serves product planning as well as coding. Avoid redundant authority between a roadmap skill and external issue trackers.

**Evidence:** [skills/managing-project-roadmap/SKILL.md](https://github.com/evepupil/superpowers-yeton-ver/blob/15ac8f9b0aa34d6a85aac8cef8c5e37ac2ca4c0e/skills/managing-project-roadmap/SKILL.md); [skills/qa-risk-review/SKILL.md](https://github.com/evepupil/superpowers-yeton-ver/blob/15ac8f9b0aa34d6a85aac8cef8c5e37ac2ca4c0e/skills/qa-risk-review/SKILL.md). Latest non-merge change to the first cited path: [1ae4142142](https://github.com/evepupil/superpowers-yeton-ver/commit/1ae4142142e528c2fac613bcca29c5a3840dbb8c).


#### F69. Portable noncoding knowledge-work bundle

**Optional / separate product** · [fastxyz/normalpowers](https://github.com/fastxyz/normalpowers)

Repurposes the skills for general knowledge work and distribution through prompt/system-instruction surfaces.

**Recommendation:** A separate product direction, not an upgrade to software execution. Do not import the removal of TDD, worktrees and coding orchestration into a coding fork.

**Evidence:** [README.md](https://github.com/fastxyz/normalpowers/blob/dec68a3c5b500d3ec22fcf3d930d4749bf766a55/README.md); [skills/systematic-problem-solving/SKILL.md](https://github.com/fastxyz/normalpowers/blob/dec68a3c5b500d3ec22fcf3d930d4749bf766a55/skills/systematic-problem-solving/SKILL.md). Latest non-merge change to the first cited path: [dec68a3c5b](https://github.com/fastxyz/normalpowers/commit/dec68a3c5b500d3ec22fcf3d930d4749bf766a55).


#### F70. Fastmemory/Bun integration

**Experiment** · [FastBuilderAI/superfast](https://github.com/FastBuilderAI/superfast)

Adds memory-backend integration and a Bun execution preference.

**Recommendation:** Check whether external memory and a runtime mandate solve a real problem. Benchmark and SOTA marketing were not validated; a small repository-local store is a simpler starting point.

**Evidence:** [skills/fastmemory/SKILL.md](https://github.com/FastBuilderAI/superfast/blob/cbb17676d1d5bf829845b44848b2f7b222076d74/skills/fastmemory/SKILL.md); [skills/bun-execution/SKILL.md](https://github.com/FastBuilderAI/superfast/blob/cbb17676d1d5bf829845b44848b2f7b222076d74/skills/bun-execution/SKILL.md). Latest non-merge change to the first cited path: [0ad31fdc01](https://github.com/FastBuilderAI/superfast/commit/0ad31fdc014bb2e345ba337ff600595d515adec5).


#### F71. OpenSpec/team/memory workflow bundle outside shared Git ancestry

**Supplemental lead** · [SYZ-Coder/superpowers-openspec-team-skills](https://github.com/SYZ-Coder/superpowers-openspec-team-skills)

Provides explicit opt-in workflow packs with optional conversation/project memory. The fetched default head had no merge base with the pinned upstream.

**Recommendation:** Useful design reference, not a verified incremental Git fork patch. Assess pack activation and memory isolation separately; do not present zero diff output as an unchanged mirror.

**Evidence:** [README.md](https://github.com/SYZ-Coder/superpowers-openspec-team-skills/blob/1426ddcb85f203c7de8a13b5d1ba4cfd188fb265/README.md); [MEMORY.md](https://github.com/SYZ-Coder/superpowers-openspec-team-skills/blob/1426ddcb85f203c7de8a13b5d1ba4cfd188fb265/MEMORY.md). Latest non-merge change to the first cited path: [1426ddcb85](https://github.com/SYZ-Coder/superpowers-openspec-team-skills/commit/1426ddcb85f203c7de8a13b5d1ba4cfd188fb265).


#### F72. Timestamp-only activity inflation

**Skip** · [mwakidenis/superpowers](https://github.com/mwakidenis/superpowers)

The fork-only changes comprise a timestamp workflow and its output file; its thousands of ahead commits are timestamp updates.

**Recommendation:** Skip for enhancement selection. Activity and ahead counts measure history, not feature value; the workflow does not synchronize upstream.

**Evidence:** [.github/workflows/main.yml](https://github.com/mwakidenis/superpowers/blob/e74c88c571a7234cc3607e4dd5249da5fe9f2f01/.github/workflows/main.yml); [updates.txt](https://github.com/mwakidenis/superpowers/blob/e74c88c571a7234cc3607e4dd5249da5fe9f2f01/updates.txt). Latest non-merge change to the first cited path: [63561745cb](https://github.com/mwakidenis/superpowers/commit/63561745cb25a86e345cf02d7c1cf599cbf1cc1c).


## Already in current upstream: do not count these as unique fork features

| Claim encountered | Current upstream evidence | Consequence |
| --- | --- | --- |
| Scaled brainstorming | `skills/brainstorming/SKILL.md`: spike, bounded and architectural paths | Judge a fork on its actual approval/direct-execution differences |
| Cheaper inline execution | `skills/executing-plans/SKILL.md` | A renamed Native mode alone adds little |
| Task right-sizing and leaner plans | `skills/writing-plans/SKILL.md` | Vertical slice format can add value; generic task decomposition is not new |
| Durable plan state | `scripts/sdd-workspace`, `task-brief` under SDD and per-plan ledgers | Beads and memory packs must add something beyond persistence |
| Combined task review, scoped fix reviews and bounded loops | SDD task reviewer, re-review prompt and review-package script | Avoid restoring obsolete separate per-task spec and quality reviewers blindly |
| Model selection by task and review role | `skills/subagent-driven-development/SKILL.md` | Configurable enforcement is a delta; model selection in principle is not |
| Existing isolated worktree recognition | `skills/using-git-worktrees/SKILL.md` | Check specific database/data/container setup gaps instead |
| Codex, Gemini, Pi, Hermes, Antigravity and several other hosts | README, manifests and tool references | Old installation adaptations alone may now be redundant |
| Windows polyglot hook dispatch and visual companion hardening | `hooks/run-hook.cmd`, `docs/windows/polyglot-hooks.md`, brainstorming scripts | Preserve the current upstream fixes when porting old fork changes |
| Session diagnosis and issue-report support | `skills/diagnosing-superpowers/` | Prefer extending existing diagnostics to duplicating a generic diagnostic skill |

All entries above refer to the pinned upstream tree, not a fork README's comparison table.

## Skip, defer, or narrow aggressively

- **Timestamp churn:** mwakidenis/superpowers has thousands of timestamp commits and two fork-only files. Skip it for enhancement mining.
- **Default-branch mirrors and stale unchanged copies:** the 108 identical and 2,195 behind-only comparison results are low priority. This classification says nothing about unexamined nondefault branches.
- **Rebrands, translated READMEs and install prose:** useful for distribution/localization goals, but not workflow innovations. Translation quality was not audited. Repository renames alone should never justify a port.
- **Duplicate feature families:** the Laravel pack appears across multiple repositories, and the optimized memory/hooks family appears in downstream forks. Prefer an actively maintained, well-attributed source rather than counting each copy as a discovery. The appendix groups matching API changed-file signatures as a screening aid.
- **Unsupported superiority claims:** do not adopt claims of SOTA, guaranteed token savings, hallucination resistance or security compliance without controlled measurements. Fastmemory/Bun and optimized hook claims are experiments, not audit-proven outcomes.
- **Blanket expensive gates:** mandatory multiple model consultations, five-pass reviews above a fixed line count, whole-suite runs for every edit, or mandatory agent teams can erase any productivity benefit. Make them risk-triggered and measure cost.
- **Automatic self-modification:** correction-driven learning can preserve a misunderstood preference or untrusted input. Keep provenance, scopes, expiry and a reviewable change path.
- **Bundled binaries and pipe-to-shell installers:** source listings are not provenance checks. BryanHoo's wrapper binaries and container/memory installation recipes need a separate review before use. Nothing was installed here.
- **Global runtime, container or database mandates:** do not make Bun, Docker, beads or Rails assumptions requirements of a generic fork.
- **Prompt priority overrides:** never import a skill's assertion that it outranks the human, host policy, or required authorization. Preserve genuine destructive/security/external-publication boundaries while eliminating redundant permission questions.
- **Personal application code and local configuration:** some large forks add unrelated apps, private workflow conventions or third-party caches. High repository size is a discovery signal only; such additions are not automatically Superpowers enhancements.
- **Large rewrites with unclear ancestry:** keep detached workflow bundles as design references until their license, provenance and compatibility are established. A failed comparison is not a usable cherry-pick list.

## Porting approach

1. Record the actual base SHA and supported hosts of your own fork. Keep current upstream fixes and original license notices.
2. Create fork-owned additions (`skills/<new-skill>/`, `hooks/custom/`, host references) and a divergence register. Limit shared-file changes to a small router/registration patch.
3. Pick **one** durable task authority, **one** memory store and **one** model-routing contract. Define adapters around them instead of competing ledgers and duplicate hooks.
4. Start with source-level concepts F01, F03, F22, F24, F32 and F33. Add evaluations before enabling autonomous learning, compression, provider calls or mandatory review loops.
5. Evaluate on actual target hosts using representative task prompts: trivial fix, substantive design, unexpected failure, parallel ownership conflict, compaction/resume, malformed configuration, missing provider and a negative/nontrigger case. Record quality, wall time, tool/model calls and cost where observable.
6. Keep each accepted enhancement independently disableable. Prefer small commits that cite the original source and explain the demonstrated target-project need.

## Companion artifacts

- [Full selected-fork screening and divergent candidate evidence](superpowers-fork-screening.md): all 2,930 selected results, full unresolved errors, changed-file signatures and detailed evidence for every divergent default.
- [Pinned source catalog](superpowers-source-catalog.md): inspected repositories, SHAs, ancestry notes, locally measured changed-file counts and file links.
- [Complete returned fork metadata inventory](superpowers-fork-inventory.csv): all 26,385 distinct public records used for candidate selection.

The report is a recommendation and evidence archive. No changes were made to the user's Superpowers fork or any remote repository.
