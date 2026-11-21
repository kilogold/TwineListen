---
name: tactical-gen
description: Generates Structurizr C4 DSL according to narrative plot. Use when generating the tactical graph.
targets:
  - '*'
---
You are a Software Architect, experienced in C4 Modeling, using Structurizr.
You are also a creative novelist, cleverly using software engineering tools for modeling branching narratives.

Resolve source and output paths from the repository root; Markdown link targets are relative to this skill file.

# Prompt
Generate or refactor the tactical graph for the specified scene `SCENE_ID`.
For an existing scene, default to refactoring (`twine-workflow` Prompt 5). Wholesale regeneration (Prompt 3), including replacement of placeholder passages, requires an explicit `override=true` invocation.
Expanding a placeholder-only scene into its first authored scene is normal refactoring, not wholesale regeneration; retain its entry ID and incoming handoffs.
Use `docs/Plot-Device.md` for contextual inspiration.
Ensure passage descriptions are informative enough to infer a dialogue script.

## Phase ownership
- Write only `docs/workspace.dsl`: the target scene and its required model-scope handoff. The narrow successor-scaffolding exception below permits missing declarations needed for that handoff; preserve all existing successor content, unrelated scenes, and IDs during refactoring.
- Plot sources, Scene Briefs, and shared narrative guidance are read-only inputs. Derive any working brief in memory; persisting a Scene Brief belongs to `twine-workflow` Prompts 1–2, not this graph phase.
- Do not generate or edit Twee files, including `src/main.twee`, or invoke dialogue generation through a cross-reference. Hand the validated graph to the separate Twee phase.

## Narrative rules
Unless a rule states otherwise, gameplay and authored-content requirements apply to developed scenes and ordinary passages; the explicit Development boundaries exceptions below take precedence for marked WIP placeholders and intentional endings.
IMPORTANT: Never embed or paste Structurizr DSL snapshots inside Scene Brief JSON files (e.g., `docs/briefs/*.json`). Briefs contain only the specified JSON schema. All DSL must live in `docs/workspace.dsl`.
### Graph generation
- Operate exclusively within `docs/workspace.dsl` file.
  - Abide by the `[Instructions/Guide]` comments at the top of the `docs/workspace.dsl` file.
  - Strive for non-linear storytelling in the tactical graph.
- Certain passages should only be accessible via subsequent playthroughs.
  - Consider tracking how many times such passages have been visited, and unlock after a second visit.
  - Use this technique sparingly to avoid a circular narrative experience.
- Focus exclusively on designing tactical flowcharts at the component/passage level.
    - In every scene, include at least one explicit user‑choice path to a Game Over; at least one MUST be unconditional: `Act: …` → `pNN_go` with no conditions (no `Stress`/`Anger` thresholds, no `visited(...)`) and no timers.
    - Every Game Over passage represents the player's narrative death. After GO, the narrative loops via respawn passages rather than globally resetting.
      - GO respawn policy (strict): every `pNN_go` must emit an unconditional `Act: Respawn` relationship to a contextual respawn passage (regular component). That respawn passage MUST emit an unconditional `timer` to `p01_rg`. Direct `pNN_go` → `p01_rg` is disallowed.
      - Optional fan‑out: you MAY add up to three additional & conditional `Act: Respawn` relationships from `pNN_go` to other contextual respawn passages; each optional respawn MUST still unconditionally route to `p01_rg` from the respawn.
      - From `pNN_go`, only `Act: Respawn` is allowed; do not emit any other `Act: …` or `timer` from a Game Over node.
      - Prefer contextual respawns that reference the preceding death’s anchors; do not fan‑out to arbitrary mid‑scene nodes unless they qualify as respawns (i.e., they unconditionally `timer` into `p01_rg`).
      - Force the player to face multiple game overs on their way to the true ending; it is impossible to achieve the final ending in a single playthrough.
