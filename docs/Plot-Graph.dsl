// Nomenclature:
// - Chapters (softwareSystem): ch_<chapter_slug>
// - Scenes (container): scn_<scene_slug>
// - Passages (component): pNN_<kind>_<slug>
//     - NN: two-digit sequence number (01, 02, ...)
//     - kind: rg | ev | go
//         - rg: regular passage (tag "Passage")
//         - ev: evaluation/decision (tag "Passage-Eval")
//         - go: game over (tag "Passage-GameOver")
// - Display names: short code (e.g., "P01"); second label is human-readable
// - Cross-references: ch_<chapter>.scn_<scene>.pNN_<kind>_<slug>
// - Slugs: lowercase, snake_case, concise
// Relationships:
// - Treat directionality as plot continuity, as if answering "because..." into the next node.
// - Treat nodes with multiple afferent relationships as complimenting narrative, as if stating "and..." into the connected nodes.
// - Treat nodes with multiple efferent relationships as re-visiting the narrative topic with new information.
//      - Avoid infinite narrative recursion by ensuring that the narrative is always progressing.

workspace "Plot Graph" "A narrative graph for \"Strangers in the Attic\"" {

    !identifiers hierarchical
    
    model {
        ch_start = softwareSystem "Start" {
            scn_attic = container "Encounter in an empty attic" {
                p01_rg_hears_voice = component "P01" "Hears a voice" "" "Passage"
                p02_rg_feels_presence = component "P02" "Feels a presence" "" "Passage"
                p03_eval_fear = component "P03" "Reacts with Stress threshold" "" "Passage-Eval"
                p04_go_panics = component "P04" "Panics" "" "Passage-GameOver"
                p05_go_heart_attack = component "P05" "Heart attack" "" "Passage-GameOver"

                p01_rg_hears_voice -> p03_eval_fear
                p03_eval_fear -> p04_go_panics "40% <= Stress <= 60%"
                p03_eval_fear -> p05_go_heart_attack "60% < Stress"
                p03_eval_fear -> p02_rg_feels_presence
                
            }
        }
        ch_lost = softwareSystem "Lost" {
            scn_feeling_stuck = container "Feeling stuck" {
                p06_rg_mumble_grief = component "P06" "Mumble in grief" "" "Passage"
                ch_start.scn_attic.p02_rg_feels_presence -> p06_rg_mumble_grief
            }
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
            element "Passage-Eval" {
                background #695311
                shape diamond
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