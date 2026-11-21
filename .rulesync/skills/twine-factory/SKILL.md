---
name: twine-factory
description: Start, resume, review, or close an isolated TwineListen scene candidate in a Git worktree. Use twine-workflow to produce the scene in that checkout.
targets:
  - '*'
---

# Twine scene factory

Use `tools/scene-factory.mjs` to manage one open candidate per repository. Use `twine-workflow` for scene generation, reviews, repairs, and playtest. Keep the candidate on its own branch. Bring changes into the source checkout only on explicit request.

## Commands

Run `node <absolute-path-to-tools/scene-factory.mjs> <command>` with the corresponding arguments below. Use the helper from the checkout where this skill is installed, with that checkout or the candidate as the command's working directory. This also works when the selected base predates the helper. The JSON response gives the candidate's `worktree`, base, phase, and local `report` path.

| Invocation | Helper and handoff |
| --- | --- |
| `$twine-factory start c01.s01 --base HEAD` | `start c01.s01 --base HEAD`, then ask `twine-workflow` to generate through graph review. An explicit `--revise` starts with a targeted revision. |
| `$twine-factory status` | `status`, then summarize the open run and its next step. |
| `$twine-factory resume c01.s01` | `resume c01.s01`, then continue from the recorded phase and verified work. |
| `$twine-factory revise c01.s01` with feedback | `revise c01.s01`, then ask `twine-workflow` to revise through graph review. Pass `--rewrite` for fresh generation or `--audit` to review manual edits, including a brief audit if the brief changed. |
| `$twine-factory continue c01.s01 --approve <checkpoint-sha>` | `continue c01.s01 --approve <checkpoint-sha>`, then ask `twine-workflow` to produce, audit, build, and playtest Twee from the approved graph. |
| `$twine-factory close c01.s01` | `close c01.s01` to release the slot and keep the candidate branch, worktree, and report. |

Start from an explicitly selected commit containing the story and rules to use. The slot stays open during review and until closed. Use one coordinator at a time for writes to the candidate.

## Hand off to the workflow

Load `twine-workflow` from the candidate's RuleSync installation. Apply it with the scene ID, candidate root, requested operation, and endpoint. All assistant and worker file paths and commands for scene work use that root. Follow the workflow's role-launch check against the candidate's generated profiles. A role in the source session may point to a different profile. For an approved Twee run, prepare the candidate's ignored `build/` directory and stage available preview media from the source checkout's `include/`. The workflow handles the existing TweeGo build and playtest from the candidate root.

Use the workflow's reported stage verdicts, evidence, and limitations to update `report` after each audit. Record `git hash-object` results for the reviewed artifacts, including changed neighboring Twee files. When resuming, compare those hashes before reusing a verdict and rerun the first affected audit if an artifact changed.

## Save the outcome

- **`setup`**. `resume` retries worktree setup or skill installation.
- **`graph`**. After the workflow reports a passing graph audit and confirms the change scope, call `checkpoint <scene>`. Present the graph diff and full checkpoint SHA and wait for the user's decision.
- **`approval`**. Wait for a revision, rewrite, or approval of the current SHA. If the graph changed, route it through `revise --audit` and present a new checkpoint. The helper rejects stale approval and reports other unexpected changes for inspection.
- **`twee`**. Call `finish <scene>` after the workflow passes its audit, build, and playtest. Keep blocked work in the candidate and resume from the checks already verified. For graph defects, return the workflow's findings and wait for a requested graph revision. Preserve any unfinished Twee work before reopening graph review.
- **`complete`**. Present the branch, diff against the base, playable HTML, and findings. Closing releases the slot.

If a requested feature needs changes to `src/main.twee`, include the shared changes in the Twee audit and playtest. Present the reviewed diff and its file hash from `git hash-object -- src/main.twee` in the candidate root. After the user explicitly approves that version, pass `finish <scene> --approve-shared <blob-sha>`. If the file changes, repeat the affected checks and obtain approval for the new version.
