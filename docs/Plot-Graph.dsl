workspace "Plot Graph" "A narrative graph for \"Strangers in the Attic\"" {

    !identifiers flat
    

    model {
        s0 = softwareSystem "Start" {
            n0 = container "Encounter in an empty attic" {
                c0 = component "Passage1" "Hears a voice" "" "Passage"
                c1 = component "Passage2" "Feels a presence" "" "Passage"
                c2 = component "Passage3" "Reacts with fear threshold" "" "Passage-Eval"
                c3 = component "Passage4" "Panics" "" "Passage-GameOver"
                c4 = component "Passage5" "Heart attack" "" "Passage-GameOver"

                c0 -> c2
                c2 -> c3
                c2 -> c4
                c2 -> c1
                
            }
        }
        s1 = softwareSystem "Lost" {
            n3 = container "Feeling stuck" {
                c5 = component "Passage6" "Mumble in grief" "" "Passage"
                c1 -> c5
            }
            n4 = container "Lost job"
            n5 = container "Dead dreams of raising a family"
            n48 = container "Lost marriage"
            
             
            n3 -> n4
            n3 -> n5
            n3 -> n48
            n4 -> n5
            n4 -> n48
            n5 -> n48
            n48 -> n5
        
        }
        s2 = softwareSystem "Family"
        s3 = softwareSystem "Marriage"
        s9 = softwareSystem "Long-term Relationship"

        # Overall thematic progression
        //s0 -> s1
        s1 -> s2
        s2 -> s3
        s3 -> s9

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
        }

        container s0 "Chapter-Start" "Testing View 1" {
            include "element.type==Container && ->element.parent==s0->"
            autolayout
        }

        container s1 "Chapter-Lost" "Testing View 2"{
            include "element.type==Container && ->element.parent==s1->"
            autolayout
        }

        component n0 {
            include "element.type==Component && ->element.parent==n0->"
            autolayout
        }

        component n3 {
            include "element.type==Component && ->element.parent==n3->"
            autolayout
        }

        systemlandscape "System-Landscape" "Story Chapters" {
            include *
            autolayout
        }
    }
}