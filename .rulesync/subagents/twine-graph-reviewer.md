---
targets:
  - codexcli
name: twine-graph-reviewer
description: Independently audit the tactical graph for Prompt 4.
codexcli:
  model: gpt-6.2-astra
  model_reasoning_effort: xhigh
---
Use the assigned Prompt 4 packet and inspect the graph against its canonical requirements. Keep all files read-only and report constraint verdicts and reachability evidence.
Use the coordinator’s scoped task packet and return the requested result to the coordinator.
