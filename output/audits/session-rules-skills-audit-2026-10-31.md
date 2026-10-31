# TwineListen project rules and skills audit

Revised October 31, 2026, America/Puerto_Rico. This revision replaces the earlier session-wide report at this path.

P01–P13 received the agreed fixes. The five candidates raised in the additional pass were reassessed at the user's request using a critical-only threshold: demonstrated or strongly evidenced failures that block the authorized workflow, corrupt routing or state, or cause substantial unintended changes. None met that threshold, and all five have been withdrawn from the active audit. No further critical findings were established within the reviewed scope. This reassessment changed only this report; project rules and skills remain unchanged. Existing narrative content has not been independently re-audited against every revised rule, and excluded RuleSync sources remain unchanged.

## Scope

The revision audits only project-owned instructions and their local contracts:

| Included source | Role |
| --- | --- |
| [AGENTS.md](/Users/kbonilla/Projects/TwineListen/AGENTS.md) | Four project rules governing clarification, redundant requests, blocking conflicts, and precision |
| [image-prompt-authoring][image] | Passage image prompt authoring |
| [tactical-gen][tactical] | Scene graph generation |
| [twee-gen][twee] | Graph-to-Twee generation |
| [docs/Workflow.md][workflow] | On-demand project generation and verification instructions |
| [workspace.dsl guide][guide] | Naming and graph conventions explicitly required by tactical-gen |
| [DSL template boundary guide](/Users/kbonilla/Projects/TwineListen/docs/Tactical-Graph_TEMPLATE.dsl) | Boundary-marker comments aligned during P07; the entire template was not independently audited |
| [docs/narrative-rules.md][narrative] | Single shared reference for player agency and narrative guidance, consolidated during P05 remediation |

The latest session-provided AGENTS instructions replace prior AGENTS instructions. The on-disk project file contains the same four behavioral rules. No contradiction was found among those four rules themselves. Clarification is appropriate when a project choice cannot reasonably be inferred or when a conflict actually prevents progress.

The three project skill entrypoints were read in full. Workflow.md and the DSL instruction header were inspected as referenced project guidance. Targeted reads of src/main.twee checked the skills' macro and initialization references. A file-size inventory measured the SugarCube documentation burden; it did not load the whole library. Generated passages, image prompts, plot content, and reference imagery were not independently audited for narrative or visual quality.

The original audit was a static instruction review. P03 remediation additionally validated the title migration, compiled the story with Tweego and the project's SugarCube 2.37.3 format, and checked compiled passage data. No interactive playthrough, graph generation, or image generation was performed. Referenced Cursor and rule-sync sources were not opened or followed.

## Confirmed conflicts

### P01 — Resolved — Stationary player versus movement and touch

**Original evidence:** [twee-gen line 22][stationary] required a silent, stationary player. [tactical-gen lines 115–119][actions] allowed movement, included “Step back,” and permitted touching Leon. Twee-gen's own link example also used “Step back.”

**Workflow impact:** Graph authoring and dialogue authoring apply incompatible constraints to the same action. An agent may rewrite graph choices while trying to satisfy narration rules.

**Resolution:** The player is an ethereal presence concealed until endgame. Choices express attempted physical actions; narration must not confirm completed contact or player-caused physical effects. Gaze and listening remain the only confirmed engagement. Both skills now reference the shared [player-agency contract][agency]; action examples, graph outcome requirements, object-interaction guidance, and Leon's reaction guidance follow it. Varied interruptions and ambiguous outcomes preserve the illusion of embodiment. Existing narrative content has not been rewritten or re-audited against this contract.

### P02 — Resolved — Unique action phrases versus mandatory Respawn labels

**Original evidence:** [tactical-gen line 120][unique] forbade repeating any action phrase within a scene, reinforced by [line 238][action-check]. [Lines 28–30][respawn] require every Game Over to emit the exact label `Act: Respawn`. [Workflow Prompt 3][counts] requires at least two Game Over nodes per scene.

