# Strangers In The Attic
A Twine narrative prototype.

## Key development constraints:
1. The game has only two mechanics: gaze & listen.
2. Focus on emotional storytelling and psychological thriller.
3. Apply principles from "Aesthetics of Play" for narrative content.

## Game features: 
- Player perspective: First-person.
- Single NPC actor: a frail and melancholic elderly man named Leon.
- Player actor: a mysterious humanoid physical entity that keeps respawning.
- Static environment: dark attic setting.
- Core gameplay revolves around careful NPC + environment observation & listening.
- NPC is subject to attack the player if he feels misunderstood, judged, or ignored.
- Game over unlocks new progressive story passages.
- The story has multiple endings based on player interactions & NPC reactions.
- Player only nods and listens.

## LLM generation workflow
As a developer, follow this constrained, multi-step LLM prompting workflow to generate and maintain the tactical plot graph while staying faithful to the rules in `/.cursor/rules/tactical-gen.mdc` and the context in `/docs/Plot-Device.md`.

Parameterization:
- Use a `SCENE_ID` in DSL format `cNN.sNN` (e.g., `c01.s01`).
- Invoke each step with: "Execute Prompt N for `SCENE_ID`" (e.g., "Execute Prompt 1 for `c01.s01`").
- Persist artifacts using `SCENE_ID`:
  - Scene Brief JSON: `docs/briefs/{SCENE_ID}.json` (e.g., `docs/briefs/c01.s01.json`)
  - Twee output: `src/{SCENE_ID}.twee` (e.g., `src/c01.s01.twee`)
 - Existing scenes: if `SCENE_ID` already exists in `/docs/Plot-Graph.dsl`, skip Prompt 3 and run Prompt 5 for `SCENE_ID`, then continue with Prompt 6.

### Prompt 1 — Produce a Scene Brief (JSON only)
Output strict JSON (no prose) capturing anchors, non‑verbal actions, and thresholds for a single scene.

Suggested prompt:
```text
Using `/.cursor/rules/tactical-gen.mdc` and `/docs/Plot-Device.md`, produce a Scene Brief in strict JSON (no prose, no comments) for `SCENE_ID`.

Fields:
{ "chapter": "<chapter-name>", "scene": "<scene-name>", "anchors": [], "actions": [], "thresholds": { "angerHigh": 35, "stressHigh": 60 }, "quotas": { "anchor60": true, "doubleAnchor30": true }, "sourceDocVersion": "", "generatedAt": "" }

Requirements:
- anchors: 8–12 concrete items/phrases copied verbatim from the provided source for the specified chapter/scene only. No inventions. No cross‑chapter items. Prefer physical objects and named nouns; avoid abstractions unless explicitly named. All anchors must be unique and must appear in the source text (exact substring match).
- actions: 10–14 non‑verbal action labels. No speech verbs (ask/say/tell/etc.). Prefer object‑anchored; pronouns allowed when unambiguous. Include 2–3 “touch Leon” variants. Ensure ≥6 distinct verbs and no duplicates.
- thresholds: angerHigh=35, stressHigh=60 for touch-triggered Game Over branching.
- quotas: anchor60 and doubleAnchor30 set true.
- Do NOT add any extra properties. Specifically, do not include any DSL snapshots or large text blobs in the brief; the DSL belongs only in `/docs/Plot-Graph.dsl`.
```

Invocation: Execute Prompt 1 for `SCENE_ID`.

Save the JSON to `docs/briefs/{SCENE_ID}.json` (for versioning). In Cursor, reference this file in later prompts (no pasting).

### Prompt 2 — Audit the Scene Brief JSON (deterministic)
Validate the Scene Brief JSON against required schema and constraints before generating the DSL. If fixes are needed, emit a corrected JSON and use it for the next step.

Suggested prompt (Cursor-friendly):
```text
Audit the Scene Brief at `docs/briefs/{SCENE_ID}.json` against `/.cursor/rules/tactical-gen.mdc` and `/docs/Plot-Device.md`. List violations briefly, then output a corrected, final JSON only.

Only change fields that violate checks; preserve all other values and their order. Do not modify generatedAt or sourceDocVersion if present. Do not reorder arrays. Do not rewrite anchors/actions unless they fail checks.

Checks:
- Fields present: chapter, scene, anchors, actions, thresholds.angerHigh, thresholds.stressHigh, quotas.anchor60, quotas.doubleAnchor30, sourceDocVersion, generatedAt. No extra properties.
- anchors: 8–12 items; unique; copied verbatim as exact substrings from the provided source; scoped to the specified chapter/scene only; no cross‑chapter items; prefer physical objects and named nouns; avoid abstractions unless explicitly named; no inventions.
- actions: 10–14 items; non‑verbal; unique; ≥6 distinct verbs; include 2–3 "touch Leon" variants; no speech verbs (ask/say/tell/etc.). Prefer object‑anchored labels; pronouns allowed when unambiguous.
- thresholds: angerHigh=35, stressHigh=60 (exact values).
- quotas: anchor60=true, doubleAnchor30=true (exact values).
- Strings non‑empty; consistent casing and spelling; no comments or prose.

Output:
1) Violations (bullets)
2) Corrected Scene Brief JSON only (strict JSON; no prose)
```

