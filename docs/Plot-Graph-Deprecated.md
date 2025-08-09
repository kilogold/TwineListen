## Instructions
How to use the provided story graph:
- Edges = Treat directionality as plot continuity, as if answering "because..." into the next node. Treat nodes with multiple edges as complimenting narrative, as if stating "and..." into the connected nodes.
- Bidirectional Edges = Treat the same as edges, but preserve progression by avoiding recursive loops, discard node-revisits.
- Subgraphs = Story chapters. Each chapter represents a thematic progression of the story.

## Graph
```mermaid
flowchart TD
 subgraph s1["Lost"]
        n3["Feeling stuck"]
        n4["Lost job"]
        n5["Dead dreams of raising a family"]
        n48["Lost marriage"]
  end
 subgraph s2["Family"]
        n7["Our desire for <br>raising children"]
        n8@{ label: "Wife's unsurmountable trauma" }
        n9["I achieved <br>self-development <br>growth"]
  end
 subgraph s3["Marriage"]
        n11["Porn addiction"]
        n13["Sexual neglect"]
        n12["Heartbreak"]
        n14["Coerced into an<br>Open Relationship"]
        n15["Infidelity"]
        n16["Abandonment<br>Isolation"]
        n17["Commitment<br>with<br>Uncertainty"]
        n18["Emotional abuse"]
        n19["Rejection"]
        n20["Disgust"]
        n21["Conducted <br>transformative <br>self-work"]
        n49["Realized my <br>own failures"]
        n50["Reached emotional <br>breaking point"]
        n51["Breakup"]
        n52["Emotional immaturity"]
  end
 subgraph s9["Long-term Relationship"]
        n45["Unhealthy conflict <br>resolution skills"]
        n46["Marriage <br>Proposal<br>under duress"]
        n53@{ label: "Wife's<br>non-citizen<br>deportation<br>risk<br>" }
  end
    A(["Start"]) --> n6["Encounter in <br>an empty attic"]
    n3 --> n4 & n5 & n48
    n6 --> n3
    n7 --> n9
    n5 --> n7 & n8
    n9 --> n8 & n21
    n48 --> n5
    n21 --> n50 & n49
    n50 --> n13 & n12 & n19 & n15 & n18 & n16 & n20 & n17
    n49 --> n51
    n51 --> n50
    n18 <--> n8
    n15 --> n11
    n13 --> n11
    n16 --> n11
    n20 --> n14
    n19 --> n11 & n52
    n12 --> n14
    n17 --> n52 & n46
    n46 --> n53 & n45
    n52 <--> n18
    n52 --> n50
```    