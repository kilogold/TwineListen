// [Instructions/Guide]
// Summary:
// This Structurizr DSL C4 model is adapted for interactive narrative building. 
// It is unconventional, but works for rendering a story graph via Structurizr.
//
// Nomenclature:
// - Chapters (softwareSystem): ch_<chapter_slug>
// - Scenes (container): scn_<scene_slug>
// - Passages (component): pNN_<kind>_<slug> <display-name> <description> <status-effect> <tag>
//     - Naming convention:
//         - NN: two-digit sequence number (01, 02, ...)
//         - kind: rg | go
//             - rg: regular passage (tag "Passage")
//             - go: game over (tag "Passage-GameOver")
//     - Parameters:
//         - display-name: a short code (e.g., "P01"); second label is human-readable
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
            scn_attic = container "Encounter in an empty attic" {
                p01_rg_attic_breath = component "P01" "He hears a breath not his; speaks as if to a witness he half-invents." "" "Passage"
                p02_rg_set_terms = component "P02" "He sets a rule: no fixing, only witnessing; asks if you can bear that." "" "Passage"
                p03_rg_check_for_judgment = component "P03" "He checks your face for judgment; wonders if staying here disgusts you." "Stress +3" "Passage"
                p04_rg_trade_for_presence = component "P04" "He offers detail for presence; you stay, he peels back what's raw." "Stress -2" "Passage"
                p05_rg_bristle_at_stillness = component "P05" "Your quiet feels like verdict; his shoulders rise, words sharpen." "Anger +6" "Passage"
                p06_rg_confess_lost_work = component "P06" "He describes losing the job; vision dulled by home fires he couldn't tame." "Stress +4" "Passage"
                p07_rg_confess_lost_home = component "P07" "He admits the marriage broke; says he chose the cut to stop the bleed." "Stress +4" "Passage"
                p08_rg_name_small_hope = component "P08" "He wants to stand up without shaking; asks if that sounds childish." "Stress -4" "Passage"
                p09_go_pick_a_fight = component "P09" "He tackles your shadow; rafters shear; the beam crushes your skull like wet wood." "Anger +60" "Passage-GameOver"
                p10_go_drown_in_air = component "P10" "Air congeals; he drags you down; lungs tear, lips blue, and your body goes still." "Stress +60" "Passage-GameOver"
                p11_rg_invite_real_listen = component "P11" "He invites real listening; promises not to perform if you don't." "Stress -3" "Passage"
                p12_rg_tread_above_resign = component "P12" "Resignation pats his knee; he keeps talking to keep it from sitting." "" "Passage"
                p13_rg_mark_return = component "P13" "He marks your return; decides maybe memory can be stitched, not erased." "" "Passage"
                p14_rg_second_visit_truth = component "P14" "Only later he names the worst piece and how it still hums at night." "Stress -6, Anger -6" "Passage"

                p01_rg_attic_breath -> p02_rg_set_terms "Act: Stay"
                p01_rg_attic_breath -> p05_rg_bristle_at_stillness "Act: Look away, 40% < Anger || 50% < Stress"
                p01_rg_attic_breath -> p03_rg_check_for_judgment "timer"

                p02_rg_set_terms -> p04_rg_trade_for_presence "Act: Nod once"
                p02_rg_set_terms -> p05_rg_bristle_at_stillness "Act: Stare too long, 50% < Stress || 40% < Anger"
                p02_rg_set_terms -> p03_rg_check_for_judgment "timer"

                p03_rg_check_for_judgment -> p06_rg_confess_lost_work "Act: Admit you're here, 20% <= Stress <= 60%"
                p03_rg_check_for_judgment -> p05_rg_bristle_at_stillness "Act: Keep your distance"
                p03_rg_check_for_judgment -> p10_go_drown_in_air "timer, 70% < Stress"

                p04_rg_trade_for_presence -> p08_rg_name_small_hope "Act: Keep a soft gaze, Anger <= 30%"
                p04_rg_trade_for_presence -> p05_rg_bristle_at_stillness "Act: Break eye contact, 40% < Anger"
                p04_rg_trade_for_presence -> p12_rg_tread_above_resign "timer"

                p05_rg_bristle_at_stillness -> p11_rg_invite_real_listen "Act: Lower your gaze"
                p05_rg_bristle_at_stillness -> p04_rg_trade_for_presence "Act: Soften stance"
                p05_rg_bristle_at_stillness -> p09_go_pick_a_fight "timer, 60% < Anger || 80% < Stress"

                p06_rg_confess_lost_work -> p07_rg_confess_lost_home "Act: Encourage him to continue"
                p06_rg_confess_lost_work -> p12_rg_tread_above_resign "timer"

                p07_rg_confess_lost_home -> p11_rg_invite_real_listen "Act: Say nothing"
                p07_rg_confess_lost_home -> p05_rg_bristle_at_stillness "Act: Challenge him, 50% < Anger"
                p07_rg_confess_lost_home -> p12_rg_tread_above_resign "timer"

                p08_rg_name_small_hope -> p11_rg_invite_real_listen "Act: Promise to listen"
                p08_rg_name_small_hope -> p12_rg_tread_above_resign "timer"

                p11_rg_invite_real_listen -> p14_rg_second_visit_truth "Act: Promise to listen, visited(P01) >= 2"
                p11_rg_invite_real_listen -> p06_rg_confess_lost_work "Act: Let him continue"
                p11_rg_invite_real_listen -> p12_rg_tread_above_resign "timer"

                p12_rg_tread_above_resign -> p13_rg_mark_return "Act: Wait quietly, visited(P01) >= 2"
                p12_rg_tread_above_resign -> p10_go_drown_in_air "timer, 70% < Stress"
                p12_rg_tread_above_resign -> p05_rg_bristle_at_stillness "Act: Look away, 50% < Anger"

                p13_rg_mark_return -> p14_rg_second_visit_truth "Act: Nod quickly"
                p13_rg_mark_return -> p05_rg_bristle_at_stillness "Act: Hold the stare, 60% < Anger"
                p13_rg_mark_return -> p12_rg_tread_above_resign "timer"

                
                
            }
        }
        ch_lost = softwareSystem "Lost" {
            scn_feeling_stuck = container "Feeling stuck" {
                p06_rg_mumble_grief = component "P06" "Mumble in grief" "" "Passage"
            }
            
            # Cross-chapter progression from Start → Lost
            ch_start.scn_attic.p14_rg_second_visit_truth -> scn_feeling_stuck.p06_rg_mumble_grief "Act: Keep listening"
            ch_start.scn_attic.p14_rg_second_visit_truth -> scn_feeling_stuck.p06_rg_mumble_grief "timer"
            scn_job = container "Lost job"
            scn_dead_dreams = container "Dead dreams of raising a family"
            scn_marriage = container "Lost marriage"
            
             
            # TODO: Replace with low-level implied relationships.
            scn_feeling_stuck -> scn_job
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