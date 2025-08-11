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
                p01_rg_entry_unease = component "P01" "The attic hisses at your outline; he smiles like a cut and asks what you intend to be." "" "Passage"
                p02_rg_terms_of_witness = component "P02" "He sets a witness pact: you stay quiet, you don't mend, and you let the dust decide." "" "Passage"
                p03_rg_measure_breath = component "P03" "He counts your breaths aloud, gauging fog from spine; the test scratches his patience." "Stress +4, Anger +3" "Passage"
                p04_rg_box_at_door = component "P04" "He recalls a final box at the door, a polite dismissal wrapped in winter's neat label." "Stress +6" "Passage"
                p05_rg_name_her_shiver = component "P05" "You suggest her without her name; he flinches, then steadies like a fish learning the hook." "Stress +3, Anger +6" "Passage"
                p06_rg_teeth_in_words = component "P06" "Your posture judges; his words grow teeth and circle, daring you to step one inch nearer." "Anger +10" "Passage"
                p07_rg_listen_plain = component "P07" "He bargains for plain listening; fewer masks if you quit weighing the weight of each word." "Stress -6" "Passage"
                p08_rg_vow_morning = component "P08" "He vows to face morning steady if you count; no rescue, only witness to each landing." "Stress -8" "Passage"
                p09_go_step_into_grab = component "P09" "You reach to help; he misreads and grabs; nails kiss throat; the attic shuts its only eye." "Anger +70" "Passage-GameOver"
                p10_go_fade_in_dust = component "P10" "Silence thickens to paste; lungs forget the trick; the fine dust rents your final breath." "Stress +70" "Passage-GameOver"
                p11_rg_resigned_fast = component "P11" "Resignation paces the beams; he speaks faster so it cannot nest where you are standing." "" "Passage"
                p12_rg_returned_echo = component "P12" "He marks your return's echo and tests what the room remembers that he himself cannot." "" "Passage"
                p13_rg_true_risk = component "P13" "He risks a truer register; beneath every thought a bruise; asks if you can stand it now." "Stress -10, Anger -6" "Passage"
                p14_rg_trapdoor_listen = component "P14" "He points to a warped trapdoor and begs you not to blink while it explains his stuck place." "" "Passage"

                p01_rg_entry_unease -> p02_rg_terms_of_witness "Act: Stay"
                p01_rg_entry_unease -> p06_rg_teeth_in_words "Act: Flinch, Anger > 10 || Stress > 20"
                p01_rg_entry_unease -> p09_go_step_into_grab "Act: Reach to steady him"
                p01_rg_entry_unease -> p03_rg_measure_breath "timer"

                p02_rg_terms_of_witness -> p04_rg_box_at_door "Act: Nod once"
                p02_rg_terms_of_witness -> p06_rg_teeth_in_words "Act: Hold the stare, Stress > 30 || Anger > 15"
                p02_rg_terms_of_witness -> p03_rg_measure_breath "timer"
                p02_rg_terms_of_witness -> p12_rg_returned_echo "Act: Say nothing, visited(P02) >= 2"

                p03_rg_measure_breath -> p04_rg_box_at_door "Act: Admit you're here, 0 <= Stress <= 95"
                p03_rg_measure_breath -> p06_rg_teeth_in_words "Act: Keep your distance"
                p03_rg_measure_breath -> p10_go_fade_in_dust "timer, Stress > 55"

                p04_rg_box_at_door -> p08_rg_vow_morning "Act: Keep a soft gaze, Anger <= 60"
                p04_rg_box_at_door -> p05_rg_name_her_shiver "Act: Ask about her"
                p04_rg_box_at_door -> p06_rg_teeth_in_words "Act: Break eye contact, Anger > 15"
                p04_rg_box_at_door -> p11_rg_resigned_fast "timer"

                p05_rg_name_her_shiver -> p07_rg_listen_plain "Act: Say nothing"
                p05_rg_name_her_shiver -> p06_rg_teeth_in_words "Act: Challenge him, Anger > 25"
                p05_rg_name_her_shiver -> p11_rg_resigned_fast "timer"

                p06_rg_teeth_in_words -> p07_rg_listen_plain "Act: Lower your gaze"
                p06_rg_teeth_in_words -> p04_rg_box_at_door "Act: Soften stance"
                p06_rg_teeth_in_words -> p09_go_step_into_grab "Act: Step closer fast"
                p06_rg_teeth_in_words -> p09_go_step_into_grab "timer, Anger > 35 || Stress > 60"

                p07_rg_listen_plain -> p13_rg_true_risk "Act: Commit to listen, visited(P01) >= 2"
                p07_rg_listen_plain -> p04_rg_box_at_door "Act: Let him continue"
                p07_rg_listen_plain -> p11_rg_resigned_fast "timer"

                p08_rg_vow_morning -> p07_rg_listen_plain "Act: Promise to listen"
                p08_rg_vow_morning -> p11_rg_resigned_fast "timer"

                p11_rg_resigned_fast -> p12_rg_returned_echo "Act: Wait quietly, visited(P01) >= 1"
                p11_rg_resigned_fast -> p04_rg_box_at_door "Act: Ask for detail"
                p11_rg_resigned_fast -> p10_go_fade_in_dust "timer, Stress > 45"
                p11_rg_resigned_fast -> p06_rg_teeth_in_words "Act: Look away, Anger > 40"

                p12_rg_returned_echo -> p13_rg_true_risk "Act: Ask for the true piece"
                p12_rg_returned_echo -> p06_rg_teeth_in_words "Act: Hold the stare, Anger > 50"
                p12_rg_returned_echo -> p11_rg_resigned_fast "timer"

                p13_rg_true_risk -> p14_rg_trapdoor_listen "Act: Follow the hinge"
                p13_rg_true_risk -> p06_rg_teeth_in_words "Act: Make him justify"
                p13_rg_true_risk -> p11_rg_resigned_fast "timer"
            }
        }
        ch_lost = softwareSystem "Lost" {
            scn_feeling_stuck = container "Feeling stuck" {
                p15_rg_mumble_grief = component "P15" "Mumble in grief" "" "Passage"
            }
            
            # Cross-references: chapter progression from Start → Lost
            ch_start.scn_attic.p14_rg_trapdoor_listen -> scn_feeling_stuck.p15_rg_mumble_grief "Act: Keep listening"
            ch_start.scn_attic.p14_rg_trapdoor_listen -> scn_feeling_stuck.p15_rg_mumble_grief "timer"
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