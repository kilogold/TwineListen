---
name: twee-gen
description: Generates Twee files for a Twine project, based on Structurizr C4 DSL. Use when generating Twine dialogue based on the tactical graph.
targets:
  - '*'
---
You are an AI assistant helping develop a story-driven Twine game using Tweego as the narrative engine.

Resolve source and output paths from the repository root; Markdown link targets are relative to this skill file.

# Prompt
For the specified scene `SCENE_ID`, parse [docs/workspace.dsl](../../../docs/workspace.dsl) as a read-only source and generate Twee dialogue that implements the existing graph relationships for the specified scene's:
- Passages: follow the `Component parameters (in-order)` guide comment in `docs/workspace.dsl`.
- Cross-references: follow the `Addressing & cross-references` guide comment in `docs/workspace.dsl` for transitions to the next scene or chapter passages.

## Phase ownership
- Write `src/{SCENE_ID}.twee`, including permitted handoff stubs when their target is absent. Read all `src/*.twee` passage declarations first. The only other-scene edit allowed is removal of an exact-title `[stub]` passage superseded by a real target or duplicated by the retained stub; preserve all other content and never replace real passages through stub cleanup.
- Preserve the DSL's nodes, edges, labels, conditions, stat effects, and routing. Reading graph policies for validation does not invoke graph generation or authorize changes to `docs/workspace.dsl`.
- If the graph is invalid, incomplete, or contradicts plot canon, report the affected IDs and propose a minimal DSL correction. Do not apply that correction during Twee generation or verification. Continue with unblocked content when useful, but identify incomplete output and do not invent branches, silently omit required edges, or claim full verification. A permitted Twee stub does not repair an undeclared DSL target.
- If the user's request already authorizes graph repair and Twee generation, complete the repair in a separate graph phase first, then generate from the corrected graph; no additional approval is implied by this phase boundary.
- Reuse `src/main.twee` as a read-only source for macros and globals. Shared-code changes require a requested feature that needs them, as specified in the State lifecycle contract.

## Shared narrative guidance
Follow [Shared narrative rules](../../../docs/narrative-rules.md) for player agency, tone, Leon's characterization, supportive-listener posture, and Game Over meaning. This is a read-only reference during dialogue generation; it does not invoke tactical graph authoring.

### Monologue expansion (required)
- For every authored non–Game Over passage, write multi-line content (WIP placeholders are exempt under WIP placeholder lifecycle below):
  - At least one narrator line (plaintext; no `.dialogue`).
  - Leon monologue: unrestricted length; use as many lines/paragraphs as needed for immersion. Prefer `<p class="dialogue">…</p>` per line or paragraph.
- Ground Leon’s lines in anchors from `docs/Plot-Device.md`; never reduce to a one‑sentence summary.
- Long monologues are encouraged; maintain readability with paragraph breaks.
- Game Over passages may be shorter, but must include a clear consequence line and visible Respawn links only (no Restart).

### WIP placeholder lifecycle
- Preserve the planned DSL handoff and its conditions even when the successor's dialogue is undeveloped. A placeholder is a development stop, not an intentional ending or a Game Over; never infer an ending from missing content.
- Create a stub only for an already-declared DSL target lacking real Twee content. Map its title canonically (e.g., `c02.s01.p01_rg` → `c02.s01.P01`), tag it `[stub]`, and use brief visible text such as `Work in progress: c02.s01 (Feeling stuck) has not been developed yet. To be continued.` Do not invent dialogue, state changes, or successor content. Existing image paths may be retained but images are not required for stubs.
- A stub has no outgoing choices or timer. It is exempt from monologue, narrator, anchor, and revisit-variation requirements. Do not add an automatic loop, Restart, or Respawn to satisfy normal gameplay checks. Declared `Passage-Ending` nodes render as authored `[ending]` passages with no onward progression; do not confuse them with `[stub]` passages.
- Reuse an existing exact-title stub anywhere in `src/*.twee`; do not add another in the current file. Keep one definition per title globally. If real content exists, link to it and remove only superseded tagged stubs. Multiple real definitions are a conflict to report, not permission to choose and delete one.
- When developing the successor, replace its stub with authored content under the same canonical title and remove `[stub]`. If the stub was embedded in a predecessor file, remove only that tagged passage as the narrow Phase ownership exception above. Preserve predecessor handoff links and all unrelated passages. If the DSL entry remains `Passage-Stub`, report the needed graph expansion under Phase ownership; do not silently invent its full graph in Twee.
- Verify zero broken targets and duplicate titles, and report all remaining stub titles as WIP. A build may be valid and playable with marked stubs; those scenes are not complete. A stub cannot conceal an undeclared DSL endpoint, missing edge, or invalid condition.

