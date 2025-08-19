// [Instructions/Guide]
// Purpose:
// This file is the single source of truth for the plot graph using Structurizr DSL (C4-inspired) for an interactive narrative.
//
// Strict naming (no slugs):
// - NN token (naming convention): two-digit sequence number (01, 02, ...). NN is not a node.
// - Core nodes (identified using NN in their IDs):
//   - Chapters (softwareSystem): cNN = softwareSystem <chapter-name>
//   - Scenes (container): sNN = container <scene-name>
//   - Passages (component): pNN_<kind> = component <passage-name> <description> <status-effect> <tag>
//     - kind: rg | go (rg = regular, go = game over)
//
// Component parameters (in-order):
// - passage-name: short code (e.g., "P01"); second label is the human-readable title
// - description: concise narrative description
// - status-effect: "" or comma-separated NPC state deltas (e.g., "Stress +10, Anger +5")
// - tag: "Passage" | "Passage-GameOver"
//
// Addressing & cross-references:
// - Local (within same scene): pNN_<kind>
// - Fully qualified (across scenes/chapters): cNN.sNN.pNN_<kind>
// - DSL does not support forward references; declare elements before relationships.
// - Example (cross-scene): c01.s01.p03_rg -> c02.s01.p01_rg "Act: Step back"
//
// Relationship syntax:
// - Labels allowed (exact): "Act: <non-verbal action>" | "timer" (no variants)
// - Optional conditions append after a comma. Operands may include NPC state (Stress, Anger ∈ [0,100]) and visit counts via visited(PNN).
//   Example: p03_rg -> p04_go "Act: Hold the gaze, 11 <= Stress <= 16 || visited(P10) >= 2"
//
// Hard constraints:
// - Every non–game-over passage must have ≥1 outgoing "timer" edge.
// - Game Over passages (pNN_go) should have no outgoing edges.
// - Every scene must include ≥1 explicit "Act: ..." path to a Game Over passage.
// - Avoid dead-ends; gated paths must be reachable within 1–2 iterations under reasonable state.
// - Keep IDs stable across edits (cNN, sNN, pNN_<kind>).
//
// Modeling guidance:
// - Interpret relationship direction as narrative continuity ("because ...").
// - Multiple incoming edges complement narrative ("and ...").
// - Multiple outgoing edges revisit with new information; ensure overall forward motion.
//

workspace "Plot Graph" "A narrative graph for \"Strangers in the Attic\"" {

    !identifiers hierarchical
    
    model {
        c01 = softwareSystem "Start" {
            s01 = container "Attic Encounter" {
                p01_rg = component "P01" "A placeholder forward bridge from Feeling stuck to later scenes; used to satisfy model wiring until the scene is authored." "" "Passage"
            }
        }
        c02 = softwareSystem "Lost" {
            s01 = container "Feeling stuck" {
                p01_rg = component "P01" "A placeholder forward bridge from Feeling stuck to later scenes; used to satisfy model wiring until the scene is authored." "" "Passage"
            }
            
            # Cross-chapter progression from Start → Lost
            s02 = container "Lost job"
            s03 = container "Dead dreams of raising a family"
            s04 = container "Lost marriage"
            
             
            # TODO: Replace with low-level implied relationships.
            s01 -> s02
            s02 -> s03
            s03 -> s04        
        }
        c03 = softwareSystem "Family"
        c04 = softwareSystem "Marriage"
        c05 = softwareSystem "Long-term Relationship"

        # Overall thematic progression
        # TODO: Replace with low-level implied relationships.
        //c01 -> c02
        c02 -> c03
        c03 -> c04
        c04 -> c05

    }

    views {
        styles {
            element "Element" {
                color #ffffff
            }
            element "Person" {
                background #ba1e75
                shape person
            }
            element "Software System" {
                background #d92389
            }
            element "Container" {
                background #f8289c
            }
            element "Passage" {
                background #f8289c
            }
            element "Passage-GameOver" {
                background #691141
            }
            element "Database" {
                shape cylinder
            }
            relationship "Relationship" {
                width 420
            }
        }

        container c01 "Chapter-Start" "Testing View 1" {
            include "element.type==Container && ->element.parent==c01->"
            autolayout
        }

        container c02 "Chapter-Lost" "Testing View 2"{
            include "element.type==Container && ->element.parent==c02->"
            autolayout
        }

        component c01.s01 {
            include "element.type==Component && ->element.parent==c01.s01->"
            autolayout
        }

        component c02.s01 {
            include "element.type==Component && ->element.parent==c02.s01->"
            autolayout
        }

        systemlandscape "System-Landscape" "Story Chapters" {
            include *
            autolayout
        }
    }
}