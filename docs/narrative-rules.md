# Shared narrative rules

Read this guidance when authoring tactical graph descriptions or Twee dialogue. It is a read-only input during either generation phase and does not grant permission to edit another phase's artifacts. Image prompt authoring uses only the Player agency section as read-only visual constraints.

## Narrative style
- Pretend you are M. Night Shyamalan.
- Incorporate dialogue tones and writing style, in order of preference:
  1. Melancholy, despair, grief.
  2. Poetic, but not abstract.
  3. Psychological thriller.

## Player agency
The player is a silent, ethereal presence whose nature remains concealed until endgame. Physical choices express intentions or attempts, never guaranteed outcomes. Narration may suggest movement or anticipated sensation, but must not establish completed bodily contact or physical effects caused by the player. Interruptions, evasions, and ambiguous perceptions preserve the illusion of embodiment. Gaze and listening remain the player's only confirmed means of engagement.

In tactical graphs, frame physical choices as attempts and give their destination passages a plausible interruption or ambiguous outcome. Prefer `Act: Reach toward Leon's shoulder` over `Act: Tap Leon's shoulder`. In Twee, preserve that intent while resolving the attempt without confirming contact. Leon must not react as though contact occurred; his reactions may follow perceived attention, his own suspicions, or surrounding events.

Vary how attempts resolve so repeated interruptions do not reveal the twist prematurely. Choices may change dialogue, reveal information, affect narrative state, and select branches without proving physical agency. Keep the ethereal explanation in authoring guidance until the planned endgame revelation.

For example, the player reaches toward Leon's shoulder, but a noise makes him turn away before contact can be established. His ensuing suspicion follows the noise or perceived attention, never a felt tap.

## Leon
- Ground Leon's dialogue and graph cues in `docs/Plot-Device.md` and the target scene's permitted context. Keep them consistent with plot details.
- Leon errs on the side of suspicion toward the player. He uses colloquial American English and is both cynical and hopeful.
- Leave the player uncertain about which choices lead to safe or dangerous progression.

## Supportive listener posture
- The player's long-term survival strategy is to behave like a supportive listener Leon may someday trust, not a controller, interrogator, or solver.
- Prefer actions that express witness, patience, restraint, space, and attention to Leon's state or surrounding anchors.
- Treat intrusive, pressuring, controlling, or rhythm-breaking actions as higher-risk options, especially when they suggest forced closeness, imposed interpretation, or interruption of Leon's emotional cadence. Resolve physical attempts under Player agency above.
- Choices should test whether the player behaves like a patient witness rather than a puzzle-solver hunting safe buttons.
- Do not make the correct behavior mechanically obvious. The player should infer the supportive-listener ethic through repeated consequences, not explicit tutorial logic.

## Game Over meaning
- Game Over is progression, not punishment. The player is expected to die and return.
- Every Game Over must create narrative value by doing at least one of the following:
  - reveal a new contradiction, wound, fear, or boundary in Leon
  - expose a mistake in how the player approached Leon
  - ambiguously hint at the player's returning nature or persistence without revealing their ethereal identity before endgame
  - reframe a previously seen object, action, or emotional reaction with new meaning
- Do not author filler deaths that differ only in surface flavor. Distinct Game Over branches should teach meaningfully different lessons about Leon, the player, or their relationship.
- Respawn placement should let the player apply what the death just taught rather than dumping them into a semantically unrelated loop.


## Constraint applicability
- Apply shared rules and the target scene's constraints below during brief, graph, and dialogue authoring and review. Other scenes' constraints do not apply by default.
- Scene-specific hard constraints take precedence over optional creative heuristics. Report conflicts between hard requirements rather than silently overriding them.
- These are authored, read-only inputs during generation and auditing. Fresh attempts overwrite generated outputs, not these requirements. They do not extend the Scene Brief JSON schema or supply prose anchors.

## Scene-specific constraints

### c01.s01 — Attic Encounter
- **Explicit-action deaths only:** every incoming edge to a Game Over must be an explicit player action (`Act: ...`). Timers must not enter Game Over passages; inaction alone must not cause death.
- **Either death is sufficient:** continuation requires at least one Game Over, but either Game Over independently satisfies that requirement. Do not require both deaths, directly or indirectly, before allowing continuation.
- Graph review must check every Game Over's incoming edges and demonstrate a continuation path after each death independently, with the other Game Over unvisited. Check timer-only routes for accidental deaths. Twee review must confirm equivalent behavior in the implementation.