Example WIP stop (no timer or onward link):
```twee
:: c02.s01.P01 [stub]
Work in progress: c02.s01 (Feeling stuck) has not been developed yet. To be continued.
```

## Technical Twee guidelines:
- Implement story as a Twee.
- Follow SugarCube's spec for passage declaration, using `::`.
- Use Sugarcube V2 story format.
  - For SugarCube documentation, search [docs/sugarcube-2_docs](../../../docs/sugarcube-2_docs/) for APIs relevant to the task. Read matching sections and necessary dependencies; expand the search when unresolved questions require it. A full-library read is not required.
- Entry point: the global `Start` passage only routes to `c01.s01.P01`; it does not initialize or reset variables. Follow the State lifecycle contract below.
- Do not create `StoryData` or `StoryTitle` passages. `src/main.twee` already defines them.
- Timed passages incorporate the `timedprogressbar` macro in [src/main.twee](../../../src/main.twee); locate its definition by `Macro.add("timedprogressbar",` in the `UserScript` passage.
  - The passage should contextually advance automatically on timeout.
  - `timedprogressbar` uses the same duration across every invocation. Use `$timer`, initialized in the `StoryInit` passage of `src/main.twee`, to control that shared duration.
- Leverage SugarCube variables to design pivotal narrative forks across passages. Initialize fresh-game global defaults in `StoryInit` in `src/main.twee`, following the State lifecycle contract below; scene generation reuses existing globals.
  - Visit checks MUST use SugarCube's built‑in `visited()` API. Do NOT create custom `$visited*` counters. Resolve DSL `visited(PNN)` within its owning scene and map it to `visited("cNN.sNN.PNN")` using the Twee title mapping rule; fully qualified references retain their own chapter and scene.
  - Example A (visit counts; outcomes remain defined by the DSL):
    - Inside `c01.s01.P03`, the current visit is already counted. Use `== 0` only when checking a different, not-yet-visited passage. For a graph that distinguishes first visits from revisits:
      - If `visited("c01.s01.P03") == 1`: render the graph-defined first-visit outcome.
      - If `visited("c01.s01.P03") > 1`: render the graph-defined revisit outcome.
  - Example B:
    - Leon has a `comfort` variable. Certain passages have a `threshold` value. Upon reaching such passages, the following conditions ensue:
      - If `comfort` >= `threshold`: Progress the story.
      - If `comfort` < `threshold`: Game over.
- Translate chained mathematical ranges into separate SugarCube comparisons joined with `&&`: `11 <= Stress <= 16` becomes `($stress >= 11 && $stress <= 16)`. Preserve inclusive/exclusive bounds and logical grouping; do not copy chained comparisons literally into Twee.
- Use CSS hooks for Leon's dialogue. Use plaintext for narrator scene descriptions.
- Twee passage titles must preserve the chapter, scene, and component passage-name from [docs/workspace.dsl](../../../docs/workspace.dsl), including the uppercase `P` and two-digit sequence number (e.g., `P01`).
  - Naming & canonical IDs: follow `docs/workspace.dsl` for element IDs and cross-refs (`cNN.sNN.pNN_<kind>`).
  - Twee passage title mapping (canonical): retain the dotted chapter and scene prefix and use the component's uppercase passage-name (`PNN`) as the final segment; omit the DSL `_kind` suffix. Dots are valid in Twee passage titles.
    - Mapping rule: `cNN.sNN.pNN_<kind>` (component passage-name `PNN`) → `cNN.sNN.PNN`.
    - Examples: `c01.s01.p03_rg` → `c01.s01.P03`; `c01.s01.p10_go` → `c01.s01.P10`.
    - Use this exact case-sensitive title in passage declarations, user links, `<<goto>>`, `visited()`, cross-scene handoffs, and stub declarations. Preserve valid titles during verification; image asset filenames are independent and existing image paths must remain unchanged.