**Workflow impact:** A required scene necessarily repeats its mandatory restart label. A literal validator cannot pass both requirements; an agent may invent unsupported restart labels to resolve the contradiction.

**Resolution:** Ordinary action phrases remain unique across the entire scene. `Act: Respawn` is explicitly exempt, including multiple Respawn links from one Game Over and reuse across scenes. Tactical-gen's diversity rule, cross-scene variance rule, and validation guidance now agree; the existing respawn routing and fan-out limits are unchanged.

### P03 — Resolved — Verification requires different passage IDs from generation

**Original evidence:** [twee-gen lines 62–65][mapping] mapped `cNN.sNN.pNN_<kind>` to the SugarCube title `cNNsNNpNN`, for example `c01s01p03`. [Workflow Prompt 7 line 242][verify-mapping] instead specified targets as `cNN.sNN.PNN`, using the uppercase DSL passage name and retaining dots. Prompt 6 itself delegated naming to twee-gen. Image-prompt-authoring also prescribed the undotted format.

**Workflow impact:** The verification step can rename valid generated passages into a different namespace, break links, or alternate between formats on successive generation and repair passes.

**Resolution:** Adopted `cNN.sNN.PNN`, retaining the DSL chapter/scene hierarchy and using the component's uppercase passage-name: `c01.s01.p03_rg` → `c01.s01.P03`. Dots are supported; removing them is not a SugarCube requirement. Twee-gen now defines this mapping for declarations, links, timed transitions, visit checks, handoffs, and stubs. Both workflow prompts follow it and require already-valid titles to remain unchanged. Image-prompt-authoring uses the same title for prompt headers. Migrated all 13 existing scene/stub titles, 33 navigation/visit references, the Start entry target, and 13 prompt headers. Existing image filenames are independent and unchanged.

**Validation:** All scene/stub titles exactly match the DSL's 13 component declarations; every extracted navigation and visit reference resolves with matching case. Reversing only the identifier substitutions reproduces the previous Twee files and prompt prose exactly. All 13 referenced images still exist; the DSL is byte-for-byte unchanged. Before and after stories compile with Tweego v2.1.1 and SugarCube 2.37.3. Compiled passage data preserves the migrated titles and references. All three project skills pass the skill-creator validator. The bundled x86_64 compiler cannot execute on this Mac, so validation used a temporary native build from the official Tweego v2.1.1 source without replacing repository tools. This is compilation and static validation, not an interactive playthrough. Existing saves containing former passage names were not migrated.

### P04 — Resolved — Globals belong in Start according to the skill, but StoryInit in the shared code

**Original evidence:** [twee-gen lines 44–49][globals] said Start initializes variables and required all globals to be declared there. [main.twee lines 283–292][storyinit] initializes timer, flags, stress, and anger in StoryInit; Start only routes to the first scene. [Workflow Prompt 6 line 216][workflow-start] also described Start as resetting state.

**Workflow impact:** An agent following the skill may duplicate or relocate initialization, reset replay state unexpectedly, or broaden a scene-only generation task into changes to shared story code. The graph's separate per-playthrough reset rules further need an explicit lifecycle location.

**Resolution:** Twee-gen now defines an explicit state lifecycle: `StoryInit` initializes fresh-game defaults, `Start` only routes, and each contextual respawn halves stress (rounding down) and zeros anger exactly once before routing to scene entry. Respawn preserves visit history, replay discoveries, and other globals. Ordinary scene entry applies normal passage effects without reinitialization; GO passages do not duplicate the reset. Tactical-gen's stat rules distinguish fresh-game defaults from respawn resets, and Workflow Prompt 6 follows the same contract. Scene generation reuses established globals; shared initialization changes require a requested feature that needs them. No runtime code was changed for P04.

## Workflow risks and ambiguities

### P05 — Resolved — Reciprocal skill instructions blur graph and dialogue write ownership