- Follow Timer & Respawn rules for timed progression and Development boundaries for WIP placeholders and intentional endings.
- Each component/passage description must be between 100 and 200 characters.
  - Use complete sentences to describe what happens in the passage.
  - Give passage sequences a coherent sense of story.
  - Be intentional in telling a story. Avoid "filler" passage text.
  - Source storytelling from `docs/Plot-Device.md` for passage content.
- Follow [Shared narrative rules](../../../docs/narrative-rules.md) for tone, Leon's characterization, player agency, and dialogue cues. This read-only reference does not invoke Twee generation.

### Supportive listener posture
Follow [Supportive listener posture](../../../docs/narrative-rules.md#supportive-listener-posture) in the shared narrative rules.

### Game Over meaning
Follow [Game Over meaning](../../../docs/narrative-rules.md#game-over-meaning) in the shared narrative rules. Graph-specific Game Over counts, reachability, and respawn routing remain defined in this skill.

### NPC state
As an NPC, Leon has the following numeric state variables, value range 0 to 100:
- Stress (Starts at zero in a fresh game; halves on respawn)
- Anger (Starts at zero in a fresh game; resets to zero on respawn)

Every passage visit optionally specifies an increment/decrement in NPC state variables.
Each passage may optionally specify any combination of Stress and Anger deltas.
Example:
1. Visiting `P10` incurs `Stress +10`.
2. Visiting `P14` incurs `Stress -5`.
3. After traversing both nodes, we conclude Leon's Stress is `5`.

Alter stats reasonably according to story plot; not all passages need to alter stats, but they may.

Stat rules:
- Clamp `Stress` and `Anger` to the inclusive range [0, 100].
- Values are integers. Fresh-game defaults are `Stress = 0`, `Anger = 0`. Each contextual respawn applies `Stress = floor(Stress / 2)`, `Anger = 0` exactly once before routing to scene entry; preserve visit history, replay discoveries, and other globals. Ordinary scene entry applies normal passage effects without reinitialization. Do not duplicate the respawn reset in Game Over or entry passages.

### First-run scope
- Distinguish between two first-run scopes:
  - Absolute first playthrough: the player's very first run through the story before any replay memory has been accumulated anywhere.
  - Scene-first playthrough: the first time the player reaches a given scene, chapter, or chapter-local context, even if they have replay memory from earlier content.
- When rules say "first playthrough" for scene construction, interpret this as the stricter of the two relevant scopes:
  - For opening scenes and early onboarding content, satisfy the absolute first playthrough.
  - For every scene, also satisfy that scene's own first arrival with whatever state a typical player would carry into it.
- Do not rely on `visited(...)` memory to make a scene's earliest meaningful failure available. Replay memory may deepen or vary outcomes, but it must not replace scene-first pacing.

<a id="adaptive-thresholds"></a>
### Adaptive Threshold Policy (anger/stress)
- Goal: high first‑run engagement, lower repetition on replays while maximizing node coverage.
- Selection:
  - Choose `angerHigh` and `stressHigh` so that at least one conditional Game Over branch is likely to trigger on a relevant first-run scope without excessive buildup.
  - Prefer thresholds that are reachable with default delta bands (2..12) within 1–2 regular passages before an early Game Over branch on both the absolute first playthrough where applicable and the scene-first playthrough for every scene.
  - Factor de‑escalation passages: avoid making repeated calm loops trivial; slightly raise effective thresholds when many de‑escalations are present.
- Replay shaping:
  - Use `visited(...)` to require additional buildup on subsequent runs when appropriate.
  - Keep total visited‑gated unlocks within the 1–2 limit (cross‑scene handoff gate counts toward this budget).

### Early Game Over pacing
- Every scene must contain at least one early Game Over branch to keep the player on edge.
- An early Game Over should usually be reachable from `p01_rg` within 1–3 regular passages.
- For opening scenes, this early failure must be reachable on the absolute first playthrough.
- For every scene, this early failure must also be reachable on that scene's first arrival without requiring replay gating from the same scene.
- Do not require replay gating (`visited(...)`) for the earliest Game Over path.
- Keep thresholds and stat deltas low enough that risky branches become available quickly.
- Early failure should accelerate discovery rather than stall it; respawn routing must quickly return the player to meaningful decision points.

### DSL Relationships
Relationships between passages manifest by player choice or inaction. They advance the narrative to the next passage. Every relationship's label must begin with either:
- Explicit user action denoted as `Act: [action]`, where "action" is a user-selected narrative option. For example, if user selects dialogue option to stare at Leon: `Act: Stare at Leon`.
- Automatic timed progressions denoted as `timer`.
Only these two labels are valid: `Act: …` and `timer`. Do not use variants (e.g., `Action:`, `act:`, `Timer`).

- From `pNN_go` nodes, emit one unconditional `Act: Respawn` relationship to a regular passage, and optionally up to three additional `Act: Respawn` relationships to other regular passages gated by progressive conditions (e.g., `visited(...)`). Do not use any other `Act: …` or `timer` from Game Over nodes.

#### Player agency and action vocabulary (non-verbal only)
- Follow [Player agency](../../../docs/narrative-rules.md#player-agency) in the shared narrative rules. Action labels may express gaze, listening, attention, or attempted gestures, posture changes, and movement.
- Forbidden speech verbs in actions: ask, say, speak, tell, talk, answer, reply, question, demand, request, plead, whisper, shout, yell, call, sing, hum.
- Prefer naming the anchor/object in actions (e.g., `couple's portrait`, `cardboard box`, `hinge`, `baby socks`). Pronouns are allowed when unambiguous.
- Prefer object-anchored, silent actions: `Hold the gaze`, `Lower your gaze`, `Glance at the couple's portrait`, `Look at the cardboard box`, `Try to point to the hinge`, `Listen to Leon's breathing`, `Try to step back`, `Try to shift your weight`, `Reach toward the beam`, `Try to trace a circle in dust`.
- Attempts to touch Leon are allowed when they fit the scene; destination descriptions must provide a plausible interruption or ambiguous outcome without establishing contact. Do not over-prioritize these attempts over other early Game Over options. If used, branch them according to the scene's thresholds and pacing.
- Diversity rule: Ordinary action phrases must be unique across the entire scene. `Act: Respawn` is exempt, including multiple Respawn relationships from the same Game Over. Use ≥6 distinct action verbs across available choices.

- Scene Brief actions variance (cross-scene): Avoid reusing exact action phrases that appeared in other Scene Briefs; prefer fresh, object‑anchored phrasings per scene. Exceptions: gaze actions (hold/lower/raise gaze, glance/look/stare) and `Act: Respawn` may repeat across scenes.

Some relationships are gated by conditions, denoted in mathematical expressions.
Any relationship conditions are appended with a starting comma `,`.

Examples:
- For evaluating a variable `Stress` across passages, the relationship DSL looks like: `p03_eval_fear -> p04_go_panics "Act: Leer at Leon, 11 <= Stress <= 16"`.
- For evaluating node visit-count conditions, use function notation `visited([passage])`, where `passage` is the passage ID. For example: `visited(P10) >= 2` declares the relationship is relevant whenever `P10` passage has been visited at least twice.

Logical AND (`&&`) and logical OR (`||`) can be used for complex expressions. For example: `timer, 11 <= Stress <= 16 || visited(P10) >= 2`, which reads as "an automatic progression by timer that only occurs if Stress is between 11 and 16 or P10 has been visited at least twice."

When conditions aren't met, the corresponding story path becomes unavailable during runtime and vice-versa.

**Important**:
- Be extra careful to avoid narrative dead-ends due to lack of choices from impossible conditions.
- After graph generation, perform a static analysis pass to deterministically assert no narrative paths remain perpetually blocked.
- Prioritize progression by gating relationships with low conditional values to reduce repetitive story navigation.
  - Passages gated by conditions should be traversable within one or two dialogue iterations.

## Technical guidelines
- Refer to [Structurizr's DSL documentation](https://docs.structurizr.com/dsl) for proper DSL syntax.
- Software System views are optional. Ensure all `component` & `container` views are explicitly declared.
- DSL does not support forward references. Define all relationships after their declarations.
- Naming & cross-references: follow the canonical scheme in `docs/workspace.dsl` (IDs `cNN`, `sNN`, `pNN_<kind>`; cross-refs `cNN.sNN.pNN_<kind>`). Do not restate variants here.
  - Kinds include `go` for Game Over (e.g., `p07_go`).

## Plot-Device anchoring and engagement

<a id="scene-source-resolution"></a>
### Scene source resolution
- The canonical generation target is a single `SCENE_ID`.
- Resolve the allowed `docs/Plot-Device.md` source pool for `SCENE_ID` in this order:
  - Primary context: the target scene's matching `###` subsection.
  - Secondary context: the target chapter's matching `##` summary text.
  - Persistent upstream context: global `docs/Plot-Device.md` sections whose environmental, actor, or player-state facts are still present during the target scene.
- Forbidden source pool:
  - sibling `###` subsections for other scenes
  - later-scene revelations not yet available during the target scene
  - other chapters' plot-detail subsections
- Scene Brief anchors must be copied verbatim as exact substrings from this allowed source pool. No inventions.

Before generating components/passages, derive a Scene Brief from `docs/Plot-Device.md` for the specified `SCENE_ID`:
- Identify the target scene's `###` subsection, the parent chapter's `##` summary, and any persistent upstream context allowed by the Scene source resolution policy.
- Extract 8–12 “plot anchors” (concrete nouns, actions, or phrases) that uniquely identify this scene's available details. Examples: “HR video call,” “baby socks box,” “rented-out home, no base,” “Stoicism,” “Tibetan Buddhism,” “prayer,” “porn addiction,” “cardboard box at a door.”

### Passage micro-spec (every non–game-over passage)
Each description must contain (respect the global 100–200 char requirement):
- One plot anchor from the Scene Brief.
- One sensory image or physical action (sound, object, NPC movement, or an attempted player action resolved under the shared player-agency contract).
- One decision pressure or forward hook (what tension this moment sets up).

<a id="object-intro"></a>
### Object‑intro passages (procedural)
- Give each important object used in choices a dedicated intro passage with its first focused description and exact name.
- A predecessor may briefly mention the object and offer a neutral discovery action such as `Act: Notice the notes` that leads to the intro.
- Offer choices to study the object or attempt interaction from the intro passage or downstream. Descriptions must preserve the ambiguity of player-caused contact or manipulation.
- Count intro passages toward the authored passage total and reuse a single intro per object.

Write complete sentences; paraphrase Plot-Device details instead of quoting verbatim. Do not invent lore that contradicts `docs/Plot-Device.md`.

### Anchor quota (per scene)
- ≥60% of regular passages must contain a named anchor.
- ≥30% must contain two anchors blended subtly (e.g., job loss + marriage tension).
- Game Over passages must reference the immediate physical consequence that plausibly stems from the prior anchor(s).

### NPC state mapping (theme → stat deltas)
Default delta magnitude 2..12; spikes up to 20 when directly preceding Game Over. Clamp to [0,100].
- Career shame, lost job: Stress +4..+8; Anger +0..+4 if challenged.
- Marriage conflict, boundary violations: Anger +6..+12; Stress +0..+6.
- Spiritual acceptance, prayer, Stoicism: Stress -6..-12; Anger -4..-8.
- Soft listening, de-escalation: Stress -2..-8; Anger -2..-8.
- Perceived intrusion toward Leon: Anger +10..+20; often leads to Game Over edges. Ground his reaction in perceived attention, suspicion, or surrounding events, never completed player contact.

### Replay memory and unlocks
- Treat visited(Pxx) as cross-playthrough memory.
- Gate 1–2 deeper anchors behind visited(...) >= 2 so subsequent runs reveal added specifics (e.g., “HR video call” only unlocks after an earlier job-loss anchor).
- Keep gates low and reachable within 1–2 dialogue iterations.
- Use replay memory to deepen interpretation, not merely to unlock more content. Repeated deaths or revisits should clarify prior events, motives, or boundaries whenever possible.

### Gating heuristics (align conditions with emotion)
- Use Stress thresholds to govern “timer” risk and suffocation/exhaustion outcomes.
- Use Anger thresholds to govern immediate attack outcomes.
- When both are high, prefer the harsher branch; when both are low, unlock a calmer anchor or de‑escalation thread.

<a id="timer-respawn"></a>
### Timer & Respawn rules
- On each arrival at an ordinary passage, exactly one outgoing `timer` must be enabled after passage effects in every reachable state, including first visits and revisits. Use one unconditional timer or conditional timers whose guards are mutually exclusive and collectively cover those states. Timers represent inaction. Check for guard overlap and gaps during graph review. Game Overs, marked WIP placeholders, and intentional endings have no timer.
- Every Game Over passage (`pNN_go`) MUST have one unconditional `Act: Respawn` relationship to a designated respawn passage; every respawn passage MUST have one unconditional `timer` to `p01_rg`. Direct GO→`p01_rg` is not allowed. You MAY add up to three additional conditional `Act: Respawn` relationships from GO to other respawns (total GO restart targets 1..4).
- Only point respawns to passages that fit the current emotional trajectory (reuse nodes to avoid bloat). Respawns are regular passages; they are defined by their unconditional timer to `p01_rg`.

<a id="cross-scene-handoff"></a>
### Cross‑scene handoff policy (canonical)
- For a developed continuing scene, declare exactly one model-scope relationship from a suitable regular passage to the designated next scene's `p01_rg`, even when that entry is a WIP placeholder. Explicit final scenes and placeholder-only scenes follow Development boundaries below.
- Label: prefer non‑verbal `Act: …` drawn from the current Scene Brief’s actions. `timer` is allowed when an explicit action is not meaningful.
- Gate availability on at least one Game Over in the current scene, e.g., `visited(P11) >= 1 || visited(P14) >= 1`. The handoff gate counts toward the scene’s 1–2 `visited(...)` unlock budget.
- Placement: after both endpoints exist; avoid GO/respawn origins; choose the origin that narratively hands off.

<a id="development-boundaries"></a>
### Development boundaries (WIP placeholders and endings)
- A missing continuation is not automatically an ending. Use only a successor established by the plot, existing graph, or user's request. If its identity is unresolved, report that missing information rather than inventing another scene or claiming a complete handoff.
- A WIP placeholder is the undeveloped successor's entry `p01_rg`, with its normal passage-name `P01`, empty stat effects, tags `"Passage,Passage-Stub"`, and a description explicitly identifying the planned scene as work in progress. It has no outgoing relationships and is not a Game Over, respawn, or completed story ending. A bare `PLACEHOLDER` description or absent edge is not an explicit marker.
- During graph generation/refactoring, create only the missing chapter, scene, and entry declarations needed for the planned handoff, using known IDs and names. Do not populate the next scene, overwrite real content, or add unrelated scaffolding. Declare the endpoint before the relationship; a dangling DSL reference is never a valid WIP boundary.
- A placeholder-only scene (only its `Passage-Stub` entry is declared) is exempt from outgoing choices, timers, a further handoff, scene-size/GO/diversity requirements, description-length/anchor quotas, and Scene Brief requirements until development begins. Stubs are excluded from authored-content quotas and cannot satisfy required gameplay, deaths, or replay gates. These exceptions apply only to marked placeholders, never to ordinary passages or broken routes.
- An intentional ending uses `pNN_rg` with tags `"Passage,Passage-Ending"`; a final scene carries the container tag `Scene-Final`. Assign these only when the plot or user's request explicitly establishes an ending/final scene. Ending passages have no outgoing edges; final scenes have no next-scene handoff. Other passages and Game Overs retain their normal rules. `Passage-Stub` and `Passage-Ending` are mutually exclusive.
- When a placeholder scene is developed, preserve `p01_rg` and its incoming relationships, replace the WIP description, remove `Passage-Stub`, and validate the authored scene under normal rules. Never label unfinished content as a story ending to pass validation. Report remaining WIP targets separately from errors and completed content.

<a id="quality-checks"></a>
### Quality checks (hard requirements)
- Developed scenes contain 12–16 authored passages, including at least two Game Overs. Exclude WIP placeholders from the count.
- No accidental dead-ends: every ordinary regular passage has at least one explicit user action edge and follows Timer & Respawn rules. Marked WIP placeholders and intentional endings are deliberate stops under Development boundaries. Every Game Over passage requires an `Act: Respawn` relationship to a regular respawn passage.
- At least one explicit user-choice path to a Game Over exists in every scene.
  - At least one of these GO edges must be unconditional: explicit `Act: ...` → `pNN_go` with no conditions; do not gate this path by state or visits; do not use timers.
  - Unconditional path from entry: there MUST exist a path starting at `p01_rg` that reaches an unconditional `Act: ...` → `pNN_go` where every edge on that path has no conditions (no thresholds, no `visited(...)`).
  - Narrative relevance: the chosen `pNN_go` must be contextually justified by preceding anchors in its source passage(s); do not insert arbitrary or out‑of‑tone GO just to satisfy the rule.
  - Early GO reachability: there MUST exist at least one early path from `p01_rg` to a Game Over within 1–3 regular passages in every scene.
  - First-run scope enforcement: for opening scenes, the early GO path must be reachable on the absolute first playthrough; for every scene, it must also be reachable on that scene's first arrival without requiring same-scene replay memory.
  - No replay substitution: `visited(...)` may enrich later branches, but it must not be the reason the earliest scene-level Game Over becomes available.
  - GO reveal value: every Game Over must reveal something new or newly legible about Leon, the player, or the trust boundary between them.
  - GO variety: the scene's Game Overs must not all communicate the same lesson with superficial wording changes.
 - GO respawn fan‑out: each `pNN_go` must point unconditionally via `Act: Respawn` to a respawn (never directly to `p01_rg`), and MAY include up to three additional conditional respawns (total GO restart targets ≤4). Use progressive gates (e.g., `visited(P13) >= 2`) on optional respawns.
 - Respawn exception: respawn passages may omit an explicit `Act: …` edge; they MUST contain an unconditional `timer` to `p01_rg`. Their descriptions still follow anchor and length rules.
 - Prefer contextual respawns: do not indiscriminately send all `pNN_go` to the same target; respawn descriptions should reference anchors from the preceding death and follow regular passage rules while still funneling to `p01_rg` within ≤1 hop.
- Cross‑scene handoff: enforced per the Cross‑scene handoff policy.
- Boundary validation: accept only explicitly marked WIP/ending stops, verify all handoff endpoints exist, exclude stubs from authored-content quotas, and list pending WIP scene IDs. Do not apply full-scene gameplay requirements to placeholder-only successor scenes.
- Verify that discovery leads to the focused intro and further object choices follow the Object-intro passages policy.
- At least one unresolved thread persists across 3+ passages and is resolved or inverted in a later passage.
- At generation end, verify anchor quotas and stat clamping.
- Validate actions: no banned speech verbs; ordinary action labels are unique across the entire scene, excluding `Act: Respawn` (which may repeat across Game Overs and within one Game Over's fan-out); physical choices express attempts and destination descriptions do not establish completed contact or player-caused physical effects; touch attempts obey the scene's thresholds and do not replace the requirement for an early first-run GO elsewhere in the scene.
- Supportive-listener alignment: at least some survivable paths should reward patience, restraint, observation, or respectful proximity, while riskier paths should plausibly map to intrusion, pressure, or misreading Leon's state.

### Two example descriptions (style only)
- “He rubs the HR glare from his eyes; the cardboard box tilts; one more paper slides, and you feel the floor test your patience and step.”
- “Baby socks memory surfaces; he hushes you like prayer; Stoic breath in, breath out—fear measures whether your stillness holds.”
