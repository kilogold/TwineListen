---
name: twine-workflow
description: Coordinate scene brief, tactical graph, and Twee generation with fresh author/reviewer subagents, bounded repairs, a human graph checkpoint, and playtest assessment. Use for coordinated scene generation, graph revision, or continuation from an approved graph in TwineListen.
targets:
  - '*'
---

# Twine workflow coordinator

Coordinate one target scene at a time using the installed `tactical-gen` and `twee-gen` skills. Resolve artifact paths from the repository root and Markdown links relative to this file. Locate code by passage or symbol name. Read domain skill instructions when needed through the available skill catalog.

## Invocation and progression

Resolve the `SCENE_ID` (`cNN.sNN`), operation, and requested endpoint from the request. Use the active workspace by default. When given a specific checkout, use its root for artifact paths and worker commands and load its installed skills and role profiles. Ask only for missing information that cannot be inferred.

| Request | Sequence |
| --- | --- |
| `$twine-workflow generate c01.s01` | Fresh brief (1), audit (2), fresh graph (3), audit (4), human graph checkpoint |
| `$twine-workflow revise c01.s01` with requested changes | Refactor graph (5) using the current brief, audit (4), human graph checkpoint |
| Approve the graph and request dialogue | Twee (6), audit (7), build and playtest assessment |
| Execute a specific Prompt N for a scene | Honor the requested task and endpoint, using the matching role and ownership below |

A fresh run overwrites `docs/briefs/{SCENE_ID}.json` from canon and constraints, then regenerates the target graph. Explicitly pass `override=true` to Prompt 3 when the scene already exists. Preserve unrelated scenes, existing successor content, and boundary IDs required by incoming handoffs. Use prior output only to resolve required boundaries, never as the creative template. Git supplies version history.

Prompt 5 preserves an existing graph while applying requested changes. Expanding a placeholder-only scene is also normal refactoring, preserving its entry ID and incoming handoffs and removing the stub marker. If the brief needs changes, run the brief stage and audit before the graph stage. A fresh rewrite request uses Prompts 1–4 instead.

Run brief and graph work, including their repair loops, automatically through Prompt 4. Present the candidate graph, scene-constraint verdicts, remaining findings, and meaningful changes, then stop for the user to choose a fresh rewrite, targeted revision, or continuation to dialogue. Every revised graph returns through Prompt 4 and this checkpoint. An audit PASS alone does not approve the narrative experience. A full-workflow request still pauses here unless the user explicitly waives the checkpoint. Honor earlier requested endpoints and stop sooner for unresolved hard conflicts.

## Stage references and roles

Load only the reference needed for the current stage. Prompt numbers remain stable for individual task invocation and role mapping.

| Reference | Prompt | Generated role profile in `.codex/agents/` |
| --- | --- | --- |
| [Brief](references/brief.md) | 1 | `twine-brief-author.toml` |
| [Brief](references/brief.md) | 2 | `twine-brief-reviewer.toml` |
| [Graph](references/graph.md) | 3 or 5 | `twine-graph-author.toml` |
| [Graph](references/graph.md) | 4 | `twine-graph-reviewer.toml` |
| [Twee and playtest](references/twee.md) | 6 | `twine-twee-author.toml` |
| [Twee and playtest](references/twee.md) | 7 | `twine-twee-reviewer.toml` |

Launch the matching named role with its scoped task packet. If the launch interface exposes explicit model and effort parameters instead, read the matching generated profile and pass both `model` and `model_reasoning_effort`, including its role instructions in the packet. Maintain each role's description and instructions in `.rulesync/subagents/twine-*.md`, with Codex model and effort settings in its `codexcli` frontmatter section. Run `rulesync generate` after editing the source profiles. Report unavailable roles, models, effort settings, or context isolation before proceeding.

## Context and delegation

Launch each initial prompt task and every audit/re-audit in a fresh subagent context. In a harness with `fork_turns`, use `fork_turns="none"`. Give workers their assigned prompt, scene and parameters, role instructions, applicable ownership, relevant installed domain skills, canonical source paths, and shared narrative rules plus the target scene's constraints. Supply referenced requirements needed to execute the assignment. Do not copy the coordinator conversation or other workers' history, or require workers to read this entire skill or every prompt.

Read `docs/narrative-rules.md` for all stages. Authored hard constraints take precedence over optional heuristics. Constraints survive regeneration and are neither extra Scene Brief fields nor plot-anchor sources. The AI sequences content within those constraints. Both graph and dialogue phases read shared player-agency rules without invoking the other phase's generation instructions.

Reference artifacts by path rather than pasting snapshots. Briefs contain only their defined JSON schema. All persisted DSL belongs in `docs/workspace.dsl`. When discussing snapshots with a user, keep them out of brief files.

## Ownership

| Prompt | Allowed writes |
| --- | --- |
| 1 and its repairs | `docs/briefs/{SCENE_ID}.json` |
| 2, 4, 7 | Read-only review |
| 3, 5 and their repairs | Target scene and required model-scope handoff in `docs/workspace.dsl`, plus only missing successor chapter/scene/entry declarations permitted by `tactical-gen` Development boundaries |
| 6 and its repairs | `src/{SCENE_ID}.twee`, including allowed handoff stubs, plus removal of exact-title `[stub]` passages in other scene files when superseded or duplicated, preserving all other content |

Graph authors preserve unrelated scenes and existing successor content. Twee authors treat the DSL, brief, plot sources, and shared narrative rules as read-only. Reuse `src/main.twee`; shared-code edits require a requested feature that needs them under the `twee-gen` State lifecycle contract.

Graph defects found during Prompts 6–7 require a report identifying affected IDs and a proposed minimal DSL correction. Continue unblocked content when useful, identify incomplete output, and avoid inventing graph semantics or claiming verification of affected branches. Apply corrections in a separately requested graph phase. If graph repair and Twee are already authorized, perform the graph phase first and return to the human graph checkpoint unless it was explicitly waived.

## Review and repairs

Reviewers independently inspect current artifacts and canonical requirements. Keep their tasks read-only. Exclude author reasoning, self-verification claims, and prior audit verdicts from their packets. Every review and re-audit uses the matching reviewer profile in a new context.

Require each reviewer to report applicable scene constraints as PASS, FAIL, or NOT VERIFIED with evidence. Brief review may defer graph-dependent reachability. Graph review must provide paths and state/visit evidence. Twee review must check equivalent implementation behavior. Parser/compiler success alone does not establish narrative or runtime correctness.

Group findings into confirmed violations (rule, affected field/ID/edge, evidence, minimal correction), optional creative suggestions, and limitations. Route confirmed violations to the owning author for minimal repair, preserving passing values and IDs. That author may retain its stage context. Obtain a fresh independent re-audit before advancing. After two unsuccessful repair rounds for a stage, report unresolved findings for discussion. Optional suggestions do not block progression. Report conflicting hard requirements without weakening either or editing source constraints.

Finish each requested endpoint with stage verdicts, checks actually performed, remaining WIP/limitations, and changed paths. Model reviews are evidence-based judgments. For a completed Twee stage, include the build and playtest assessment defined in its reference.

## Maintenance

Edit this package under `.rulesync/skills/twine-workflow/`, then run `rulesync generate` to install the repository skills for Codex and Cursor and the Codex subagent profiles. Maintain domain rules in `.rulesync/skills/tactical-gen/` and `.rulesync/skills/twee-gen/`, narrative constraints in `docs/narrative-rules.md`, and role descriptions, instructions, and model/effort settings in `.rulesync/subagents/twine-*.md`. The generated `.codex/agents/twine-*.toml` files are installation output.