**Original evidence:** Twee-gen's [opening instructions][twee-entry] said to follow tactical-gen and “Author graph relationships.” Tactical-gen's [opening instructions][tactical-entry] required graph generation and restricted operation to workspace.dsl, while its [style guidance][twee-style] referred back to twee-gen. [Workflow Prompt 6][workflow-twee] described conversion of a validated graph into a scene Twee file, and the [existing-scene guard][regeneration] distinguished refactoring from explicitly forced regeneration.

**Workflow impact:** Dialogue generation can be interpreted as permission to regenerate the source graph. Following every cross-reference literally can also reload both skills recursively. This is an ownership ambiguity rather than a necessary contradiction: references limited to shared narrative rules can coexist.

**Resolution:** Added [shared narrative rules][narrative] for player agency, tone, characterization, supportive-listener posture, and Game Over meaning. Player agency is now a section in that single reference; its separate file was removed to eliminate the extra read and reference chain. Both skills consume this as read-only guidance without invoking the other's authoring workflow. Tactical-gen owns the target DSL scene and required handoff; existing scenes default to refactoring unless `override=true` explicitly requests regeneration. Twee-gen owns only the target scene's Twee file and permitted stubs; the graph's topology, conditions, labels, and stat effects remain inputs. Shared-code changes retain the P04 feature requirement. Workflow now states output ownership for Prompts 1–7. Graph defects found in Twee work produce affected IDs and proposed DSL corrections; unblocked content may proceed with incomplete output identified. Already-authorized graph repair runs first as a separate phase without an extra approval step. No story artifacts or runtime code were changed for P05.

### P06 — Resolved — Root-looking paths and stale line anchors misdirect source inspection

**Original evidence:** Skills and Workflow.md used `/docs/workspace.dsl` and `/src/main.twee` without explaining their intended repository-root base. Twee-gen linked the macro to main.twee line 87 (now blank between CSS rules) and the timer setting to line 214 (now a setInterval comment); the definitions were actually at [line 151][macro] and [line 286][timer].

**Workflow impact:** Filesystem-aware agents may report missing sources, inspect unrelated CSS or interval code, or edit the wrong location. Project-root shorthand is inferable, but its interpretation is unstated.

**Resolution:** All three project skills and Workflow.md now specify repository-root resolution for source/output paths and document-relative resolution for Markdown links. Normalized source and output references in the generation skills and workflow, replacing ambiguous @filename shorthand. Twee-gen now locates `Macro.add("timedprogressbar",` in `UserScript` and `$timer` in `StoryInit`, and names the DSL guide's component and cross-reference comment blocks instead of using fixed line fragments. Working relative Markdown links were preserved. RuleSync references in Workflow.md were normalized as text only; excluded directories were not opened, edited, or regenerated. Report line citations remain evidence locators, not permanent generation instructions. No story sources or runtime code changed for P06.

**Residual resolved after consistency review:** Removed the leading slash from the rule-source references in [workspace.dsl:38](/Users/kbonilla/Projects/TwineListen/docs/workspace.dsl:38) and [Tactical-Graph_TEMPLATE.dsl:38](/Users/kbonilla/Projects/TwineListen/docs/Tactical-Graph_TEMPLATE.dsl:38). Both now use `.rulesync/skills/tactical-gen/SKILL.md`, consistent with repository-relative paths. Only these guide comments changed for this follow-up; excluded RuleSync sources were not opened, edited, or regenerated. The broader regeneration-overwrite caveat remains separate.

### P07 — Resolved — Mandatory next-scene handoff lacks development and ending boundaries

**Original evidence:** Tactical-gen required exactly one next-scene relationship with both endpoints declared, alongside outgoing timers for every non-GO passage. These useful progression safeguards lacked explicit treatment of an undeveloped successor or an intentional ending. The existing graph had a generic `PLACEHOLDER` entry; Twee already used `[stub]`, but ownership, exceptions, and replacement behavior were incomplete.

