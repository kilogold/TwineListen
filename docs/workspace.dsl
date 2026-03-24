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
//   (Select a non-verbal label from the Scene Brief per the Cross-scene handoff policy; `timer` allowed but prefer `Act`).
//
// Relationship syntax:
// - Labels allowed (exact): "Act: <non-verbal action>" | "timer" (no variants)
//   - "Act: Respawn" is GO-only: allowed only from `pNN_go` to regular passages; use for restarts instead of `timer`.
// - Optional conditions append after a comma. Operands may include NPC state (Stress, Anger ∈ [0,100]) and visit counts via visited(PNN).
//   Example: p03_rg -> p04_go "Act: Hold the gaze, 11 <= Stress <= 16 || visited(P10) >= 2"
//
// See single source of truth for tactical generation rules: /.cursor/rules/tactical-gen.mdc
//
// Modeling guidance:
// - Interpret relationship direction as narrative continuity ("because ...").
// - Multiple incoming edges complement narrative ("and ...").
// - Multiple outgoing edges revisit with new information; ensure overall forward motion.

workspace "Plot Graph" "A narrative graph for \"Strangers in the Attic\"" {

    !identifiers hierarchical

    model {
        c01 = softwareSystem "Start" {
            s01 = container "Attic Encounter" {
                p01_rg = component "P01" "In the cold empty wooden attic at night time, Leon faces the wall and mutters in circles; your stillness must decide whether this room gets witnessed or disturbed." "Stress +4" "Passage"
                p02_rg = component "P02" "He remains facing toward the wall, hunched over, withered, and frail, while your fixed attention tightens the dark and pressures the moment toward contact or restraint." "Stress +4, Anger +2" "Passage"
                p03_rg = component "P03" "A few pages lie by the floorboards where he wrote notes to not forget; their edges flutter in the draft and tempt you to handle memory like evidence." "Stress +3" "Passage"
                p04_rg = component "P04" "Dust and splinters show how he has been going in circles, and each quiet second in the attic makes his pacing mind feel close enough to pull you off balance." "Stress +5" "Passage"
                p05_rg = component "P05" "The paper admits that reading feels worse, and the scrape of graphite turns the old house within a forest into a trap where memory sharpens faster than mercy." "Stress +7" "Passage"
                p06_rg = component "P06" "You follow his breath through the supernatural sense in the air while the floorboards cool your hand, and patience becomes the only way to keep the night from tightening." "Stress -4, Anger -2" "Passage"
                p07_rg = component "P07" "From beside him you see how he stays facing toward the wall, rotting away in misery, and any closer movement now risks being mistaken for pressure instead of care." "Stress +2, Anger +6" "Passage"
                p08_rg = component "P08" "When you match the attic's still rhythm, his muttering loosens around night time and going in circles stops feeling endless, as if he may finally tolerate a witness." "Stress -3, Anger -2" "Passage"
                p10_go = component "P10" "His frail arm snaps with impossible force; boards crack under you, and the cold attic fills your mouth with dust as he teaches how badly touch can betray witness." "" "Passage-GameOver"
                p11_go = component "P11" "You crowd the wall and notes at once; Leon wheels with a feral shove, and the room turns splinters and black air, proving his pain punishes being handled like a puzzle." "" "Passage-GameOver"
                p12_rg = component "P12" "After the blow, the cold empty wooden attic returns with your body unmade and reformed; the sting teaches that sudden touch only proves you misread his boundary." "" "Passage"
                p13_rg = component "P13" "You gather again by the notes and wall dust, keeping the old house within a forest at a distance; dying here teaches that prying makes his pain strike back." "" "Passage"

                p01_rg -> p02_rg "Act: Hold the gaze"
                p01_rg -> p06_rg "Act: Lower your gaze"
                p01_rg -> p04_rg "timer"

                p02_rg -> p07_rg "Act: Shift your weight"
                p02_rg -> p10_go "Act: Touch his shoulder"
                p02_rg -> p06_rg "timer"

                p03_rg -> p05_rg "Act: Glance at the notes"
                p03_rg -> p06_rg "timer"

                p04_rg -> p03_rg "Act: Trace a circle in dust"
                p04_rg -> p07_rg "Act: Lean toward the wall"
                p04_rg -> p02_rg "timer"

                p05_rg -> p11_go "Act: Reach toward the notes, 14 <= Stress <= 100"
                p05_rg -> p08_rg "timer"

                p06_rg -> p08_rg "Act: Count breaths"
                p06_rg -> p03_rg "Act: Rest a hand on the floorboards"
                p06_rg -> p04_rg "timer"

                p07_rg -> p11_go "Act: Step around Leon"
                p07_rg -> p08_rg "timer"

                p08_rg -> p10_go "Act: Touch his wrist, 8 <= Anger <= 100"
                p08_rg -> p05_rg "timer, visited(P10) < 1 && visited(P11) < 1"

                p10_go -> p12_rg "Act: Respawn"
                p11_go -> p13_rg "Act: Respawn"

                p12_rg -> p01_rg "timer"
                p13_rg -> p01_rg "timer"
            }
        }
        c02 = softwareSystem "Lost" {
            s01 = container "Feeling stuck" {
                p01_rg = component "P01" "PLACEHOLDER" "" "Passage"
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
        c01.s01.p08_rg -> c02.s01.p01_rg "timer, visited(P10) >= 1 || visited(P11) >= 1"

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