Invocation: Execute Prompt 2 for `SCENE_ID`.

If corrections were made, update `docs/briefs/{SCENE_ID}.json` with the corrected JSON before proceeding.

### Prompt 3 — Generate the Tactical Graph DSL from the Brief
Use the Brief to emit only the Structurizr DSL for `SCENE_ID`.

Note: If the `SCENE_ID` block already exists in `/docs/Plot-Graph.dsl`, do not regenerate here; execute Prompt 5 for `SCENE_ID` instead.

Suggested prompt (Cursor-friendly):
```text
Using `/.cursor/rules/tactical-gen.mdc`, the Scene Brief at `docs/briefs/{SCENE_ID}.json`, and the header conventions in `/docs/Plot-Graph.dsl`, generate ONLY the Structurizr DSL for `SCENE_ID`.

Enforce:
- Descriptions 100–200 chars; complete sentences; meet anchor quotas (≥60% anchored; ≥30% double-anchored).
- Non‑verbal actions only. Labels: `Act: ...` and `timer` only. Use action labels from the Brief; no duplicates; ≥6 distinct verbs.
- 12–16 components with at least 2 Game Over nodes.
- Every non–GameOver passage has ≥1 outgoing `timer`.
- At least one explicit user‑choice path to Game Over exists; see `/.cursor/rules/tactical-gen.mdc` for the unconditional GO path requirement.
- Use `visited(...)` gates sparingly (1–2 unlocks) and keep reachable in 1–2 iterations.
- Stat deltas: integers, clamp [0,100]; default magnitudes 2..12; spikes up to 20 only when directly preceding GO.
- Touch actions must branch: GO when `Anger > angerHigh` or `Stress > stressHigh`; otherwise continue with reasonable deltas.

Output ONLY the `cNN { sNN { ... } }` DSL block for `SCENE_ID`.

Run the following terminal command for DSL syntax validation: `structurizr-cli validate -w docs/Plot-Graph.dsl`
```

Invocation: Execute Prompt 3 for `SCENE_ID`.

### Prompt 4 — Audit/Fix pass (deterministic)
Run a validation pass and re‑emit a corrected DSL if needed.

Suggested prompt (Cursor-friendly):
```text
Audit the `SCENE_ID` block in `/docs/Plot-Graph.dsl` against `/.cursor/rules/tactical-gen.mdc` and the Scene Brief at `docs/briefs/{SCENE_ID}.json`. List violations briefly, then output a corrected, final DSL block only.

Checks:
- Labels ∈ {Act: …, timer}. Non‑verbal only. No speech verbs.
- Each non–GO passage has ≥1 outgoing timer.
- Action labels unique within scene; ≥6 distinct verbs overall.
- Descriptions 100–200 chars; anchor quotas met.
- Stat deltas: 2..12 defaults; spikes ≤20 only when directly preceding GO; clamp [0,100].
- Touch actions include conditional GO branches using thresholds from the Brief.
- At least one explicit GO path exists; no dead‑ends; gated paths reachable within 1–2 iterations.

Output:
1) Violations (bullets)
2) Corrected DSL block only
```

Invocation: Execute Prompt 4 for `SCENE_ID`.

### Prompt 5 — Refactor existing scene (optional)
Use this when updating an existing graph without adding nodes unnecessarily.

Suggested prompt:
```text
Transform the `SCENE_ID` block in `/docs/Plot-Graph.dsl` to comply with `/.cursor/rules/tactical-gen.mdc` and the Scene Brief:

Inputs (read by path; do not paste contents):
- `/docs/Plot-Graph.dsl` (use block for `SCENE_ID`)
- `docs/briefs/{SCENE_ID}.json`

Tasks:
- Replace any speech‑like actions (e.g., "Act: Ask about her") with non‑verbal, object‑anchored actions from the Brief.
- Ensure every non–GO passage has ≥1 outgoing timer.
- Add conditional branches for any touch actions: GO when `Anger > angerHigh` or `Stress > stressHigh`; otherwise continue with deltas (2..12).
- Enforce 100–200 char descriptions and anchor quotas; keep node IDs stable; don’t bloat node count.
Output ONLY the updated DSL block.
```

Invocation: Execute Prompt 5 for `SCENE_ID` when needed.

### Prompt 6 — Generate Twee from the Plot Graph (Cursor-friendly)
Convert the validated plot graph into SugarCube v2 Twee passages for the specified scene.