**Workflow impact:** When generating the final scene, an agent can invent another scene, create an unnecessary stub, or stop for clarification because a required target does not exist. Generating an intermediate scene whose successor is not declared also lacks a clear model-level policy. Workflow's Twee-stub policy does not itself create a DSL endpoint.

**Resolution:** A developed continuing scene keeps its planned handoff, even into undeveloped content. Graph work may create only the planned successor's missing chapter/scene/entry declarations, preserving existing content. WIP entries retain `p01_rg`/`P01`, use empty stat effects and `Passage,Passage-Stub` tags, and explicitly describe their unfinished status. They stop without outgoing actions/timers and do not count as authored content or deaths; placeholder-only scenes are exempt from full-scene requirements until developed. Genuine endings use `Passage,Passage-Ending`; explicitly final scenes use `Scene-Final` and need no successor. No marker may be inferred from missing content or used to hide broken routes. These use ordinary [Structurizr tags](https://docs.structurizr.com/dsl/language#tags).

Twee work keeps one exact-title real passage or `[stub]` per declared target across all scene files. Stubs show visible WIP text, contain no state effects or onward progression, and are exempt from dialogue expansion. Developing a scene preserves its entry title and incoming links, removes stub markers, and narrowly removes superseded/duplicate tagged stubs from predecessor files without rewriting other content. This explicitly qualifies P05's file-ownership boundary. Validation reports remaining WIP separately from defects and completed scenes. Both skills, workflow checks, and DSL guide comments now agree. The existing `c02.s01.p01_rg`/`c02.s01.P01` placeholder was marked accordingly; no next-scene content was invented.

**Validation:** Structurizr CLI validation and Tweego compilation passed using temporary native tooling. Both edited skills pass the skill validator. All 33 navigation/visit references resolve with no duplicate titles. The compiled WIP passage retains `[stub]` and has no state/progression macros; all other compiled passages and graph relationships remain unchanged. No interactive playthrough was performed.

### P08 — Resolved — The copyable timer example bypasses the required shared duration

**Original evidence:** Twee-gen required the shared timer variable for uniform duration, but its [canonical example][timer-example] hardcoded `3`. The current [shared timer][timer] is `30`; other examples and existing scene passages already used `$timer`.

**Workflow impact:** Copying the example produces a scene that ignores the shared timing control. Long required monologues can then inherit a three-second timer unintentionally.

**Resolution:** The canonical example now uses `<<timedprogressbar $timer>>`, matching the shared-duration rule and other examples. No runtime source or timer setting was changed.

### P09 — Resolved — Recursive documentation scanning is broader than the generation task

**Original evidence:** Twee-gen directed a recursive scan of the SugarCube documentation. The referenced local library contained 42 files totaling 756,726 bytes. [Workflow Prompt 6][workflow-twee] described it as a reference.

**Workflow impact:** Interpreting “recursively scan” as reading the entire library can add substantial context and latency to a small scene edit. The instruction does not explicitly require reading every file, so this is a process risk rather than a confirmed conflict.

**Resolution:** The [documentation instruction][sugarcube-scan] now directs targeted searches for task-relevant APIs, reading matching sections and necessary dependencies, and expanding the search when unresolved questions require it. It explicitly states that a full-library read is not required. No runtime files changed for P09.

## Consistency review of revised guidance

Reviewed the three project skills in full, AGENTS.md, Workflow.md, narrative-rules.md, and both DSL guide headers together. RuleSync and Cursor exclusions remain unchanged. Targeted reads of the local SugarCube documentation, the bundled SugarCube 2.37.3 visit-count implementation, and the existing timer macro checked technical claims. Official SugarCube documentation was also consulted. The template's illustrative model and existing authored narrative were not re-audited.

No further disagreement was found in the attempt-versus-outcome agency contract between graph and dialogue generation, canonical dotted titles, fresh-game versus respawn initialization, phase ownership, Respawn label exceptions, or marked WIP/ending boundaries. This is a static consistency finding, not proof that existing story content or every future graph complies.

