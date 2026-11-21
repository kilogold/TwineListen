# Brief stage

The coordinator loads this reference when this stage is needed and supplies only the assigned prompt, applicable ownership, and review requirements to each worker. Resolve artifact paths from the repository root.

## Prompt 1 — Produce a Scene Brief (JSON only)
Output strict JSON (no prose) capturing anchors, non‑verbal actions, and thresholds for a single scene.

Suggested prompt:
```text
Using the `tactical-gen` skill and `docs/Plot-Device.md`, produce a Scene Brief in strict JSON (no prose, no comments) for `SCENE_ID`.

Scene Brief source resolution: follow the Scene source resolution policy in the `tactical-gen` skill.

Fields:
{ "chapter": "<chapter-name>", "scene": "<scene-name>", "anchors": [], "actions": [], "thresholds": { "angerHigh": 0, "stressHigh": 0 }, "quotas": { "anchor60": true, "doubleAnchor30": true } }

Requirements:
- anchors: 8–12 items. Resolve the allowed source pool for `SCENE_ID` using the Scene source resolution policy in the `tactical-gen` skill. Anchors must be unique exact substrings from that allowed source pool, with no inventions.
- actions: 10–14 non‑verbal action labels. Follow the Player agency and action vocabulary rules and Supportive listener posture in the `tactical-gen` skill.
- thresholds: choose `angerHigh` and `stressHigh` per the Adaptive Threshold Policy and First-run scope in the `tactical-gen` skill.
- quotas: anchor60 and doubleAnchor30 set true.
- Do NOT add any extra properties. Specifically, do not include any DSL snapshots or large text blobs in the brief; the DSL belongs only in `docs/workspace.dsl`.
```

Invocation: Execute Prompt 1 for `SCENE_ID`.

Overwrite `docs/briefs/{SCENE_ID}.json` with the newly generated JSON (version history is maintained by Git). Reference this file in later prompts (no pasting).

## Prompt 2 — Independently audit the Scene Brief JSON
Validate the Scene Brief JSON against required schema and constraints before generating the DSL. Report violations for the Prompt 1 author to repair, then re-audit before proceeding.

Suggested prompt:
```text
Audit the Scene Brief at `docs/briefs/{SCENE_ID}.json` against the `tactical-gen` skill and `docs/Plot-Device.md`. Report findings only; all files are read-only. Include the scene-constraint verification supplied in the coordinator task packet.

Scene Brief source resolution: follow the Scene source resolution policy in the `tactical-gen` skill.

Propose corrections only for fields that violate checks; preserve all other values and their order. Do not propose metadata fields, reordered arrays, or rewritten anchors/actions that pass checks.

Checks:
- Fields present: chapter, scene, anchors, actions, thresholds.angerHigh, thresholds.stressHigh, quotas.anchor60, quotas.doubleAnchor30. No extra properties.
- anchors: 8–12 items; unique; exact substrings from the allowed source pool for `SCENE_ID`, resolved per the Scene source resolution policy in the `tactical-gen` skill; no inventions.
- actions: 10–14 items; comply with the Player agency and action vocabulary rules in the `tactical-gen` skill.
- thresholds: angerHigh and stressHigh selected per Adaptive Threshold Policy (range and intent validated).
- quotas: anchor60=true, doubleAnchor30=true (exact values).
- Strings non‑empty; consistent casing and spelling; no comments or prose.

Output:
1) Violations (bullets)
2) Minimal proposed corrections, scene-constraint results, optional suggestions, and limitations (no applied edits)
```

Invocation: Execute Prompt 2 for `SCENE_ID`.

If corrections are needed, return findings to the Prompt 1 author, update only failing fields, and obtain a fresh Prompt 2 review before proceeding.
