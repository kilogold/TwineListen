# Strangers In The Attic
<a href="https://kilogold.github.io/TwineListen/">
<img src="https://kilogold.github.io/TwineListen/build/images/title.png" alt="Description" width="500" height="750">
</a> 

A Twine narrative prototype.

> **ℹ️ Note:**  
> See the playable [demo site](https://kilogold.github.io/TwineListen/).
> 

## Key development constraints
1. The game has only two mechanics: gaze & listen.
2. Focus on emotional storytelling and psychological thriller.
3. Apply principles from "Aesthetics of Play" for narrative content.

## Game features
- Player perspective: First-person.
- Single NPC actor: a frail and melancholic elderly man named Leon.
- Player actor: a mysterious humanoid physical entity that keeps respawning.
- Static environment: dark attic setting.
- Core gameplay revolves around careful NPC + environment observation & listening.
- NPC is subject to attack the player if he feels misunderstood, judged, or ignored.
- Game over unlocks new progressive story passages.
- The story has multiple endings based on player interactions & NPC reactions.
- Player only nods and listens.

## Project structure
- [src](/src/): All Twee files for Twine narrative.
- [docs](/docs/): Story context for narrative generation. 
- [include](/include/): Assets bundled with the build.
- [tools](/tools/): Misc automations for development.
- [.cursor](/.cursor/): LLM generation rules for [Tactical Graph](/docs/workspace.dsl).

## AI Workflow
See [workflow](/docs/Workflow.md) for implementation details:
```mermaid
flowchart TD
    PD((start)) -->|"docs/Plot-Device.md"| P1["Prompt 1 — Generate Scene Brief"]
    P1 -->|"docs/briefs/{SCENE_ID}.json"| P2["Prompt 2 — Audit Scene Brief"]
    P2 -->|"docs/briefs/{SCENE_ID}.json"| P3["Prompt 3 — Generate Tactical Graph"]
    P3 -->|"docs/workspace.dsl"| P4["Prompt 4 — Audit Tactical Graph"]
    P4 -->|"docs/workspace.dsl"| P5{"Existing scene?"}
    P5 -->|"Yes: docs/workspace.dsl + docs/briefs/{SCENE_ID}.json"| P5a["Prompt 5 — Refactor Tactical Graph"]
    P5a -->|"docs/workspace.dsl"| P4
    P5 -->|"No: docs/workspace.dsl"| P6["Prompt 6 — Generate Twee"]
    P6 -->|"src/{SCENE_ID}.twee"| P7["Prompt 7 — Audit Twee"]
    P7 -->|"src/{SCENE_ID}.twee"| Done(((done)))
```

### Tested recommended models per prompt
| Model         | P1 | P2 | P3 | P4 | P5 | P6 | P7 |
|---------------|----|----|----|----|----|----|----|
| GPT 5.4       | ✓  |    | ✓  |    | ✓  | ✓  |    |
| Opus 4.6      | ✓  |    | ✓  |    | ✓  | ✓  |    |
| Sonnet 4.6    |    | ✓  |    | ✓  |    |    | ✓  |
| GPT 5.3 Codex |    | ✓  |    | ✓  |    |    | ✓  |