### P10 — Resolved — The visit-count example skips its own first-visit branch

**Original evidence:** [twee-gen:60](/Users/kbonilla/Projects/TwineListen/.agents/skills/twee-gen/SKILL.md:60) says that, inside passage C, `visited("C") == 0` triggers Game Over and `visited("C") > 0` continues. SugarCube includes the displayed passage in its visit count. On the first display of C, the count is 1, so the example's Game Over branch cannot run there. The [official visited() documentation](https://www.motoslave.net/sugarcube/2/docs/#functions-function-visited) describes the count and demonstrates current-passage visits.

**Workflow impact:** An agent copying this example makes replay-only continuation available immediately and bypasses the intended first-visit consequence.

**Resolution:** Corrected the example to use the canonical title `c01.s01.P03`, `== 1` for its first visit, and `> 1` for revisits. Clarified that `== 0` applies when checking a different, not-yet-visited passage. Both example outcomes explicitly follow the DSL; no new first-visit death requirement was introduced. Runtime story sources and excluded RuleSync sources remain unchanged.

**Verification:** Executed the bundled SugarCube 2.37.3 `visited()` function with explicit first-arrival and revisit histories. It returned 1 and 2 respectively; the original example continued in both cases. This was a function-level check, not an interactive playthrough.

### P11 — Resolved — Prompt 6 broadens monologue requirements to Game Over passages

**Original evidence:** [Workflow.md:227](/Users/kbonilla/Projects/TwineListen/docs/Workflow.md:227) requires an immersive Leon monologue for authored non-stub passages, which includes Game Overs. [twee-gen:27](/Users/kbonilla/Projects/TwineListen/.agents/skills/twee-gen/SKILL.md:27) limits mandatory expansion to non–Game Over passages; [line 32](/Users/kbonilla/Projects/TwineListen/.agents/skills/twee-gen/SKILL.md:32) permits shorter Game Overs with a consequence line and Respawn links. Workflow's own [Prompt 7 check](/Users/kbonilla/Projects/TwineListen/docs/Workflow.md:257) uses the narrower non-GO scope.

**Workflow impact:** An agent following Prompt 6 may pad short deaths with required monologues, then apply a different standard during verification.

**Resolution:** Prompt 6 now limits mandatory monologue expansion to authored non-GO, non-stub passages. It explicitly allows brief Game Overs with optional Leon dialogue, while requiring a clear consequence, narrative value under the shared narrative rules, and visible DSL-mapped Respawn links. WIP and ending treatment is preserved. Checked agreement with twee-gen and Prompt 7; no story sources or skill files changed for P11.

### P12 — Resolved — Mathematical range conditions lack an explicit translation rule

**Original evidence:** [tactical-gen:125](/Users/kbonilla/Projects/TwineListen/.agents/skills/tactical-gen/SKILL.md:125) and the [DSL guide:36](/Users/kbonilla/Projects/TwineListen/docs/workspace.dsl:36) demonstrate `11 <= Stress <= 16`. Twee generation must preserve conditions, but gives no explicit expansion of chained mathematical comparisons into two SugarCube comparisons. [Workflow.md:245](/Users/kbonilla/Projects/TwineListen/docs/Workflow.md:245) recognizes syntax differences without supplying this particular mapping.

**Workflow impact:** Literal transcription as `11 <= $stress <= 16` changes the gate's meaning. A JavaScript check returned true at stress 0, 17, and 100, where the intended range is false. This is a copy/translation risk; no current scene defect is asserted.

**Resolution:** Added a concise conversion rule to twee-gen: `11 <= Stress <= 16` becomes `($stress >= 11 && $stress <= 16)`. It requires preserving inclusive/exclusive bounds and logical grouping, and warns against copying chained comparisons literally into Twee. Existing visit-title mapping is preserved. SugarCube's [conditional operator documentation](https://www.motoslave.net/sugarcube/2/docs/#twinescript) likewise demonstrates a range using two comparisons joined with `and`. The tactical graph, its notation, and runtime sources were not changed.

