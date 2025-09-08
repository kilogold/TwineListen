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
                # Components (passages)
                p01_rg = component "P01" "He repeats 'Another day, another night' under his breath, looping in tiny rocks as if going in circles. The still attic waits while you decide how to attend his frail motion." "Stress +4" "Passage"
                p02_rg = component "P02" "A rasped 'I deserve my fate' leaks out, then he shrinks, eyes wet. The words hang while you weigh whether stillness soothes or stings in this brittle quiet—does anyone even care?" "Stress +6" "Passage"
                p03_rg = component "P03" "He flares—'It's her fault'—then retreats to 'no one is to blame.' The reversal frays the room; blame loops back on itself and tests the air around you." "Anger +8, Stress +2" "Passage"
                p04_rg = component "P04" "His memories blur with time and age; fingertips hover over notes as if steadying thought. You read the tremor and choose whether to guide the reach or let it blur longer." "Stress +6" "Passage"
                p05_rg = component "P05" "He eyes the notes he wrote; reading feels worse because he'll remember the pain. Paper scratches, breath shortens, and the attic seems to lean closer to listen." "Stress +8" "Passage"
                p06_rg = component "P06" "He shifts, going in circles; 'rotting away in misery' escapes. The cadence invites either grounding or a sharper snap that might split this night open." "Stress +6, Anger +2" "Passage"
                p07_rg = component "P07" "Your presence steadies the rhythm; his shoulders loosen as breath syncs. The loop softens toward the notes he fears, and a quiet chance to nudge without force appears." "Stress -4, Anger -4" "Passage"
                p08_rg = component "P08" "You hold the gaze; 'Another day, another night' thins to a murmur while dust hangs over the notes. A measured pause offers calm instead of a push." "Stress -2" "Passage"
                p09_rg = component "P09" "A tremor crawls his arm as your shadow shifts; the thought of 'rotting away in misery' tightens his jaw. Touch might steady the loop or snap it into something worse." "Anger +6" "Passage"
                p10_rg = component "P10" "He edges closer to the notes, then freezes. Bridging the gap feels like thin ice; the wrong weight could crack the night in two and flood the room with memory." "Stress +4, Anger +4" "Passage"
                p11_rg = component "P11" "'Remember the pain' rasps out as fingers hover; the attic hum closes in. A small gesture might soothe the memory or set it alight with blame and blur." "Stress +2, Anger +8" "Passage"
                p12_rg = component "P12" "He softens: 'no one is to blame' almost finds peace. The attic loosens its grip as you either step back into shadows or hold, letting him choose the pace." "Stress -6, Anger -4" "Passage"
                p13_go = component "P13" "His eyes flash; contact detonates the night. He lunges with sudden, brittle fury, and everything folds to black before breath can return." "" "Passage-GameOver"
                p14_go = component "P14" "Your touch tips him past the brink. A hoarse cry splits the stillness, wood cracks, and the scene ends with the weight of your mistake." "" "Passage-GameOver"

                # Relationships
                # Each non–GO passage has ≥1 timer; include ≥1 explicit user-choice GO (unconditional); touch actions branch by thresholds.
                p01_rg -> p02_rg "Act: hold the gaze on Leon"
                p01_rg -> p03_rg "timer"

                p02_rg -> p04_rg "Act: tilt head toward Leon"
                p02_rg -> p03_rg "timer"

                p03_rg -> p05_rg "Act: slide the notes closer"
                p03_rg -> p06_rg "timer"

                p04_rg -> p05_rg "Act: trace a circle in dust"
                p04_rg -> p06_rg "timer"

                p05_rg -> p07_rg "Act: brush dust from the floor"
                p05_rg -> p06_rg "timer"

                # Unconditional GO path
                p06_rg -> p13_go "Act: kneel beside Leon"
                p06_rg -> p07_rg "timer"

                p07_rg -> p09_rg "Act: steady your breath"
                p07_rg -> p08_rg "timer"

                p08_rg -> p10_rg "Act: glance at the notes"
                p08_rg -> p09_rg "timer"

                # Touch branches: GO when Anger > 35 or Stress > 60; otherwise continue
                p09_rg -> p13_go "Act: touch Leon's shoulder, Anger > 35 || Stress > 60"
                p09_rg -> p10_rg "Act: touch Leon's shoulder"
                p09_rg -> p08_rg "timer"

                p10_rg -> p14_go "Act: touch Leon's hand, Anger > 35 || Stress > 60"
                p10_rg -> p11_rg "Act: touch Leon's hand"
                p10_rg -> p11_rg "timer"

                p11_rg -> p14_go "Act: touch Leon's back, Anger > 35 || Stress > 60"
                p11_rg -> p12_rg "Act: touch Leon's back"
                p11_rg -> p12_rg "timer"

                p12_rg -> p01_rg "timer"
            }
        }
        c02 = softwareSystem "Lost" {
            s01 = container "Feeling stuck" {
                # Components (passages)
                p01_rg = component "P01" "He weighs whether to start over or salvage what's left; in this attic the air hardens. Your quiet posture can steady the loop or press him toward a sharper turn." "Stress +6" "Passage"
                p02_rg = component "P02" "He mutters he set aside my passions in exchange for money; the words lost the job dry his mouth. A small shift could cool the shame or set it burning." "Stress +6" "Passage"
                p03_rg = component "P03" "The marriage ledger opens in his stare; no legacy gnaws at his breath. Your stance might buffer the ache or tilt it into blame." "Anger +8, Stress +2" "Passage"
                p04_rg = component "P04" "To be remembered flickers beside no legacy; he tests the weight of both. A measured move could thin the sting or make the silence ring louder." "Stress +6" "Passage"
                p05_rg = component "P05" "He counts paths to salvage what's left or let it all go; the attic boards listen. Your rhythm can slow the churn or tighten its loop." "Stress +6" "Passage"
                p06_rg = component "P06" "Let it all go knots with start over; his jaw sets. A careless lean might creak the night and draw him to snap." "Stress +4, Anger +2" "Passage"
                p07_rg = component "P07" "A long breath takes to this attic; the ache thins as you hold steady. He feels the floor again, less like a trap and more like a place to stand." "Stress -6, Anger -4" "Passage"
                p08_rg = component "P08" "He traces options: start over, no legacy; both sting. Your small release might soften comparisons without promising a cure." "Stress -4" "Passage"
                p09_rg = component "P09" "He hovers near you; the marriage ledger strains. A wrong touch could flip the page into fury; a gentler cue might keep it from tearing." "Anger +6" "Passage"
                p10_rg = component "P10" "He names the cost of lost the job and the bargain in exchange for money. You decide if nearness steadies him or tips him into shame." "Stress +4, Anger +4" "Passage"
                p11_rg = component "P11" "No legacy rubs raw; your presence could ground the edge or sharpen it. The next motion will test whether pity feels like pressure." "Stress +2, Anger +8" "Passage"
                p12_rg = component "P12" "Set aside my passions softens under quieter air; he almost loosens. If you move with care, he may hold the calmer thread." "Stress -6, Anger -4" "Passage"
                p13_go = component "P13" "The post groans; he flares and rushes. Wood and breath collide—everything blanks before you can find balance." "" "Passage-GameOver"
                p14_go = component "P14" "Your contact detonates the moment; his brittle strength surges and the night cuts to black." "" "Passage-GameOver"

                # Relationships
                p01_rg -> p02_rg "Act: lower your gaze to the floor"
                p01_rg -> p03_rg "timer"

                p02_rg -> p04_rg "Act: glance at the ceiling beam"
                p02_rg -> p03_rg "timer"

                p03_rg -> p04_rg "Act: rest a hand on the beam"
                p03_rg -> p05_rg "timer"

                p04_rg -> p06_rg "Act: shift your weight"
                p04_rg -> p05_rg "timer"

                p05_rg -> p07_rg "Act: lengthen your exhale"
                p05_rg -> p06_rg "timer"

                # Unconditional GO path
                p06_rg -> p13_go "Act: lean against the post"
                p06_rg -> p07_rg "timer"

                p07_rg -> p08_rg "Act: unclench your jaw"
                p07_rg -> p09_rg "timer"

                p08_rg -> p10_rg "Act: knead your palms together"
                p08_rg -> p09_rg "timer"

                # Touch branches: GO when Anger > 35 or Stress > 60; otherwise continue
                p09_rg -> p14_go "Act: brush Leon's elbow, Anger > 35 || Stress > 60"
                p09_rg -> p10_rg "Act: brush Leon's elbow"
                p09_rg -> p10_rg "timer"

                p10_rg -> p14_go "Act: place a palm on Leon's forearm, Anger > 35 || Stress > 60"
                p10_rg -> p11_rg "Act: place a palm on Leon's forearm"
                p10_rg -> p11_rg "timer"

                p11_rg -> p14_go "Act: steady Leon's knee, Anger > 35 || Stress > 60"
                p11_rg -> p12_rg "Act: steady Leon's knee"
                p11_rg -> p12_rg "timer"

                p12_rg -> p08_rg "Act: trace the grain on a floorboard"
                p12_rg -> p01_rg "timer"
            }
            
            s02 = container "Lost job" {
                # Placeholder entry to enable cross-scene handoff from c02.s01
                p01_rg = component "P01" "A placeholder entry for Lost job; receiving handoff from Feeling stuck until the scene is authored." "" "Passage"
            }
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

        # Cross-scene relationships (declared after both endpoints exist)
        c01.s01.p12_rg -> c02.s01.p01_rg "Act: step back into the shadows"
        c02.s01.p12_rg -> c02.s02.p01_rg "Act: square your shoulders"

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