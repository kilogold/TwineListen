## Instructions
How to use the provided story graph:
- Edges = Treat directionality as plot continuity, as if answering "because..." into the next node. Treat nodes with multiple edges as complimenting narrative, as if stating "and..." into the connected nodes.
- Bidirectional Edges = Treat the same as edges, but preserve progression by avoiding recursive loops, discard node-revisits.
- Subgraphs = Story chapters. Each chapter represents a thematic progression of the story.

## Graph
```mermaid
---
config:
  theme: dark
  layout: fixed
---
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
        n13["Sexually neglect my wife"]
        n12["Heartbreak"]
        n14["I was coerced into an<br>Open Relationship"]
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
 subgraph s4["Adult Singlehood"]
        n22["Herpes"]
        n24["Promiscuity"]
        n39["PUA<br>Manipulation"]
        n44["Lost self-worth"]
        n47["Lost friends<br>(Jeb)"]
  end
 subgraph s5["First Sexual Relationship"]
        n23["Incredible sex"]
        n25["Avoidant behavior<br>breakup"]
        n41["Porn addiction"]
        n42["Learned I cannot <br>influence others <br>to stay"]
        n43["Rape guilt"]
  end
 subgraph s6["Teenage years"]
        n26["Learning<br>sexual behavior"]
        n33["Excessive <br>masturbation"]
        n35["Early signs <br>of addiction"]
        n36["First breakup"]
        n37["Earning approval"]
  end
 subgraph s8["End"]
        n28["Leaves to find himself"]
        n29(["End"])
  end
 subgraph s9["Long-term Relationship"]
        n45["Unhealthy conflict <br>resolution skills"]
        n46["Marriage <br>Proposal<br>under duress"]
        n53@{ label: "Wife's<br>non-citizen<br>deportation<br>risk<br>" }
  end
 subgraph s10["Childhood"]
        n27["Connected with God"]
        n34["Discover porn"]
        n30["Emotional<br>neglect"]
        n31["Emotional Retreat"]
        n32["Earning <br>affection"]
        n40["Sibling preference"]
        n38["Performing <br>to be seen"]
  end
 subgraph s11["Start"]
        A(["Start"])
        n6["Encounter in <br>an empty attic"]
  end
    A --> n6
    n3 --> n4 & n5 & n48
    n6 --> n3
    n7 --> n9
    n5 --> n7 & n8
    n28 --> n29
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
    n48@{ shape: rect}
    n8@{ shape: rect}
    n13@{ shape: rect}
    n12@{ shape: rect}
    n14@{ shape: rect}
    n15@{ shape: rect}
    n16@{ shape: rect}
    n17@{ shape: rect}
    n18@{ shape: rect}
    n19@{ shape: rect}
    n20@{ shape: rect}
    n21@{ shape: rect}
    n49@{ shape: rect}
    n50@{ shape: rect}
    n24@{ shape: rect}
    n39@{ shape: rect}
    n44@{ shape: rect}
    n47@{ shape: rect}
    n25@{ shape: rect}
    n41@{ shape: rect}
    n42@{ shape: rect}
    n43@{ shape: rect}
    n33@{ shape: rect}
    n35@{ shape: rect}
    n36@{ shape: rect}
    n37@{ shape: rect}
    n28@{ shape: rect}
    n46@{ shape: rect}
    n53@{ shape: rect}
    n27@{ shape: rect}
    n34@{ shape: rect}
    n30@{ shape: rect}
    n31@{ shape: rect}
    n32@{ shape: rect}
    n40@{ shape: rect}
    n38@{ shape: rect}

```    