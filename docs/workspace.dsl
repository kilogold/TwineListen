// [Instructions/Guide]
// Purpose:
// This file is the single source of truth for the tactical graph using Structurizr DSL (C4-inspired) for an interactive narrative.
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
//   Additional boundary tags: "Passage,Passage-Stub" for WIP; "Passage,Passage-Ending" for an intentional ending (both retain pNN_rg IDs).
// - WIP entry: p01_rg with passage-name "P01", explicit work-in-progress description, empty status-effect, and Passage-Stub tag; no outgoing edges.
//   Declare only the planned successor's missing chapter/scene/entry before its incoming handoff. Do not invent scene content or a successor.
//   Placeholder-only scenes are exempt from full-scene gameplay/content quotas until developed; preserve the entry ID and incoming edges on expansion, then remove Passage-Stub.
// - Intentional ending: Passage-Ending may have no onward progression. A scene explicitly designated final by plot/request carries container tag Scene-Final and has no next-scene handoff.
//   Unmarked missing edges remain defects; Game Overs still require contextual respawns. WIP and ending markers are mutually exclusive.
//
// Addressing & cross-references:
// - Local (within same scene): pNN_<kind>
// - Fully qualified (across scenes/chapters): cNN.sNN.pNN_<kind>
// - DSL does not support forward references; declare elements before relationships.
// - Example (cross-scene): c01.s01.p03_rg -> c02.s01.p01_rg "Act: Step back"
//   (Select a non-verbal label from the Scene Brief per the Cross-scene handoff policy; `timer` allowed but prefer `Act`).
//
// Relationship syntax:
// - Labels allowed (exact): "Act: <non-verbal action>" | "timer" (no variants)
//   - "Act: Respawn" is GO-only: allowed only from `pNN_go` to regular passages; use for restarts instead of `timer`.
// - Optional conditions append after a comma. Operands may include NPC state (Stress, Anger ∈ [0,100]) and visit counts via visited(PNN).
//   Example: p03_rg -> p04_go "Act: Hold the gaze, 11 <= Stress <= 16 || visited(P10) >= 2"
//
// See single source of truth for tactical generation rules: .rulesync/skills/tactical-gen/SKILL.md
//
// Modeling guidance:
// - Interpret relationship direction as narrative continuity ("because ...").
// - Multiple incoming edges complement narrative ("and ...").
// - Multiple outgoing edges revisit with new information; ensure overall forward motion.

