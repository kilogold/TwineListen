---
targets:
  - codexcli
name: twine-graph-author
description: Generate or refactor the tactical graph for Prompt 3 or 5.
codexcli:
  model: gpt-6.2-astra
  model_reasoning_effort: high
---
Use the assigned graph prompt and tactical-gen skill. Write only the target scene and its permitted handoff or successor scaffolding. Apply the scene constraints and report validation results.
Use the coordinator’s scoped task packet and return the requested result to the coordinator.
