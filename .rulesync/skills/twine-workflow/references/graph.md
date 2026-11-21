# Graph stage

The coordinator loads this reference when this stage is needed and supplies only the assigned prompt, applicable ownership, and review requirements to each worker. Resolve artifact paths from the repository root.

## Prompt 3 — Generate the Tactical Graph DSL from the Brief
Use the Brief to emit only the Structurizr DSL for `SCENE_ID`.

Fresh runs use Prompt 3. If the `SCENE_ID` block exists, invoke it explicitly with `override=true`; use Prompt 5 only for a requested refactor.

Suggested prompt:
```text
Using the `tactical-gen` skill, the Scene Brief at `docs/briefs/{SCENE_ID}.json`, and the header conventions in `docs/workspace.dsl`, generate ONLY the Structurizr DSL for `SCENE_ID`.

Enforce (see the `tactical-gen` skill — single source of truth):
- Descriptions 100–200 chars; complete sentences; anchor quotas.
- Non‑verbal actions only. Labels: `Act: ...` and `timer` only; ≥6 distinct verbs.
- Apply the Quality checks (hard requirements) for authored passage and Game Over counts and unconditional user-choice death paths.
- Apply Timer & Respawn rules and Development boundaries.
- Early Game Over pacing: follow `Early Game Over pacing` in the `tactical-gen` skill.
- First-run scope: follow `First-run scope` in the `tactical-gen` skill.
- Survival/risk posture: follow `Supportive listener posture` in the `tactical-gen` skill.
- GO narrative semantics: follow `Game Over meaning` in the `tactical-gen` skill.
- GO respawn policy: GO → respawn (regular passage) → P01; direct GO→P01 disallowed.
- Use `visited(...)` sparingly (1–2 unlocks), reachable within 1–2 iterations.
- Integer stat deltas; clamp [0,100]; spikes ≤20 only directly before GO.
- Preserve steady pacing: early failure should accelerate discovery, and respawn routing should quickly return the player to meaningful decision points.
- Cross‑scene handoff: follow the Cross‑scene handoff policy in the `tactical-gen` skill.
- Object‑intro passages: follow the Object‑intro passages policy in the `tactical-gen` skill.

Output the `cNN { sNN { ... } }` DSL block for `SCENE_ID`, and write the required handoff for a developed continuing scene. Follow Cross-scene handoff and Development boundaries in the `tactical-gen` skill: a planned undeveloped successor gets a minimal declared `Passage-Stub` entry; an explicitly final scene gets no successor handoff. Do not invent successors. Report created or remaining WIP scene IDs.

Run `structurizr validate -w docs/workspace.dsl` for DSL syntax validation. If only the legacy CLI is installed, use `structurizr-cli validate -w docs/workspace.dsl` and report which command ran. Check the exit code and diagnostic output; separate warnings from validation errors. This does not replace state/reachability or scene-constraint checks.
```

Invocation: Execute Prompt 3 for `SCENE_ID`. To regenerate an existing scene, use: "Execute Prompt 3 for `SCENE_ID` override=true".

## Prompt 4 — Independently audit the Tactical Graph
Run a read-only validation pass. Return confirmed violations to the Prompt 3 or Prompt 5 author for repair and a fresh re-audit.

Suggested prompt:
```text
Audit the `SCENE_ID` block in `docs/workspace.dsl` against the `tactical-gen` skill and the Scene Brief at `docs/briefs/{SCENE_ID}.json`. Report findings only; all files are read-only. Include the scene-constraint verification supplied in the coordinator task packet.

Checks: see these sections in the `tactical-gen` skill:
- Quality checks (hard requirements).
- Timer & Respawn rules. Verify guard coverage and exclusivity in reachable states after each passage's effects.
- Development boundaries (WIP placeholders and endings): distinguish marked WIP and ending stops from accidental dead-ends, and exclude placeholder-only successors from full-scene gameplay checks.
- Adaptive Threshold Policy (anger/stress).
- Cross‑scene handoff policy (canonical).
- Object‑intro passages (procedural).
- Supportive listener posture and Game Over meaning.
If any referenced policy fails, propose a minimal correction for the owning author. Proposed scope is the `SCENE_ID` block and its required handoff; only minimal missing successor declarations permitted by Development boundaries may be proposed outside it. Preserve component IDs and existing successor content, and avoid extra nodes unless a rule requires them. Do not edit the DSL.

Output:
1) Violations (bullets)
2) Minimal proposed corrections, scene-constraint results with reachability evidence, optional suggestions, and limitations (no applied edits)
```

Invocation: Execute Prompt 4 for `SCENE_ID`.

## Prompt 5 — Refactor existing scene (optional)
Use this when updating an existing graph without adding unnecessary nodes.

Suggested prompt:
```text
Transform the `SCENE_ID` block in `docs/workspace.dsl` to comply with the `tactical-gen` skill and the Scene Brief:

Inputs (read by path; do not paste contents):
- `docs/workspace.dsl` (use block for `SCENE_ID`)
- `docs/briefs/{SCENE_ID}.json`

Tasks:
- Replace any speech‑like actions (e.g., "Act: Ask about her") with non‑verbal, object‑anchored actions from the Brief.
- Apply Quality checks (hard requirements), Timer & Respawn rules, and Development boundaries from `tactical-gen`.
- Ensure the scene still satisfies `Early Game Over pacing` and `First-run scope` from the `tactical-gen` skill.
- Align survivable and risky branches with `Supportive listener posture` in the `tactical-gen` skill.
- If multiple deaths are semantically redundant, revise them to satisfy `Game Over meaning` in the `tactical-gen` skill.
- Enforce 100–200 char descriptions and anchor quotas; keep node IDs stable; don’t bloat node count.
Output ONLY the updated DSL block.
```

Invocation: Execute Prompt 5 for `SCENE_ID` when needed.
