# Summary
This document describes the development workflow of the project.

# Workflow A
1. Author a high-level thematic [progression graph](/docs/Plot-Device.md#graph).
2. Detail the [narrative context for each progression](/docs/Plot-Device.md#plot-detail).
3. Author a corresponding tactical graph for each [progression graph](/docs/Plot-Device.md#graph) node.
  - Consider using C4 modeling:
    | C4 Term     | Project Mapping                        |
    |-------------|----------------------------------------|
    | Code        | Sugarcube dialogue script              |
    | Component   | Passage                                |
    | Container   | Thematic progression graph node        |
    | Context     | Thematic progression subgraph (chapter)|
    | Landscape   | The entire story                       |
4. AI generate dialogue script from tactical graph.
    - Generate one chapter at a time to quickly iterate and tweak.

# Workflow B
1. Directly generate Twee from [Plot Device](/docs/Plot-Device.md).