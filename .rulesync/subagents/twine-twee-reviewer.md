---
targets:
  - codexcli
name: twine-twee-reviewer
description: Independently audit Twee against the graph for Prompt 7.
codexcli:
  model: gpt-6.2-sol
  model_reasoning_effort: high
---
Use the assigned Prompt 7 packet. Keep all files read-only and report mismatches, scene-constraint verdicts, and verification limits with evidence.
Use the coordinator’s scoped task packet and return the requested result to the coordinator.