workspace "Tactical Graph" "A narrative graph for \"Strangers in the Attic\"" {

    !identifiers hierarchical

    model {
        c01 = softwareSystem "Start" {
            s01 = container "Attic Encounter" {
                // Fresh state: Stress = 0, Anger = 0. Clamp every integer state update to [0,100].
                // Respawn effects below run once on arrival; entry never resets state or visit history.
                p01_rg = component "P01" "The cold empty wooden attic carries Leon's uneven mutter through the dark. He sits apart, and listening offers no clue yet whether your attention is welcome." "Stress +2" "Passage"
                p02_rg = component "P02" "Leon sits facing toward the wall, hunched over, withered, and frail. His shoulders stiffen between breaths; the space behind him begins to feel like a boundary." "Stress +4, Anger +4" "Passage"
                p03_rg = component "P03" "Darkness fills the cold empty wooden attic as Leon keeps muttering to himself. Each pause seems to invite attention, but the next murmur leaves that invitation uncertain." "Stress +2" "Passage"
                p04_rg = component "P04" "I deserve my fate gives way to It's her fault as Leon shakes his head. He remains facing toward the wall; following the reversal may expose pain he cannot yet hold still." "Stress +4, Anger +4" "Passage"
                p05_rg = component "P05" "The notes lie within Leon's downward gaze; he explains that reading feels worse. Paper rustles as he bends nearer, leaving memory visible without making it yours to handle." "Stress +4" "Passage"
                p06_rg = component "P06" "Leon is still muttering to himself, but It's her fault trails into uncertainty. His jaw eases during the silence; staying with that pause may allow something beyond blame." "Stress -4, Anger -4" "Passage"
                p07_rg = component "P07" "Leon bows over the notes, hunched over, withered, and frail. His fingers curl beside the paper; your interest might be mistaken for a claim on what he fears remembering." "Stress +2, Anger +8" "Passage"
                p08_rg = component "P08" "Leon admits he is going in circles, and reading feels worse because it brings the pain back. His voice thins; witnessing the circle may matter more than finding its culprit." "Stress -4, Anger -2" "Passage"
                p09_rg = component "P09" "Another day, another night falls softly into the cold empty wooden attic. Leon lets the next breath finish before beginning again; the pause can hold company without an answer." "Stress -2, Anger -2" "Passage"
                p10_go = component "P10" "Still facing toward the wall, Leon lashes backward at the approach he suspects. A blow breaks your neck; his frailty concealed a terror of having someone at his back." "" "Passage-GameOver"
                p11_go = component "P11" "Leon folds over the notes, then strikes toward your perceived interest. The impact stops your breath for good; keeping memory intact matters to him even when reading feels worse." "" "Passage-GameOver"
                p12_rg = component "P12" "The cold empty wooden attic surrounds you again, with Leon facing toward the wall. His shoulders tense before his voice returns; the same distance now carries the warning of the blow." "Stress = floor(Stress / 2), Anger = 0" "Passage"
                p13_rg = component "P13" "Leon is muttering to himself again, and the notes remain beside him. The paper's faint rustle recalls the fatal strike; returning attention need not become a claim on his memory." "Stress = floor(Stress / 2), Anger = 0" "Passage"
                p14_rg = component "P14" "Another day, another night sounds different after Leon's earlier reversal. His mouth stills around I deserve my fate; the repeated words seem less certain than their rhythm suggests." "Stress -2" "Passage"

                p01_rg -> p02_rg "Act: Listen to Leon's muttering"
                p01_rg -> p03_rg "Act: Glance across the wooden attic"
                p01_rg -> p02_rg "timer"

                p02_rg -> p10_go "Act: Try to close the distance to Leon"
                p02_rg -> p04_rg "Act: Hold your gaze on the wall beyond Leon"
                p02_rg -> p03_rg "timer"

                p03_rg -> p06_rg "Act: Watch Leon's frail shoulders"
                p03_rg -> p04_rg "timer"

                p04_rg -> p05_rg "Act: Notice the notes"
                p04_rg -> p06_rg "timer"

                p05_rg -> p07_rg "Act: Study the notes from a distance"
                p05_rg -> p08_rg "timer"

                p06_rg -> p14_rg "Act: Follow the pauses in Leon's muttering, visited(P04) >= 2"
                p06_rg -> p09_rg "Act: Listen through the unfinished murmur"
                p06_rg -> p08_rg "timer"

                p07_rg -> p11_go "Act: Try to reach toward the notes, Stress >= 12"
                p07_rg -> p06_rg "Act: Try to draw your attention back from the notes"
                p07_rg -> p08_rg "timer"

                p08_rg -> p09_rg "Act: Lower your gaze from Leon's hunched back"
                p08_rg -> p09_rg "timer"

                p09_rg -> p06_rg "Act: Attend to the silence between breaths"
                p09_rg -> p03_rg "timer"

                p10_go -> p12_rg "Act: Respawn"
                p11_go -> p13_rg "Act: Respawn"
                p12_rg -> p01_rg "timer"
                p13_rg -> p01_rg "timer"

                p14_rg -> p08_rg "Act: Hold your attention through Leon's hesitation"
                p14_rg -> p09_rg "timer"
            }
        }
        c02 = softwareSystem "Lost" {
            s01 = container "Feeling stuck" {
                p01_rg = component "P01" "Work in progress: the planned Feeling stuck scene has not been developed yet. This entry preserves the handoff and stops the current build." "" "Passage,Passage-Stub"
            }

            s02 = container "Lost job" {
            }
            s03 = container "Dead dreams of raising a family"
            s04 = container "Lost marriage"
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

        # Cross-scene relationships (declared after both endpoints exist)
        c01.s01.p08_rg -> c02.s01.p01_rg "Act: Try to shift farther from Leon, visited(P10) >= 1 || visited(P11) >= 1"

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
