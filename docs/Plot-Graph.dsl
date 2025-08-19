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
                # [example] p01_rg_still_arrival = component "P01" "Leon sits hunched in the cold attic. Your shadow settles near the beam; the world map and backpack memory tug at you. He notices your presence without turning." "Stress +2" "Passage"

                p01_rg_arrival_view = component "P01" "A cold empty attic in an old house near a river wraps you in stillness. It's night time, shadows or spirits seem to lurk, and only you and Leon occupy this airless space." "Stress +4" "Passage"
                p02_rg_shadows_listen = component "P02" "You hold in the dark as shadows or spirits toy with the edges of sight. Only Leon and the player are initially present; the room measures your patience while you listen." "Stress +4" "Passage"
                p03_rg_centered_leon = component "P03" "Leon sits at the center of the attic, hunched over, withered and frail. His mind is still pacing; the posture reads like a confession pressed into wood and dust." "Stress +6" "Passage"
                p04_rg_floor_attention = component "P04" "The cold empty attic breathes through the old house boards; you trace the grain, steadying yourself as night seeps in and the river's distance tightens your chest." "Stress +4" "Passage"
                p05_rg_edge_of_presence = component "P05" "Only Leon and the player are initially present, and it's night time. You tilt your head toward him as his mind keeps pacing in silence, the room barely holding it." "Stress +6" "Passage"
                p06_rg_kneel_beside = component "P06" "You kneel beside Leon at the center of the attic. He remains hunched over and frail; the cold empty attic funnels your attention into the small space between you." "Stress +6, Anger +2" "Passage"
                p07_rg_touch_tension = component "P07" "Close now, you read the withered shoulders and the quielty muttering. Touch could steady him or break him; his mind is still pacing under the weight of night." "Stress +6, Anger +12" "Passage"
                p08_rg_step_back_shadow = component "P08" "You step back into shadows as if spirits might mediate. The old house creaks; the river is somewhere out there, but the attic keeps you both inside its hush." "Stress -4" "Passage"
                p09_go_shove = component "P09" "Your touch jolts Leon. He surges with sudden, brittle force; the attic snaps to violence and the night ends with your body against the boards and breath cut short." "" "Passage-GameOver"
                p10_rg_calm_the_air = component "P10" "You rest a palm on your chest and count the cold empty attic breaths. His withered frame eases a notch; the center of the room loosens as the night holds steady." "Stress -8, Anger -4" "Passage"
                p11_go_collapse = component "P11" "Leon slumps forward and does not rise. Frail bones meet wood; the silence becomes final and the attic swallows your presence as if only shadows or spirits remain." "" "Passage-GameOver"
                p12_rg_listen_mutter = component "P12" "You listen in silence to the quielty muttering, a mind still pacing. The old house night frames his breath; only you and he exist within this narrow orbit." "Stress -4" "Passage"
                p13_rg_floorboard_steady = component "P13" "A loose board shifts; you steady it with care, keeping to the edges. The cold empty attic offers no guidance but the river's far rhythm steadies your hands." "Stress -2" "Passage"
                p14_go_suffocate = component "P14" "The room compresses; Leon's panic rides the night until your lungs fail to find pace. The attic closes like a lid; you black out to the whisper of distant water." "" "Passage-GameOver"

                // Relationships (actions from Scene Brief) and timers
                p01_rg_arrival_view -> p02_rg_shadows_listen "timer"
                p01_rg_arrival_view -> p04_rg_floor_attention "Act: trace finger along floorboard"

                p02_rg_shadows_listen -> p03_rg_centered_leon "timer"
                p02_rg_shadows_listen -> p08_rg_step_back_shadow "Act: step back into shadows"

                p03_rg_centered_leon -> p05_rg_edge_of_presence "timer"
                p03_rg_centered_leon -> p06_rg_kneel_beside "Act: kneel beside Leon"

                p04_rg_floor_attention -> p05_rg_edge_of_presence "timer"
                p04_rg_floor_attention -> p13_rg_floorboard_steady "Act: steady a loose floorboard"

                p05_rg_edge_of_presence -> p07_rg_touch_tension "timer"
                p05_rg_edge_of_presence -> p12_rg_listen_mutter "Act: listen in silence"

                p06_rg_kneel_beside -> p07_rg_touch_tension "timer"
                p06_rg_kneel_beside -> p10_rg_calm_the_air "Act: rest palm on chest"

                p07_rg_touch_tension -> p09_go_shove "Act: touch Leon's shoulder, Anger > 35 || Stress > 60"
                p07_rg_touch_tension -> p10_rg_calm_the_air "Act: touch Leon's shoulder, Anger <= 35 && Stress <= 60"
                p07_rg_touch_tension -> p11_go_collapse "Act: touch Leon's back, Anger > 35 || Stress > 60"
                p07_rg_touch_tension -> p12_rg_listen_mutter "Act: touch Leon's hand, Anger <= 35 && Stress <= 60"
                p07_rg_touch_tension -> p08_rg_step_back_shadow "timer"

                p08_rg_step_back_shadow -> p12_rg_listen_mutter "timer"
                p08_rg_step_back_shadow -> p03_rg_centered_leon "Act: slide note closer"

                p10_rg_calm_the_air -> p12_rg_listen_mutter "timer"
                p10_rg_calm_the_air -> p03_rg_centered_leon "Act: tilt head toward Leon"

                p12_rg_listen_mutter -> p04_rg_floor_attention "timer"
                p12_rg_listen_mutter -> p06_rg_kneel_beside "Act: kneel beside Leon"

                p13_rg_floorboard_steady -> p05_rg_edge_of_presence "timer"
                p13_rg_floorboard_steady -> p01_rg_arrival_view "Act: brush dust from floor"

                // A risk timer that can escalate to suffocation if sustained stress is high
                p05_rg_edge_of_presence -> p14_go_suffocate "timer, Stress > 60"
            }
        }
        ch_lost = softwareSystem "Lost" {
            scn_feeling_stuck = container "Feeling stuck" {
                p01_rg_bridge_forward = component "P01" "A placeholder forward bridge from Feeling stuck to later scenes; used to satisfy model wiring until the scene is authored." "" "Passage"
            }
            
            # Cross-chapter progression from Start → Lost
            # [example] ch_start.scn_attic.passage -> scn_feeling_stuck.passage "Player action"
            ch_start.scn_attic.p12_rg_listen_mutter -> ch_lost.scn_feeling_stuck.p01_rg_bridge_forward "timer"
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