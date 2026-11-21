# Twee stage

The coordinator loads this reference when this stage is needed and supplies only the assigned prompt, applicable ownership, and review requirements to each worker. Resolve artifact paths from the repository root.

## Prompt 6 — Generate Twee from the Tactical Graph
Convert the validated tactical graph into SugarCube v2 Twee passages for the specified scene.

Suggested prompt:
```text
Using the `twee-gen` skill, read the scene graph for `SCENE_ID` from `docs/workspace.dsl` and generate the corresponding SugarCube v2 Twee passages.

Inputs (read by path; do not paste contents):
- `docs/workspace.dsl` (use `SCENE_ID`)
- `src/main.twee` (macros and globals)
- `docs/sugarcube-2_docs/` (reference only)

Follow the rules in the `twee-gen` skill. Respect passage IDs and cross-refs defined in `docs/workspace.dsl`.
Implement GO fan‑out on GO passages: GO shows conditional links to respawn targets (regular passages) using the same conditions as the DSL (e.g., `visited(...)`). Do not include any Restart link. Respawn passages route to default entry (e.g., `c01.s01.P01`) via their own timers.

Create or replace `src/{SCENE_ID}.twee` with ONLY Twee passages:
- from the currently specified scene.
- connecting into the next scene.
  - For each cross‑scene handoff present in the DSL, add exactly one handoff from its source passage to the designated next scene.
  - Mirror the DSL edge label and condition: if `"timer"`, use a timed auto‑advance; if `"Act: X"`, add a user link labeled `X`; include any conditions (e.g., `Anger`/`Stress` thresholds) in SugarCube conditionals.
  - Cross‑scene handoffs MAY use `timer`, but prefer `Act: ...` when meaningful player agency exists.
  - Target ID mapping and Twee passage naming: follow the canonical title mapping in the `twee-gen` skill: `cNN.sNN.pNN_<kind>` → `cNN.sNN.PNN`, preserving dots and using the component's uppercase passage-name. Apply it to declarations, links, timed transitions, visit checks, handoffs, and stubs; preserve existing image asset paths.
  - Stub lifecycle: follow the `twee-gen` skill. Search all `src/*.twee` declarations first; reuse real targets or an existing exact-title stub. Only when a declared DSL target has no Twee definition, add one `[stub]` in this file with explicit WIP/To be continued text, no state changes, and no outgoing links or timer. Never invent a missing DSL target. When developing the target scene, preserve its title and incoming links and remove superseded tagged stubs, including an embedded stub in a predecessor file; leave other passages untouched.
  - Monologue expansion: authored non-GO, non-stub passages include at least one narrator line and an unrestricted, immersive Leon monologue (multiple `.dialogue` paragraphs as needed), grounded in anchors from `docs/Plot-Device.md`. Game Overs may be brief; Leon's dialogue is optional. They require a clear consequence, narrative value under the shared narrative rules, and visible DSL-mapped Respawn links. Stubs are exempt; render declared intentional endings as `[ending]` passages without onward progression.
  - State lifecycle: follow the `twee-gen` skill. `StoryInit` initializes fresh-game defaults; `Start` only routes to the default entry without resetting state. Each contextual respawn applies `stress = floor(stress / 2)` and `anger = 0` exactly once, preserving visit history, replay discoveries, and other globals. Entry passages apply normal effects without reinitialization. GO passages expose respawn links without performing resets. Reuse existing globals; change shared initialization only when the requested feature requires it.
```

Invocation: Execute Prompt 6 for `SCENE_ID`.

## Prompt 7 — Independently verify Twee against the Tactical Graph
Ensure the generated Twee branches in `src/{SCENE_ID}.twee` exactly correspond to affecting & effecting relationships for `SCENE_ID`'s graph in `docs/workspace.dsl`. Report mismatches for the Prompt 6 author to repair; report source-of-truth conflicts with `docs/Plot-Device.md`. All files are read-only during this audit.

Suggested prompt:
```text
Audit `src/{SCENE_ID}.twee` against:
- the `twee-gen` skill
- the `tactical-gen` skill's graph-validation rules (read-only)
- `docs/workspace.dsl` (scene: `SCENE_ID`)
- `docs/Plot-Device.md`

Include applicable scene constraints from `docs/narrative-rules.md` and report their verification explicitly. Requests below to add, render, or remove content are requirements to check and propose to the author; do not apply edits.

Important:
DSL & Sugarcube syntax is intentionally different. Focus only on logical differences.

Tasks:
1) Build an adjacency list for `SCENE_ID` (components and edges with labels & conditions).
2) Parse `src/{SCENE_ID}.twee` and extract passage links and timed progressions.
3) Enforce the mapping rules from Prompt 6:
   - Scope: the file contains ONLY passages for the specified scene plus connections into the next scene.
   - Verify exactly one matching transition for every scene-to-scene relationship in the DSL, including handoffs within a chapter. Check the source, destination, label, and guard.
   - Edge modality: mirror DSL edge labels and conditions — if "timer", use a timed auto‑advance; if "Act: X", use a user link labeled X; include any `Anger`/`Stress` thresholds via SugarCube conditionals.
   - Target ID mapping: use the same canonical title mapping as Prompt 6 (the `twee-gen` skill): `cNN.sNN.pNN_<kind>` → `cNN.sNN.PNN`. Check declarations, links, timed transitions, visit checks, handoffs, and stubs; leave already-valid titles and existing image asset paths unchanged.
   - Stub lifecycle: each declared target resolves to exactly one real passage or `[stub]` across all `src/*.twee` files. Stubs show explicit WIP/To be continued text, contain no state changes or onward links/timer, and cannot hide missing DSL declarations or graph errors. Prefer real content and remove superseded/duplicate tagged stubs only; report conflicting real definitions. List remaining WIP targets separately from errors and completed content.
4) Dialogue expansion checks:
   - Each authored non-GO passage contains substantive, multi-line Leon monologue (not a single-sentence body); length is not capped. Prefer `.dialogue` paragraphs. `[stub]` passages are exempt; declared `[ending]` passages may stop without choices or timers.
   - GO passages include a consequence line and visible Respawn links only (no Restart).
5) Compare both graphs:
   - Missing or extra passages or edges
   - Label mismatches (`Act: ...`), timer presence, and conditions (`Stress`/`Anger` thresholds)
   - Game Over targets and counts
   - Exact stat effects per passage, including delta values, assignments, clamping, and respawn resets. Check that effects are applied before evaluating outgoing guards.
   - Exactly one timer is active in every reachable state of passages that require a timer, and its destination matches the enabled DSL edge.
   - ID format and cross‑ref mapping correctness
   - Handoff presence/count and stub existence/tagging
   - If a requested feature changes `src/main.twee`, audit the shared diff and verify that only the required shared behavior changes.
6) Source-of-truth policy:
   - If `src/{SCENE_ID}.twee` deviates from `docs/workspace.dsl`, prefer the DSL and propose a Twee correction to its author.
   - If the DSL is invalid, incomplete, or contradicts `docs/Plot-Device.md` themes or anchors, follow Phase ownership: report affected IDs and propose minimal DSL edits without applying them. A matching Twee diff may be proposed, but do not apply speculative changes to affected branches or claim full verification before the graph correction is authorized and applied in the graph phase.

Output:
1) Violations (bullets) grouped by type (structure, labels, timers, conditions, stats, ids/handoffs/stubs)
2) Proposed corrections for affected passages, scene-constraint results, optional suggestions, and limitations (no applied edits)
```

Invocation: Execute Prompt 7 for `SCENE_ID`.

## Build and playtest assessment

After Prompt 7 and any repairs pass, compile using the repository's Tweego build tooling. Inspect the build command before running it. Record the command, compiler version, exit status, and output location. If the bundled compiler cannot run on the host architecture, use an available compatible Tweego executable or report the missing prerequisite. Report a blocked build or browser check explicitly.

Play the compiled SugarCube output in an available browser or browser automation tool. Derive representative paths from the approved graph and applicable scene constraints. Check visible choices and guards, timed transitions, stat changes, visit-dependent unlocks, contextual respawn resets, and the handoff or intentional ending. Check for rendered macro errors and broken passage links. Mark undeveloped successor stubs as WIP.

When a requested feature changes `src/main.twee`, exercise the affected shared behavior in the preview.

For `c01.s01`, exercise each Game Over independently with the other unvisited, verify continuation after each, and verify that a no-death route keeps continuation locked. Exercise timer-only play for accidental deaths. Check that respawn halves Stress and clears Anger once, preserves visit history, and returns through ordinary entry effects. These are target-scene checks derived from `docs/narrative-rules.md` and the state lifecycle contract.

Assess dialogue tone and pacing against the scene's canon and narrative rules along first-visit, revisit, and respawn paths. Consider Leon's current state, repeated text, whether emotional shifts feel earned, and whether timer durations permit reading and choice. Distinguish observations from subjective suggestions. Report accelerated timer checks separately from real-time pacing observations.

Return technical outcomes with the paths exercised, tone/pacing observations with affected passages, and verification limits. Present the playable output for the user's own assessment. Route confirmed implementation failures through author repair and fresh Prompt 7 review, then rerun affected build/playtest checks. Respect the coordinator's two-round repair limit. Human creative preferences guide the next requested iteration.
