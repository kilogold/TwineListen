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

### Prompt 1 — Produce a Scene Brief (JSON only)
Output strict JSON (no prose) capturing anchors, non‑verbal actions, and thresholds for a single scene.

Suggested prompt:
```text
Using `/.cursor/rules/tactical-gen.mdc` and `/docs/Plot-Device.md`, produce a Scene Brief in strict JSON (no prose, no comments).

Fields:
{ "chapter": "Start", "scene": "Attic Encounter", "anchors": [], "actions": [], "thresholds": { "angerHigh": 35, "stressHigh": 60 }, "quotas": { "anchor60": true, "doubleAnchor30": true }, "sourceDocVersion": "", "generatedAt": "" }

Requirements:
- anchors: 8–12 concrete items/phrases copied verbatim from the provided source for the specified chapter/scene only. No inventions. No cross‑chapter items. Prefer physical objects and named nouns; avoid abstractions unless explicitly named. All anchors must be unique and must appear in the source text (exact substring match).
- actions: 10–14 non‑verbal action labels. No speech verbs (ask/say/tell/etc.). Prefer object‑anchored; pronouns allowed when unambiguous. Include 2–3 “touch Leon” variants. Ensure ≥6 distinct verbs and no duplicates.
- thresholds: angerHigh=35, stressHigh=60 for touch-triggered Game Over branching.
- quotas: anchor60 and doubleAnchor30 set true.
```

Save the JSON to `docs/briefs/start.json` (for versioning). In Cursor, reference this file in later prompts (no pasting).

### Prompt 1.5 — Audit the Scene Brief JSON (deterministic)
Validate the Scene Brief JSON against required schema and constraints before generating the DSL. If fixes are needed, emit a corrected JSON and use it for the next step.

Suggested prompt (Cursor-friendly):
```text
Audit the Scene Brief at `docs/briefs/start.json` against `/.cursor/rules/tactical-gen.mdc` and `/docs/Plot-Device.md`. List violations briefly, then output a corrected, final JSON only.

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

If corrections were made, update `docs/briefs/start.json` with the corrected JSON before proceeding.

### Prompt 2 — Generate the Tactical Graph DSL from the Brief
Use the Brief to emit only the Structurizr DSL for `ch_start.scn_attic`.

Suggested prompt (Cursor-friendly):
```text
Using `/.cursor/rules/tactical-gen.mdc`, the Scene Brief at `docs/briefs/start.json`, and the header conventions in `/docs/Plot-Graph.dsl`, generate ONLY the Structurizr DSL for chapter "Start" / scene "Encounter in an empty attic".

Enforce:
- Descriptions 100–200 chars; complete sentences; meet anchor quotas (≥60% anchored; ≥30% double-anchored).
- Non‑verbal actions only. Labels: `Act: ...` and `timer` only. Use action labels from the Brief; no duplicates; ≥6 distinct verbs.
- 12–16 components with at least 2 Game Over nodes.
- Every non–GameOver passage has ≥1 outgoing `timer`.
- At least one explicit user‑choice path to Game Over exists.
- Use `visited(...)` gates sparingly (1–2 unlocks) and keep reachable in 1–2 iterations.
- Stat deltas: integers, clamp [0,100]; default magnitudes 2..12; spikes up to 20 only when directly preceding GO.
- Touch actions must branch: GO when `Anger > angerHigh` or `Stress > stressHigh`; otherwise continue with reasonable deltas.

Output ONLY the `ch_start { scn_attic { ... } }` DSL block.
Update `docs/briefs/start.json` with the corrected DSL before proceeding.

Run the following terminal command for DSL syntax validation: `structurizr-cli validate -w docs/Plot-Graph.dsl`
```

### Prompt 3 — Audit/Fix pass (deterministic)
Run a validation pass and re‑emit a corrected DSL if needed.

Suggested prompt (Cursor-friendly):
```text
Audit the `ch_start.scn_attic` block in `/docs/Plot-Graph.dsl` against `/.cursor/rules/tactical-gen.mdc` and the Scene Brief at `docs/briefs/start.json`. List violations briefly, then output a corrected, final DSL block only.

Update `docs/briefs/start.json` with the corrected DSL before proceeding.

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

### Optional — Refactor an existing scene to comply
Use this when updating an existing graph without adding nodes unnecessarily.

Suggested prompt:
```text
Transform the `ch_start.scn_attic` block below to comply with `/.cursor/rules/tactical-gen.mdc` and the Scene Brief:

Tasks:
- Replace any speech‑like actions (e.g., "Act: Ask about her") with non‑verbal, object‑anchored actions from the Brief.
- Ensure every non–GO passage has ≥1 outgoing timer.
- Add conditional branches for any touch actions: GO when `Anger > angerHigh` or `Stress > stressHigh`; otherwise continue with deltas (2..12).
- Enforce 100–200 char descriptions and anchor quotas; keep node IDs stable; don’t bloat node count.

[PASTE CURRENT ch_start.scn_attic BLOCK]
[PASTE BRIEF JSON]

Output ONLY the updated DSL block.
```

### Prompt 4 — Generate Twee from the Plot Graph (Cursor-friendly)
Convert the validated plot graph into SugarCube v2 Twee passages for the specified chapter.

Suggested prompt (Cursor-friendly):
```text
Using `/.cursor/rules/twee-gen.mdc`, read the chapter "Start" tactical graph from `/docs/Plot-Graph.dsl` and generate the corresponding SugarCube v2 Twee passages.

Inputs (read by path; do not paste contents):
- `/.cursor/rules/twee-gen.mdc`
- `/docs/Plot-Graph.dsl` (use `ch_start.scn_attic`)
- `/src/main.twee` (macros and globals)
- `/docs/sugarcube-2_docs/` (reference only)

Follow the rules in `/.cursor/rules/twee-gen.mdc`. Respect passage IDs and cross-refs defined in `/docs/Plot-Graph.dsl`.

Output ONLY the Twee passages for chapter "Start" intended to replace the body of `/src/start.twee`.
```

### Cursor usage — reference files instead of pasting
- In Cursor, reference files by path (e.g., `docs/briefs/start.json`, `/docs/Plot-Graph.dsl`, `/.cursor/rules/tactical-gen.mdc`, `/.cursor/rules/twee-gen.mdc`) directly in prompts.
- This avoids copy/paste drift and keeps a single source of truth. The assistant can open and read these paths.
- If working outside Cursor or another file-aware IDE, fall back to pasting the exact JSON/DSL snapshots.
