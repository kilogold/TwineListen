// [Instructions/Guide]
// Summary:
// This Structurizr DSL C4 model is adapted for interactive narrative building. 
// It is unconventional, but works for rendering a story graph via Structurizr.
//
// Nomenclature:
// - Chapters (softwareSystem): ch_<chapter_slug> = softwareSystem <chapter-name>
// - Scenes (container): scn_<scene_slug> = container <scene-name>
// - Passages (component): pNN_<kind>_<slug> = component <passage-name> <description> <status-effect> <tag>
//     - Naming convention:
//         - NN: two-digit sequence number (01, 02, ...)
//         - kind: rg | go
//             - rg: regular passage (tag "Passage")
//             - go: game over (tag "Passage-GameOver")
//     - Parameters:
//         - passage-name: a short code (e.g., "P01"); second label is human-readable
//         - description: a short description of the passage.
//         - status-effect: Empty string ("") or comma-separated list of one-or-more NPC state variable increments/decrements. For example: "Stress +10, Anger +5".
//         - tag: a fully-qualified tag for the passage: "Passage" | "Passage-GameOver"
// - Cross-references: ch_<chapter>.scn_<scene>.pNN_<kind>_<slug>
// - Slugs: lowercase, snake_case, concise, 20 characters or less
//
// Relationships:
// - Treat directionality as plot continuity, as if answering "because..." into the next node.
// - Treat nodes with multiple afferent relationships as complimenting narrative, as if stating "and..." into the connected nodes.
// - Treat nodes with multiple efferent relationships as re-visiting the narrative topic with new information.
//      - Avoid infinite narrative recursion by ensuring that the narrative is always progressing.
//