Suggested prompt (Cursor-friendly):
```text
Using `/.cursor/rules/twee-gen.mdc`, read the scene graph for `SCENE_ID` from `/docs/Plot-Graph.dsl` and generate the corresponding SugarCube v2 Twee passages.

Inputs (read by path; do not paste contents):
- `/.cursor/rules/twee-gen.mdc`
- `/docs/Plot-Graph.dsl` (use `SCENE_ID`)
- `/src/main.twee` (macros and globals)
- `/docs/sugarcube-2_docs/` (reference only)

Follow the rules in `/.cursor/rules/twee-gen.mdc`. Respect passage IDs and cross-refs defined in `/docs/Plot-Graph.dsl`.

Create or replace `/src/{SCENE_ID}.twee` with ONLY Twee passages:
- from the currently specified scene.
- connecting into the next scene.
  - For each cross‑chapter relationship present in the DSL, add exactly one handoff from its source passage to the designated next scene.
  - Mirror the DSL edge label and condition: if `"timer"`, use a timed auto‑advance; if `"Act: X"`, add a user link labeled `X`; include any conditions (e.g., `Anger`/`Stress` thresholds) in SugarCube conditionals.
  - Target ID mapping and Twee passage naming: see `/.cursor/rules/twee-gen.mdc` (single source of truth).
  - Stub rule: if the target passage does not exist yet, create a stub passage with that exact ID in the same Twee file, tagged `[stub]`, with minimal body; only create the stub if absent.
```

Invocation: Execute Prompt 6 for `SCENE_ID`.

### Prompt 7 — Verify Twee against the Tactical Graph (deterministic)
Ensure the generated Twee branches in `/src/{SCENE_ID}.twee` exactly correspond to affecting & effecting relationships for `SCENE_ID`'s graph in `/docs/Plot-Graph.dsl`. Fix mismatches; report any source-of-truth conflicts with `/docs/Plot-Device.md`.

Suggested prompt (Cursor-friendly):
```text
Audit `/src/{SCENE_ID}.twee` against:
- `/.cursor/rules/twee-gen.mdc`
- `/.cursor/rules/tactical-gen.mdc`
- `/docs/Plot-Graph.dsl` (scene: `SCENE_ID`)
- `/docs/Plot-Device.md`

Important: 
DSL & Sugarcube syntax is intentionally different. Focus only on logical differences.

Tasks:
1) Build an adjacency list for `SCENE_ID` (components and edges with labels & conditions).
2) Parse `/src/{SCENE_ID}.twee` and extract passage links and timed progressions.
3) Enforce the mapping rules from Prompt 6:
   - Scope: the file contains ONLY passages for the specified scene plus connections into the next scene.
   - Handoffs: for each cross‑chapter relationship in the DSL, add exactly one handoff from its source passage to the designated next scene.
   - Edge modality: mirror DSL edge labels and conditions — if "timer", use a timed auto‑advance; if "Act: X", use a user link labeled X; include any `Anger`/`Stress` thresholds via SugarCube conditionals.
   - Target ID mapping: targets follow `cNN.sNN.PNN` where `PNN` equals the DSL component passage‑name.
   - Stub rule: if a target passage does not exist yet, a stub with that exact ID exists in the same Twee file, tagged `[stub]`, with minimal body; created only if absent.
4) Compare both graphs:
   - Missing or extra passages or edges
   - Label mismatches (`Act: ...`), timer presence, and conditions (`Stress`/`Anger` thresholds)
   - Game Over targets and counts
   - Stat delta consistency per passage (match intent and magnitude bands)
   - ID format and cross‑ref mapping correctness
   - Handoff presence/count and stub existence/tagging
5) Source-of-truth policy:
   - If `/src/{SCENE_ID}.twee` deviates from `/docs/Plot-Graph.dsl`, prefer the DSL and fix Twee.
   - If the DSL contradicts `/docs/Plot-Device.md` themes or anchors, do NOT silently fix. List the contradiction and propose minimal DSL edits that realign with Plot-Device, then provide the matching Twee diff.

Output:
1) Violations (bullets) grouped by type (structure, labels, timers, conditions, stats, ids/handoffs/stubs)
2) Corrected Twee snippets (only the changed passages)
```

Invocation: Execute Prompt 7 for `SCENE_ID`.

### Cursor usage — reference files instead of pasting
- In Cursor, reference files by path (e.g., `docs/briefs/{SCENE_ID}.json`, `/docs/Plot-Graph.dsl`, `/.cursor/rules/tactical-gen.mdc`, `/.cursor/rules/twee-gen.mdc`, `src/{SCENE_ID}.twee`) directly in prompts.
- This avoids copy/paste drift and keeps a single source of truth. The assistant can open and read these paths.
- If working outside Cursor or another file-aware IDE, you may paste JSON/DSL snapshots in the chat for discussion, but never persist DSL snapshots inside Scene Brief JSON files. The authoritative rule lives in `/.cursor/rules/tactical-gen.mdc`.
