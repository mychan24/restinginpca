# restinginpca

> A powerful distraction from real work.

### GOAL
Develop a technique that could analyze resting-state data and allow different participant to have different number of voxels/nodes.

### Solution to test for
If, instead of using the square correlation (or distance) matrix, we arrange data as condition x (regions x participants). In this case, we can concatenate data of different participants on the columns (we think).
##### Problem
But how do we know what the svd of this gives us, and how is this different from a DiSTATIS on distance matrices? 

### DATA WE WISH TO ANALYZE
condition x (region x participants)

### DATA WE USED TO TEST
+ Big5 FakeData: for STATIS-like normalization
+ Midnight Scan Club (MSC) publice online resting state data: for testing the normalization with multi-condition/multi-subject data

### HOW
##### New normalization that we come up with (Big5)
+ STATIS-like normalization

⋅⋅⋅So we test this first on one correlation matrix

##### Starts from data with same number of nodes (MSC)
+ Run DiSTATIS on an one-subject sample and use this results as an example of what we want to replicate
⋅⋅⋅Data structure for one-subject sample: regions x regions x sessions
+ Try different normalization with subjects 1:
⋅⋅⋅Rectangular data structure: 10 sessions x region-region edges

⋅⋅⋅1. No normalization -> plain SVD

⋅⋅⋅2. SVD after the columns are centered (center across rows)

⋅⋅⋅3. SVD on STATIS-like preprocessed rectangular matrix

⋅⋅⋅4. Subject(table)-centered, block (network) MFA-normalized rectangular matrix

+ Run DiSTATIS on a fake two-subject sample and use this results as an example of what we want to replicate when multiple subjects are involved
⋅⋅⋅Data structure for the fake two-subject sample: regions x regions x (sessions 1-5 of subjects 1 as fake sub1 and sessions 6-10 of subject 1 as fake sub2)
⋅⋅⋅Blocks on tables
+ Try different normalization with fake multi-subjects data:
⋅⋅⋅Rectangular data structure: 5 sessions x (region-region edges x fake subjects 1 and 2)

⋅⋅⋅1. No normalization -> plain SVD

⋅⋅⋅2. SVD after the columns are centered (center across rows)

⋅⋅⋅3. SVD on STATIS-like preprocessed rectangular matrix

⋅⋅⋅4. Subject(table)-centered, block (network) MFA-normalized rectangular matrix