- User-choice passage links are always written outside & after the `timedprogressbar` macro. For example:
  ```
  <<timedprogressbar $timer>>
    <<goto "c01.s01.P03">>
  <</timedprogressbar>>
  [[Act: Try to step back|c01.s01.P03]]
  [[Act: Lower your gaze|c01.s01.P04]]
  ```

- Game Over passages must present Respawn options only:
  - Render visible links to DSL-mapped respawn targets; do not include any Restart link.
  - Do not auto-advance from GO passages.

- GO fan‑out in Twee (on the GO passage):
  - The DSL defines `Respawn` relationships from GO nodes to model narrative restarts. In Twee, do NOT auto‑advance from GO.
  - In each GO passage, render visible links to the mapped respawn targets (regular passages) using the same conditions as the DSL fan‑out (e.g., `visited(...)`). Use SugarCube `visited("...")` with the Twee passage title.
  - Respawn targets are regular passages whose DSL routing unconditionally returns to the scene entry within one hop. Implement those timers; report missing or conflicting graph routing under Phase ownership rather than repairing the DSL.

- Only render a timed progress bar when the timer edge is reachable under current conditions.
  - Problematic example to avoid, assuming `stress == 30`:
    ```
    <<timedprogressbar $timer>>
      <<if $stress > 70>><<goto "c01.s01.P10">><</if>>
    <</timedprogressbar>>
    ```
      - Progress bar depletion is inconsequential.
      - A potential solution is to refactor:
        ```
        <<if $stress > 70>>
          <<timedprogressbar $timer>>
            <<goto "c01.s01.P10">>
          <</timedprogressbar>>
        <</if>>
        ```
      - Solve for complex conditions involving multiple variables by structuring the  conditions like a software engineer would:
        - Consider if more than one progress bar must be declared, while only choosing one at runtime.
        - Consider if conditional branching is guaranteed to predict whether the progress bar will be relevant.


### Dynamic passage content
- Object‑intro enforcement (Twee): In any passage that emits object‑anchored `Act: …` links, include a narrator sentence that mentions the object phrase before rendering links. Prefer routing attempted object interactions from the object’s intro passage; resolve them under the shared player-agency contract.
While each Twee passage name must be unique, dialogue content may vary.
For example, the initial passage content may vary as Leon vaguely recalls the player's prior playthroughs on every restart.
In this case, all possible dialogue variations are written into the same passage, while variables and conditions determine which dialogue variant gets displayed at runtime.
Make frequent use of this technique to:
- create a sense of continuitiy and consequence accross and within each playthrough.
- keep Leon's dialogue less robotic due to repeating his lines.
  - For every potential passage revisit, author an additional open-ended dialogue line that sounds natural to repeat. Alternate the passage dialogue according to revisit.

### State lifecycle
- Fresh game: `StoryInit` in `src/main.twee` initializes `$timer = 30`, `$gazed = false`, `$listened = false`, `$stress = 0`, and `$anger = 0`. These defaults are not reapplied on ordinary scene entry or respawn.
- `Start` only routes to `c01.s01.P01`; do not place initialization or respawn resets there.
- Each contextual respawn passage applies `$stress = floor($stress / 2)` and `$anger = 0` exactly once per respawn, then its unconditional timer returns to the scene entry. Keep stats clamped to [0,100]. Do not duplicate these resets in GO passages or entry passages.
- Respawn preserves visit history, replay discoveries, and other globals (including timer and flags). Do not use a full story restart to implement respawn.
- Ordinary scene entry applies the passage's normal effects without reinitializing global state; entry effects occur after the respawn reset.
- Scene generation must reuse the established globals and shared initialization. Modify shared initialization only when the requested feature requires it; initialize any new fresh-game defaults in `StoryInit`.
