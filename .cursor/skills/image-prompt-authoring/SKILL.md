---
name: image-prompt-authoring
description: Author and revise image generation prompts for Twine passages using project scene sources and reference imagery. Use when editing docs/image_prompts.txt, matching prompts to passage state, enforcing canonical props, and preserving consistent environment framing across a scene.
---

# Image Prompt Authoring

## Purpose

Create standalone, generator-facing image prompts for Twine passages that stay faithful to project canon and visually coherent across the same scene.

Primary target file: `docs/image_prompts.txt`.

## Source Priority

Use sources in this order:

1. Passage-local truth:
   - `src/cNN.sNN.twee`
   - `docs/workspace.dsl`
2. Scene-level anchors and interaction hints:
   - `docs/briefs/cNN.sNN.json`
3. Shared plot backdrop:
   - `docs/Plot-Device.md`
4. Stable environment layout:
   - `include/images/attic_scene_reference.png` (when working on `c01.s01`)

`docs/Workflow.md` is workflow/process guidance, not canonical scene-prop content.

## Output Format

Use this block format in `docs/image_prompts.txt`:

```text
cNNsNNpNN

<single standalone prompt paragraph>
```

One blank line between passage id and prompt, and one blank line between blocks.

## Authoring Rules

- Every prompt is standalone. Do not rely on prior prompt context.
- Repetition is expected when the environment is mostly the same.
- Keep canonical scene props/architecture consistent across prompts.
- Keep passage-local focus distinct per passage.
- Name `Leon` first, then use pronouns.
- Use objective director language, not literary/narrative prose.
- Express constraints positively. Prefer positive framing over "no X / not Y".
- Avoid variance language like `or` when one concrete choice is available.

## Continuity Rules For `c01.s01`

Keep this baseline present across prompts:

- cold empty wooden attic at night
- old house within a forest
- far-end wall (Leon oriented toward this wall unless passage state dictates otherwise)
- steep pitched roof
- heavy dark crossbeams
- low side knee walls
- wide weathered floorboards
- cobwebbed upper corners
- moonlight entering from the rear opening
- deep roof/side shadows
- faint supernatural atmosphere

Treat notes/pages, dust, splinters, floorboards, and wall as persistent scene elements.
If a prop is not the local focus of a passage, keep it as continuity detail instead of removing it.

## Proportion / Framing Guardrails

When model drift inflates character scale, include explicit positive framing:

- `Leon shown at realistic room scale`
- `his full seated body visible`
- `occupying a small central portion of the frame`
- `wide environmental composition where the attic interior and floorboards dominate the image`

## Passage-Matching Workflow

1. Read target passage in `src/cNN.sNN.twee`:
   - narrator line for scene state
   - dialogue for emotional state
2. Read matching component in `docs/workspace.dsl`:
   - canonical passage emphasis and state direction
3. Check `docs/briefs/cNN.sNN.json`:
   - anchors and interactable object hints
4. Write/adjust prompt:
   - keep scene continuity
   - foreground passage-specific emotional and visual focus
5. Run a final check:
   - standalone, Leon-first, objective tone, positive constraints, no unsupported props

## Quality Checklist

- [ ] Passage id exists and matches scene passage naming (`cNNsNNpNN`)
- [ ] Prompt is standalone
- [ ] Leon named first, pronouns afterward
- [ ] Far-end wall orientation is respected when relevant
- [ ] Shared environment details remain consistent
- [ ] Passage-specific emotion matches Twee dialogue state
- [ ] Canonical props included; non-focused props remain continuity-level
- [ ] Proportion guardrails present when needed
- [ ] Language is objective, concise, and generator-facing