workspace "Plot Graph" "A narrative graph for \"Strangers in the Attic\"" {

    !identifiers hierarchical
    
    model {
        ch_start = softwareSystem "Start" {
            scn_attic = container "Attic Encounter" {
                p01_rg_still_arrival = component "P01" "Leon sits hunched in the cold attic. Your shadow settles near the beam; the world map and backpack memory tug at you. He notices your presence without turning." "Stress +2" "Passage"
                p02_rg_box_babysocks = component "P02" "A taped cardboard box near his feet leaks a pair of baby socks. Dust lifts as you angle closer; he follows your gaze, a tremor passing through his jaw." "Stress +4" "Passage"
                p03_rg_hold_gaze = component "P03" "You hold the gaze on his averted face. Slow blinks meet you; he steadies as if practicing Stoicism, fingers worrying a frayed sleeve along the beam. A quiet prayer hovers between breaths." "Stress -4, Anger -2" "Passage"
                p04_rg_count_breaths = component "P04" "You count your breaths; a prayer rhythm threads the silence. His shoulders lower a notch; Stoic breath in, breath out—the attic's chill rides your exhale across the dust." "Stress -8, Anger -4" "Passage"
                p05_rg_point_map = component "P05" "You point toward the curled world map tacked crooked under a hinge. He squints, then looks away; travel dreams sour under the weight of divorce." "Stress +2, Anger +4" "Passage"
                p06_rg_lower_gaze_box = component "P06" "You lower your gaze, tracing the cardboard seam back to the baby socks box. He swallows; the rented-out home years flicker like light through boards." "Stress +6" "Passage"
                p07_rg_trace_dust = component "P07" "With one finger you trace a circle in the dust on the floorboard. The motion steadies him; breath matches yours, and the beam creaks softer." "Stress -6" "Passage"
                p08_rg_rest_beam = component "P08" "You rest a hand on the beam beside him; he glances without flinching. A fragile trust tests whether quiet company can hold." "Stress -4, Anger -2" "Passage"
                p09_rg_pick_socks = component "P09" "You pick up the baby socks from the box lip. Fabric is weightless; his eyes wet, a life deferred gathers in your palm." "Stress +4, Anger +6" "Passage"
                p10_rg_touch_shoulder = component "P10" "You touch Leon's shoulder lightly; the bone under cloth is sharp. The contact threatens his brittle calm, but it could also ground him." "Stress +6, Anger +10" "Passage"
                p11_rg_touch_forearm = component "P11" "You touch Leon's forearm, palm warm on a map of veins. He freezes, measuring you against old harms." "Stress +8, Anger +12" "Passage"
                p12_rg_brush_sleeve = component "P12" "You brush Leon's sleeve as if to smooth lint; breath stalls, eyes glaze with memories he'd rather not unpack here." "Stress +6, Anger +12" "Passage"
                p13_go_shove_break = component "P13" "He jerks and shoves you hard. The beam and dust blur as your heel slips on the stair lip; the attic swallows sound before the floor does." "" "Passage-GameOver"
                p14_go_strike_burst = component "P14" "A brittle scream breaks; he swings the loose beam blindly and catches you at the temple. Light snaps out; dust keeps falling without you." "" "Passage-GameOver"
                p15_rg_hr_memory = component "P15" "His eyes fix on nothing; the HR video call glare returns, cardboard box in lap, a career dropped into a silence heavier than this room." "Stress +6, Anger +2" "Passage"
                p16_rg_tibetan_calm = component "P16" "You settle into stillness as if recalling Tibetan Buddhism lessons. His breath evens; a minor mercy threads the rafters." "Stress -10, Anger -6" "Passage"

                # Relationships (actions and timers)
                p01_rg_still_arrival -> p02_rg_box_babysocks "Act: Glance at the box"
                p01_rg_still_arrival -> p03_rg_hold_gaze "timer"

                p03_rg_hold_gaze -> p04_rg_count_breaths "Act: Count your breaths"
                p03_rg_hold_gaze -> p04_rg_count_breaths "timer"
                p04_rg_count_breaths -> p06_rg_lower_gaze_box "Act: Lower your gaze"

                p02_rg_box_babysocks -> p09_rg_pick_socks "Act: Pick up the baby socks"
                p02_rg_box_babysocks -> p06_rg_lower_gaze_box "timer"

                p07_rg_trace_dust -> p08_rg_rest_beam "Act: Rest a hand on the beam"
                p07_rg_trace_dust -> p08_rg_rest_beam "timer"

                p08_rg_rest_beam -> p05_rg_point_map "Act: Point to the world map"
                p08_rg_rest_beam -> p07_rg_trace_dust "timer"

                p05_rg_point_map -> p13_go_shove_break "Act: Step back"
                p05_rg_point_map -> p07_rg_trace_dust "timer"
                p05_rg_point_map -> p15_rg_hr_memory "timer, visited(p05_rg_point_map) >= 2"

                p06_rg_lower_gaze_box -> p07_rg_trace_dust "Act: Shift your weight"
                p06_rg_lower_gaze_box -> p07_rg_trace_dust "timer"

                p09_rg_pick_socks -> p05_rg_point_map "Act: Point to the hinge"
                p09_rg_pick_socks -> p05_rg_point_map "timer"

                # Touch sequences branch by thresholds via timers from the touch passages
                p08_rg_rest_beam -> p10_rg_touch_shoulder "Act: Touch Leon's shoulder"
                p10_rg_touch_shoulder -> p13_go_shove_break "timer, Anger > 35 || Stress > 60"
                p10_rg_touch_shoulder -> p11_rg_touch_forearm "timer, Anger <= 35 && Stress <= 60"
                p10_rg_touch_shoulder -> p12_rg_brush_sleeve "Act: Brush Leon's sleeve"

                p11_rg_touch_forearm -> p14_go_strike_burst "timer, Anger > 35 || Stress > 60"
                p11_rg_touch_forearm -> p12_rg_brush_sleeve "timer, Anger <= 35 && Stress <= 60"
                p11_rg_touch_forearm -> p03_rg_hold_gaze "Act: Hold the gaze"

                p12_rg_brush_sleeve -> p14_go_strike_burst "timer, Anger > 35 || Stress > 60"
                p12_rg_brush_sleeve -> p15_rg_hr_memory "timer, Anger <= 35 && Stress <= 60"
                p12_rg_brush_sleeve -> p11_rg_touch_forearm "Act: Touch Leon's forearm"

                # Unlocks on calmer loops
                p04_rg_count_breaths -> p08_rg_rest_beam "timer"
                p04_rg_count_breaths -> p16_rg_tibetan_calm "timer, visited(p04_rg_count_breaths) >= 2"

                p16_rg_tibetan_calm -> p08_rg_rest_beam "timer"
                p15_rg_hr_memory -> p07_rg_trace_dust "timer"
                p15_rg_hr_memory -> p07_rg_trace_dust "Act: Sit on the floor"
                p16_rg_tibetan_calm -> p08_rg_rest_beam "Act: Place both hands on knees"
            }
        }
        ch_lost = softwareSystem "Lost" {
            scn_feeling_stuck = container "Feeling stuck" {
                p01_rg_bridge_forward = component "P01" "The attic hush in his chest turns to a heavier room; he weighs starting again or letting rot spread. Your stillness keeps pace as he edges toward naming the next wound." "Stress +4" "Passage"
            }
            
            # Cross-chapter progression from Start → Lost
            # [example] ch_start.scn_attic.passage -> scn_feeling_stuck.passage "Player action"
            ch_start.scn_attic.p16_rg_tibetan_calm -> scn_feeling_stuck.p01_rg_bridge_forward "timer"
            scn_job = container "Lost job"
            scn_dead_dreams = container "Dead dreams of raising a family"
            scn_marriage = container "Lost marriage"
            
             
            # TODO: Replace with low-level implied relationships.
            scn_feeling_stuck -> scn_job
            ch_lost.scn_feeling_stuck.p01_rg_bridge_forward -> scn_job "timer"
            scn_feeling_stuck -> scn_dead_dreams
            scn_feeling_stuck -> scn_marriage
            scn_job -> scn_dead_dreams
            scn_job -> scn_marriage
            scn_dead_dreams -> scn_marriage
            scn_marriage -> scn_dead_dreams
        
        }
        ch_family = softwareSystem "Family"
        ch_marriage = softwareSystem "Marriage"
        ch_ltr = softwareSystem "Long-term Relationship"

        # Overall thematic progression
        # TODO: Replace with low-level implied relationships.
        //ch_start -> ch_lost
        ch_lost -> ch_family
        ch_family -> ch_marriage
        ch_marriage -> ch_ltr

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

        container ch_start "Chapter-Start" "Testing View 1" {
            include "element.type==Container && ->element.parent==ch_start->"
            autolayout
        }

        container ch_lost "Chapter-Lost" "Testing View 2"{
            include "element.type==Container && ->element.parent==ch_lost->"
            autolayout
        }

        component ch_start.scn_attic {
            include "element.type==Component && ->element.parent==ch_start.scn_attic->"
            autolayout
        }

        component ch_lost.scn_feeling_stuck {
            include "element.type==Component && ->element.parent==ch_lost.scn_feeling_stuck->"
            autolayout
        }

        systemlandscape "System-Landscape" "Story Chapters" {
            include *
            autolayout
        }
    }
}