### P13 — Resolved — Image authoring does not consume the shared agency and reveal constraints

**Original evidence:** [image-prompt-authoring's source priority](/Users/kbonilla/Projects/TwineListen/.agents/skills/image-prompt-authoring/SKILL.md:19) and [authoring workflow](/Users/kbonilla/Projects/TwineListen/.agents/skills/image-prompt-authoring/SKILL.md:87) cover passages, graph, brief, plot, and reference imagery, but never reference narrative-rules.md. The shared file's [introduction](/Users/kbonilla/Projects/TwineListen/docs/narrative-rules.md:3) also scopes its use to graph descriptions and dialogue. Consequently, image instructions do not explicitly enforce the [agency and endgame reveal contract](/Users/kbonilla/Projects/TwineListen/docs/narrative-rules.md:12).

**Workflow impact:** A visual interpretation can establish bodily contact or reveal the player's nature even when textual authoring carefully leaves an attempt unresolved. This is a coverage gap, not a confirmed violation in existing images or prompts.

**Resolution:** Added a narrow reference in image-prompt-authoring to the existing Player agency section as read-only visual constraints. It requires ambiguity in physical attempts, avoids depicting completed player contact or player-caused physical effects, and preserves the planned endgame reveal timing. The skill explicitly limits this read to that section and retains director language. The shared reference introduction now identifies this image-authoring use. No new guidance file, image prompt, image asset, or story content was added or changed. Skill validation and the relative section link check passed.

The first consistency review itself changed only this report; subsequent approved fixes updated twee-gen for P10/P12, Workflow.md for P11, image-prompt-authoring plus the shared reference introduction for P13, and both DSL guide comments for the residual P06 references as recorded above. Those agreed fixes remain applied.

## Critical-only reassessment of the additional pass

Re-read the evidence for the five additional candidates: P11's revisit wording, P14's discovery/introduction convention, P15's visible action prefix, P16's illustrative IDs, and P17's possible timer overlap. The first four were minor instruction/example inconsistencies without a demonstrated material workflow failure. P17 described a hypothetical graph, not a defect found in the current scene. The current scene's two conditional timers from P08 use complementary visit conditions, so they do not establish the competing-transition problem.

All five candidates are withdrawn from the active audit rather than queued for remediation. The additional pass over-weighted minor and hypothetical issues. No new rule, exception, validation requirement, or skill change is proposed from that pass. P11's approved Prompt 6 correction remains applied; its withdrawn revisit observation does not reopen it.

The included local documentation links passed verification. RuleSync, Cursor, global rules, and external skills retain their existing exclusions. No further critical finding was established by this instruction review; this is not a comprehensive runtime or narrative-content audit.

## Project guidance with no confirmed conflict

- Image-prompt-authoring deliberately uses director language while story dialogue uses literary prose. These rules govern different output artifacts and can coexist.
- Image-prompt-authoring has an explicit source-priority order and separates process guidance from scene-prop canon. No concrete conflict among its scene baseline and current passage sources was established by this instruction-only audit.
- Scene Brief anchors being verbatim and passage descriptions being paraphrased govern different artifacts.
- Tactical-gen expressly permits respawn passages to omit ordinary user-action edges. That exception resolves the apparent clash with the general regular-passage action requirement.
- Repeated first-run, early-death, and respawn guidance creates maintenance overhead, but repetition alone is not a contradictory rule.

## Rules excluded from this revision

Exclusion means outside the report's subject, not that active host or tool requirements stop applying while the audit is performed.

| Excluded rule source or family | Reason and current status |
| --- | --- |
| Global `/Users/kbonilla/.codex/AGENTS.md` | Outside project scope; confirmed empty after the requested removal |
| Historical global Solana rules: MCP preference, first-call source discovery, canonical-doc/search routing, and Rust autofixer iteration | Removed from global AGENTS.md; not project rules |
| Codex host/session rules for communication, autonomy, authorization, tool orchestration, delegation, skills, output formatting, and app behavior | Runtime guidance rather than project-owned configuration; cross-layer findings from the earlier audit are dropped |
| Execution permissions and environment configuration | Host settings, not project-authored rules |
| Connector/MCP tool instructions and API contracts, including Solana MCP and Helius | External tool surfaces, not project rules; connections are unchanged by this audit |
| Rule-sync directories and their rule/skill copies; rule-sync generation configuration such as `rulesync.jsonc` | Retains the original exclusion; directory contents and configuration were not audited |
| Cursor directories and their rules/skill copies | Retains the original exclusion; contents were not inventoried or audited |
| Global, system, bundled, and plugin skill bodies and their supporting instructions | Individually listed below; outside project scope |
| Previous audit findings and generated story artifacts | Historical observations and implementation content are not new governing rules; main.twee was used only to check specific local contracts |

References to excluded sources inside included files were recognized as references only. Their targets were not followed, and no claim is made to enumerate every file inside excluded directories.

## Skills excluded from this revision

The prior catalog contained 26 skills. Three project skills remain in scope. The following 23 are excluded: 22 remain available in the current catalog, and solana-dev was removed. Exclusion does not mean uninstallation.

| Skill | Scope/status |
| --- | --- |
| imagegen | System; still available |
| openai-docs | System; still available |
| skill-creator | System; still available |
| skill-installer | System; still available |
| solana-dev | Former global personal skill; removed and absent from current catalog |
| google-drive:google-drive | Plugin; still available |
| google-drive:google-docs | Plugin; still available |
| google-drive:google-drive-comments | Plugin; still available |
| google-drive:google-sheets | Plugin; still available |
| google-drive:google-slides | Plugin; still available |
| plugin-management:plugin-management | Plugin; still available |
| sites:sites | Plugin; still available |
| sites:sites-remix | Plugin; still available |
| work-pets:create-pet | Plugin; still available |
| work-pets:pets | Plugin; still available |
| work-pets:update-pet | Plugin; still available |
| documents:documents | Artifact runtime; still available |
| pdf:pdf | Artifact runtime; still available |
| presentations:Presentations | Artifact runtime; still available |
| spreadsheets:Spreadsheets | Artifact runtime; still available |
| spreadsheets:excel-live-control | Artifact runtime; still available |
| template-creator:template-creator | Artifact runtime; still available |
| visualize:visualize | Bundled; still available |

The on-disk system review-agent skill noted in the earlier inventory was never part of the supplied session catalog and remains excluded. Skills inside the excluded Cursor and rule-sync directories were not inventoried, so this list covers known session skills rather than claiming a directory-wide census.

## Changes from the previous report

- Retained and renumbered original F03, F04, and F08 as P01, P02, and P05.
- Dropped original F01, F02, F05–F07, and F09–F16 because their subjects are outside project scope. Dropped does not mean resolved.
- Added project-specific findings P03, P04, and P06–P09 after checking local workflow and source contracts.
- Removed global and plugin remediation recommendations. The initial project-only revision changed only this report; subsequent P01 remediation updated both generation skills and added the shared player-agency contract.
- P02 added the Respawn exception; P03 aligned dotted title mapping across instructions and migrated existing identifiers and prompt headers. Cursor and rule-sync exclusions remain in place. The project skill files are Git-ignored generated configuration; their excluded RuleSync sources have not been updated, so future regeneration can overwrite the skill edits.
- P04 aligned state lifecycle guidance; P05 extracted shared narrative guidance and defined graph-versus-Twee write ownership and graph-defect handling.
- P05 follow-up consolidated player agency and narrative guidance into one shared reference, updated callers, and removed the redundant file. Plot-Device remains story canon rather than an additional container for authoring rules.
- P06 clarified path resolution and replaced fixed instruction line fragments with searchable code and guide names.
- P07 added explicit WIP/ending boundaries, narrow successor-scaffolding and tagged-stub cleanup permissions, and marked the existing successor placeholder. The DSL template's guide comments were aligned; its illustrative model was not rewritten.

P01–P13 retain their agreed fixes. The five additional candidates have been withdrawn after criticality reassessment; no further critical remediation is queued. Preserve the agreed story intent and graph-to-Twee mapping; graph corrections remain a separate phase from dialogue generation. The excluded RuleSync sources were not updated, so regenerating the Git-ignored project skills can overwrite the agreed fixes.

[image]: /Users/kbonilla/Projects/TwineListen/.agents/skills/image-prompt-authoring/SKILL.md
[tactical]: /Users/kbonilla/Projects/TwineListen/.agents/skills/tactical-gen/SKILL.md
[twee]: /Users/kbonilla/Projects/TwineListen/.agents/skills/twee-gen/SKILL.md
[workflow]: /Users/kbonilla/Projects/TwineListen/docs/Workflow.md
[guide]: /Users/kbonilla/Projects/TwineListen/docs/workspace.dsl:1
[agency]: /Users/kbonilla/Projects/TwineListen/docs/narrative-rules.md:12
[narrative]: /Users/kbonilla/Projects/TwineListen/docs/narrative-rules.md
[stationary]: /Users/kbonilla/Projects/TwineListen/.agents/skills/twee-gen/SKILL.md:23
[actions]: /Users/kbonilla/Projects/TwineListen/.agents/skills/tactical-gen/SKILL.md:111
[unique]: /Users/kbonilla/Projects/TwineListen/.agents/skills/tactical-gen/SKILL.md:117
[action-check]: /Users/kbonilla/Projects/TwineListen/.agents/skills/tactical-gen/SKILL.md:245
[respawn]: /Users/kbonilla/Projects/TwineListen/.agents/skills/tactical-gen/SKILL.md:37
[counts]: /Users/kbonilla/Projects/TwineListen/docs/Workflow.md:136
[mapping]: /Users/kbonilla/Projects/TwineListen/.agents/skills/twee-gen/SKILL.md:72
[verify-mapping]: /Users/kbonilla/Projects/TwineListen/docs/Workflow.md:254
[globals]: /Users/kbonilla/Projects/TwineListen/.agents/skills/twee-gen/SKILL.md:53
[storyinit]: /Users/kbonilla/Projects/TwineListen/src/main.twee:283
[workflow-start]: /Users/kbonilla/Projects/TwineListen/docs/Workflow.md:228
[twee-entry]: /Users/kbonilla/Projects/TwineListen/.agents/skills/twee-gen/SKILL.md:12
[tactical-entry]: /Users/kbonilla/Projects/TwineListen/.agents/skills/tactical-gen/SKILL.md:13
[twee-style]: /Users/kbonilla/Projects/TwineListen/.agents/skills/tactical-gen/SKILL.md:48
[workflow-twee]: /Users/kbonilla/Projects/TwineListen/docs/Workflow.md:203
[regeneration]: /Users/kbonilla/Projects/TwineListen/docs/Workflow.md:68
[macro-refs]: /Users/kbonilla/Projects/TwineListen/.agents/skills/twee-gen/SKILL.md:55
[macro]: /Users/kbonilla/Projects/TwineListen/src/main.twee:151
[timer]: /Users/kbonilla/Projects/TwineListen/src/main.twee:286
[handoff]: /Users/kbonilla/Projects/TwineListen/.agents/skills/tactical-gen/SKILL.md:210
[timer-example]: /Users/kbonilla/Projects/TwineListen/.agents/skills/twee-gen/SKILL.md:78
[sugarcube-scan]: /Users/kbonilla/Projects/TwineListen/.agents/skills/twee-gen/SKILL.md:52
