---
name: twee-gen
description: Generates Twee files for a Twine project, based on Structurizr C4 DSL. Use when generating Twine dialogue based on the tactical graph.
---
You are an AI assistant helping develop a story-driven Twine game using Tweego as the narrative engine.

# Prompt
For the specified scene `SCENE_ID`, internalize [tactical-gen](/.cursor/skills/tactical-gen/SKILL.md) and parse [Plot-Graph.dsl](/docs/Plot-Graph.dsl) to generate Twee dialogue from the plot tactical graph. Author graph relationships for the specified scene's:
- [Passages](/docs/Plot-Graph.dsl#L11)
- [Cross-references](/docs/Plot-Graph.dsl#L22) which transition to the next scene or chapter passages.

## Narrative style
- Pretend you are M. Night Shyamalan.
- Incorporate dialogue tones & writing style, in order of preference:
  1. Melancholy, despair, grief.
  2. Poetic, but not abstract.
  3. Psychological thriller.

## Dialogue rules:
- Player is silent and stationary, only responding with presence, observation, and listening.
- Build Leon's Twine dialogue script based on @Plot-Device.md
  - Leon always ers on the side of suspicion towards the player.
  - Keep his dialogue consistent with [plot details](/docs/Plot-Device.md#plot-detail).
- Leon's communication style:
  - Uses coloquial American English.
  - Cynical
  - Hopeful

### Monologue expansion (required)
- For every non–Game Over passage, write multi-line content:
  - At least one narrator line (plaintext; no `.dialogue`).
  - Leon monologue: unrestricted length; use as many lines/paragraphs as needed for immersion. Prefer `<p class="dialogue">…</p>` per line or paragraph.
- Ground Leon’s lines in anchors from @Plot-Device.md; never reduce to a one‑sentence summary.
- Long monologues are encouraged; maintain readability with paragraph breaks.
- Game Over passages may be shorter, but must include a clear consequence line and visible Respawn links only (no Restart).

## Technical Twee guidelines:
- Implement story as a Twee.
- Follow SugarCube's spec for passage declaration, using `::`.
- Use Sugarcube V2 story format.
  - For Sugarcube documentation, recursively scan [sugarcube-2_docs](/docs/sugarcube-2_docs/).
- Entry point: the Twine story starts at the global `Start` passage, which initializes variables and should route to the first scene node `c01s01p01`.
- Do not create `StoryData` or `StoryTitle` passages. @main.twee already defines them.
- Timed passages incorporate the timed progress bar macro defined in @main.twee as a [`timedprogressbar` user script](/src/main.twee#L87). 
  - The passage should contextually advance automatically on timeout.
  - `timedprogressbar` macro uses the same duration accross every invocation. Use the [timer Sugarcube variable](/src/main.twee#L214) to easily modify.
- Leverage SugarCube variables to design pivotal narrative forks across passages. Always declare all global variables within "Start" passage in @main.twee.
  - Visit checks MUST use SugarCube's built‑in `visited()` API. Do NOT create custom `$visited*` counters. Map DSL `visited(PNN)` to `visited("cNNsNNpNN")` using the Twee title mapping rule.
  - Example A (using visited()):
    - For passages `A`->`B`->`C`, in passage `C` gate with `visited()`:
      - If `visited("C") == 0`: trigger Game Over.
      - If `visited("C") > 0`: continue sequence `C`->`D`->`E`.
  - Example B:
    - Leon has a `comfort` variable. Certain passages have a `threshold` value. Upon reaching such passages, the following conditions ensue:
      - If `comfort` >= `threshold`: Progress the story.
      - If `comfort` < `threshold`: Game over.
- Use CSS hooks for Leon's dialogue. Use plaintext for narrator scene descriptions. 
- Passage ID's must exactly match the [Plot-Graph.dsl](/docs/Plot-Graph.dsl) comment/passage sequence number: `P01` 
  - Naming & canonical IDs: follow `/docs/Plot-Graph.dsl` for element IDs and cross-refs (`cNN.sNN.pNN_<kind>`).
  - Twee passage title mapping (SugarCube-safe): transform the fully-qualified DSL component ID by removing dots and the `_kind` suffix from `pNN_<kind>`.
    - Mapping rule: `cNN.sNN.pNN_<kind>` → `cNNsNNpNN`
    - Example: `c01.s01.p03_rg` → `c01s01p03`
    - Use this exact transformed string as the Twee passage name and in `<<goto>>` and `[[link|target]]`.
- User-choice passage links are always written outside & after the `timedprogressbar` macro. For example:
  ```
  <<timedprogressbar 3>>
    <<goto "c01s01p03">>
  <</timedprogressbar>>
  [[Act: Step back|c01s01p03]]
  [[Act: Lower your gaze|c01s01p04]]
  ```

- Game Over passages must present Respawn options only:
  - Render visible links to DSL-mapped respawn targets; do not include any Restart link.
  - Do not auto-advance from GO passages.

- GO fan‑out in Twee (on the GO passage):
  - The DSL defines `Respawn` relationships from GO nodes to model narrative restarts. In Twee, do NOT auto‑advance from GO.
  - In each GO passage, render visible links to the mapped respawn targets (regular passages) using the same conditions as the DSL fan‑out (e.g., `visited(...)`). Use SugarCube `visited("...")` with the Twee passage title.
  - Respawn targets are regular passages. They should reconnect into the scene’s entry flow within ≤1 hops, per tactical rules, typically via an unconditional `timer` within the respawn passage to `p01`.

- Only render a timed progress bar when the timer edge is reachable under current conditions.
  - Problematic example to avoid, assuming `stress == 30`:
    ```
    <<timedprogressbar $timer>>
      <<if $stress > 70>><<goto "P10">><</if>>
    <</timedprogressbar>>
    ```
      - Progress bar depletion is inconsequential.
      - A potential solution is to refactor:
        ```
        <<if $stress > 70>>
          <<timedprogressbar $timer>>
            <<goto "P10">>
          <</timedprogressbar>>
        <</if>>
        ```
      - Solve for complex conditions involving multiple variables by structuring the  conditions like a software engineer would:
        - Consider if more than one progress bar must be declared, while only choosing one at runtime.
        - Consider if conditional branching is guaranteed to predict whether the progress bar will be relevant.


### Dynamic passage content
- Object‑intro enforcement (Twee): In any passage that emits object‑anchored `Act: …` links, include a narrator sentence that mentions the object phrase before rendering links. Prefer routing manipulative actions from the object’s intro passage.
While each Twee passage name must be unique, dialogue content may vary.
For example, the initial passage content may vary as Leon vaguely recalls the player's prior playthroughs on every restart.
In this case, all possible dialogue variations are written into the same passage, while variables and conditions determine which dialogue variant gets displayed at runtime.
Make frequent use of this technique to:
- create a sense of continuitiy and consequence accross and within each playthrough. 
- keep Leon's dialogue less robotic due to repeating his lines.
  - For every potential passage revisit, author an additional open-ended dialogue line that sounds natural to repeat. Alternate the passage dialogue according to revisit.