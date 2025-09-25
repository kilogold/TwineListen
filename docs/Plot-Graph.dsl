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
// - Optional conditions append after a comma. Operands may include NPC state (Stress, Anger ∈ [0,100]) and visit counts via visited(PNN).
//   Example: p03_rg -> p04_go "Act: Hold the gaze, 11 <= Stress <= 16 || visited(P10) >= 2"
//
// See single source of truth for tactical generation rules: /.cursor/rules/tactical-gen.mdc
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
                p01_rg = component "P01" "The player enters a cold empty attic near a river; Leon sits muttering to himself in the darkness at the center of the attic, the air taut like held breath." "Stress +6" "Passage"
                p02_rg = component "P02" "Shadows edge the rafters as the player lingers; the attic environment tightens around the hush, and Leon's small movements betray how long he has been here." "Stress +4" "Passage"
                p03_rg = component "P03" "Another day, another night loops in his posture; you steady your stance, testing whether presence alone calms the room or stirs the quiet muttering." "Stress +2" "Passage"
                p04_rg = component "P04" "You lower your gaze into the darkness; dust motes drift like doubt while he faces the wall, and the center of the attic feels suddenly very near." "Stress +3" "Passage"
                p05_rg = component "P05" "You glance across the beams and the center of the attic; the space listens back, and your patience presses a question that needs no words." "Stress +2" "Passage"
                p06_rg = component "P06" "Muttering to himself, he barely acknowledges the player; silence invites a decision—hold, move, or risk touch that might disturb brittle resolve." "Anger +2" "Passage"
                p07_rg = component "P07" "A scrap of paper near him recalls I wrote  notes; reading feels worse, yet the boxy folds promise memory if you point or pick one gently free." "Stress +5" "Passage"
                p08_rg = component "P08" "You count breaths, slow and square; the attic environment softens a shade, and the hush makes room for steadier listening." "Stress -8, Anger -4" "Passage"
                p09_rg = component "P09" "You look into the darkness beyond his shoulder; boards creak and the cold lifts gooseflesh as the room tests your resolve." "Stress +4" "Passage"
                p10_rg = component "P10" "Edges blur at the center as you inch closer; how long has it been hangs between you, and the floor threatens to shift under a reckless step." "Stress +6" "Passage"
                p11_go = component "P11" "You step without caution; the floor snaps your balance and Leon flinches hard—panic flashes, the fragile scene shatters into a hard reset." "" "Passage-GameOver"
                p12_rg = component "P12" "Breath returns in a shiver; shadows reseat and the attic owns your stillness again, a quiet respawn that leads you back to the first position." "" "Passage"
                p13_rg = component "P13" "Your gentleness steadies him; touch withdraws as if prayer, and the muttering softens without breaking the brittle quiet." "Stress -4, Anger -2" "Passage"
                p14_go = component "P14" "The contact spikes old anger; he jerks away and the room turns hostile—his withered frame recoils, and the moment collapses to black." "" "Passage-GameOver"
                p15_rg = component "P15" "He recoils, then settles; the attic rewrites the distance, returning you to a safer remove that funnels back to the beginning stance." "" "Passage"
                p16_rg = component "P16" "Touch hangs on a knife-edge; if his Stress or Anger runs high, the same gesture backfires; if low, patience buys you another breath." "" "Passage"

                # Relationships (declare after components)
                p01_rg -> p02_rg "timer"
                p01_rg -> p03_rg "Act: Hold the gaze"

                p02_rg -> p03_rg "timer"
                p02_rg -> p04_rg "Act: Lower your gaze"

                p03_rg -> p05_rg "timer"
                p03_rg -> p05_rg "Act: Glance at the attic"

                p04_rg -> p06_rg "timer"
                p04_rg -> p09_rg "Act: Look into the darkness"

                p05_rg -> p06_rg "timer"
                p05_rg -> p07_rg "Act: Point at the notes"

                p06_rg -> p16_rg "timer"
                p06_rg -> p16_rg "Act: Rest a hand on Leon's shoulder"
                p06_rg -> p16_rg "Act: Touch Leon's back"
                p06_rg -> p16_rg "Act: Brush Leon's arm"

                p07_rg -> p08_rg "timer"
                p07_rg -> p08_rg "Act: Pick up the notes"
                p07_rg -> p10_rg "timer, visited(P01) >= 2"

                p08_rg -> p05_rg "timer"
                p08_rg -> p06_rg "Act: Raise your gaze"

                p09_rg -> p10_rg "timer"
                p09_rg -> p08_rg "Act: Count breaths"

                p10_rg -> p06_rg "timer"
                p10_rg -> p11_go "Act: Step closer to the center"

                p11_go -> p12_rg "timer"
                p12_rg -> p01_rg "timer"

                p16_rg -> p14_go "timer, Anger > 35 || Stress > 60"
                p16_rg -> p13_rg "timer, Anger <= 35 && Stress <= 60"
                p16_rg -> p13_rg "Act: Withdraw your hand"

                p13_rg -> p05_rg "timer"
                p13_rg -> p06_rg "Act: Step back"
                p14_go -> p15_rg "timer"
                p15_rg -> p01_rg "timer"
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
        c01.s01.p06_rg -> c02.s01.p01_rg "Act: Shift your weight, visited(P11) >= 1 || visited(P14) >= 1"

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